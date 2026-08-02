import { BaseHttpClient } from "@/utils/http/baseHttpClient";

export type ISoapResponse<T> = Readonly<{
  success: boolean;
  data?: T;
  error?: string;
  rawResponse?: string;
}>;

export type XmlPrimitive =
  | string
  | number
  | boolean
  | bigint
  | Date
  | null
  | undefined;

export type XmlCData = Readonly<{
  cdata: string;
}>;

export type XmlValue = XmlPrimitive | XmlCData | XmlObject | XmlValue[];

export type XmlObject = {
  [key: string]: XmlValue;
};

class SoapClient extends BaseHttpClient {
  private hasXmlParserError(document: Document): boolean {
    return (
      document.getElementsByTagNameNS("*", "parsererror").length > 0 ||
      document.getElementsByTagName("parsererror").length > 0
    );
  }

  private findSoapBody(document: Document): Element | null {
    return (
      Array.from(document.getElementsByTagName("*")).find(
        (element) => (element.localName ?? element.tagName) === "Body",
      ) ?? null
    );
  }

  async call<T>(
    endpoint: string,
    soapAction: string,
    payload: string,
    token: string,
    options?: RequestInit,
  ): Promise<ISoapResponse<T>> {
    try {
      if (!payload.trim()) {
        return {
          success: false,
          error: "Se requiere un payload XML válido",
        };
      }

      const response = await this.execute(endpoint, {
        method: "POST",
        headers: {
          SOAPAction: soapAction,
          "Content-Type": "text/xml; charset=utf-8",
          Accept: "text/xml",
          ...(token && {
            Authorization: `Bearer ${token}`,
          }),
          ...options?.headers,
        },
        body: payload,
        ...options,
      });

      const rawResponse = await response.text();

      const xmlDoc = new DOMParser().parseFromString(rawResponse, "text/xml");

      if (this.hasXmlParserError(xmlDoc)) {
        return {
          success: false,
          error: "XML inválido",
          rawResponse,
        };
      }

      const body = this.findSoapBody(xmlDoc);
      const responseNode = body?.children[0];

      if (!responseNode) {
        return {
          success: false,
          error: "Respuesta SOAP vacía",
          rawResponse,
        };
      }

      const data = this.nodeToObject(responseNode) as T;

      return {
        success: true,
        data,
        rawResponse,
      };
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : "Error desconocido",
      };
    }
  }

  private isXmlString(value: string): boolean {
    const trimmed = value.trim();
    return trimmed.startsWith("<") && trimmed.endsWith(">");
  }

  private parseXmlText(value: string): XmlValue {
    const trimmed = value.trim();
    if (!trimmed) return "";

    if (!this.isXmlString(trimmed)) {
      return trimmed;
    }

    const document = new DOMParser().parseFromString(trimmed, "text/xml");
    if (this.hasXmlParserError(document)) {
      return trimmed;
    }

    const root = document.documentElement;
    return root ? this.nodeToObject(root) : trimmed;
  }

  nodeToObject(node: Element): XmlValue {
    const obj: XmlValue = {};

    for (const child of Array.from(node.children)) {
      const key = child.localName ?? child.tagName;

      const value =
        child.children.length > 0
          ? this.nodeToObject(child)
          : this.parseXmlText(child.textContent ?? "");

      if (obj[key]) {
        obj[key] = Array.isArray(obj[key])
          ? [...obj[key], value]
          : [obj[key], value];
      } else {
        obj[key] = value;
      }
    }

    return obj;
  }
}

export const soap = new SoapClient();
