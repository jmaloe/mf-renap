import { BaseHttpClient } from "@/utils/http/baseHttpClient";

class HttpClient extends BaseHttpClient {
  private parseXmlTextToObject<T>(xmlText: string): T {
    const parser = new DOMParser();
    const xml = parser.parseFromString(xmlText, "text/xml");

    const hasParserError =
      xml.getElementsByTagName("parsererror").length > 0 ||
      xml.getElementsByTagNameNS("*", "parsererror").length > 0;

    if (hasParserError) {
      throw new Error("Respuesta XML inválida");
    }

    const root = xml.documentElement;
    if (!root) {
      return {} as T;
    }

    const parseElement = (element: Element): unknown => {
      const attributes = Object.fromEntries(
        Array.from(element.attributes).map((attr) => [attr.name, attr.value]),
      );

      const children = Array.from(element.children);
      if (children.length === 0) {
        const textValue = (element.textContent ?? "").trim();

        if (Object.keys(attributes).length > 0) {
          return {
            ...attributes,
            ...(textValue ? { value: textValue, descripcion: textValue } : {}),
          };
        }

        return textValue;
      }

      const parsed: Record<string, unknown> = { ...attributes };

      for (const child of children) {
        const key = child.localName ?? child.tagName;
        const value = parseElement(child) as unknown;

        if (Object.prototype.hasOwnProperty.call(parsed, key)) {
          const current = parsed[key];
          parsed[key] = Array.isArray(current)
            ? [...current, value]
            : [current, value];
          continue;
        }

        parsed[key] = value;
      }

      const textValue = (element.textContent ?? "").trim();
      if (textValue && !children.some((child) => (child.textContent ?? "").trim())) {
        parsed.value = textValue;
        parsed.descripcion = textValue;
      }

      return parsed;
    };

    const rootName = root.localName ?? root.tagName;
    const rootValue = parseElement(root) as Record<string, unknown>;

    return { [rootName]: rootValue } as T;
  }

  async get<T>(
    endpoint: string,
    token: string,
    options?: RequestInit,
  ): Promise<T> {
    const response = await this.execute(endpoint, {
      method: "GET",
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json",
        ...(token && {
          Authorization: `Bearer ${token}`,
        }),
        ...options?.headers,
      },
      ...options,
    });

    return response.json();
  }

  async post<T>(
    endpoint: string,
    token: string,
    data?: unknown,
    options?: RequestInit & { responseType?: "json" | "xml" },
  ): Promise<T> {
    const forceXml =
      typeof data === "string" ||
      options?.responseType === "xml" ||
      (typeof options?.headers === "object" &&
        "Content-Type" in (options.headers as Record<string, string>) &&
        String((options.headers as Record<string, string>) ["Content-Type"]).toLowerCase().includes("xml"));

    const response = await this.execute(endpoint, {
      method: "POST",
      headers: {
        Accept: forceXml ? "application/xml, text/xml, */*" : "application/json",
        "Content-Type": forceXml ? "application/xml; charset=utf-8" : "application/json",
        ...(token && {
          Authorization: `Bearer ${token}`,
        }),
        ...options?.headers,
      },
      body: forceXml ? String(data ?? "") : data ? JSON.stringify(data) : undefined,
      ...options,
    });

    if (forceXml) {
      const rawText = await response.text();
      return this.parseXmlTextToObject<T>(rawText);
    }

    return response.json();
  }
}

export const http = new HttpClient();
