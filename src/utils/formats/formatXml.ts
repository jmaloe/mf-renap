import type {
  XmlCData,
  XmlObject,
  XmlPrimitive,
  XmlValue,
} from "@/utils/http/soapClient";

// Validaciones
const isXmlCData = (value: unknown): value is XmlCData =>
  typeof value === "object" &&
  value !== null &&
  "cdata" in value &&
  typeof value.cdata === "string";

const isValueWithAttributes = (
  obj: XmlObject,
): obj is {
  value: XmlPrimitive | XmlCData;
  attr: Record<string, XmlPrimitive>;
} => {
  const keys = Object.keys(obj);
  return keys.length === 2 && "value" in obj && "attr" in obj;
};

// Helper para atributos
const buildAttributes = (obj: XmlObject): string => {
  const attr = obj.attr;

  if (!attr || typeof attr !== "object" || Array.isArray(attr)) {
    return "";
  }

  return Object.entries(attr)
    .map(([k, v]) => ` ${k}="${escapeXml(v as XmlPrimitive)}"`)
    .join("");
};

// Helper para value + attr
const buildValueWithAttributes = (
  key: string,
  value: XmlPrimitive | XmlCData,
  attrs: string,
  wrap: (k: string, inner: string, attrs?: string) => string,
): string => {
  if (value === null || value === undefined) {
    return wrap(key, "", attrs);
  }

  if (isXmlCData(value)) {
    return wrap(key, `<![CDATA[${value.cdata}]]>`, attrs);
  }

  return wrap(key, escapeXml(toPrimitive(value)), attrs);
};

// Helper para hijos
const buildChildren = (
  entries: [string, XmlValue][],
  options: { ns?: string; raw?: boolean },
): string =>
  entries
    .filter(([k]) => k !== "attr")
    .map(([k, v]) => buildNode(k, v, options))
    .join("");

const buildNode = (
  key: string,
  value: XmlValue,
  options: { ns?: string; raw?: boolean } = {},
): string => {
  if (key === "attr") return "";

  const ns = options.raw ? "" : (options.ns ?? "");
  const prefix = ns ? `${ns}:` : "";

  const wrap = (k: string, inner: string, attrs = "") =>
    `<${prefix}${k}${attrs}>${inner}</${prefix}${k}>`;

  if (value == null) {
    return wrap(key, "");
  }

  if (Array.isArray(value)) {
    return value.map((v) => buildNode(key, v, options)).join("");
  }

  if (isXmlCData(value)) {
    return wrap(key, `<![CDATA[${value.cdata}]]>`);
  }

  if (typeof value !== "object" || value instanceof Date) {
    return wrap(key, escapeXml(value));
  }

  const entries = Object.entries(value);
  const attrs = buildAttributes(value);

  if (isValueWithAttributes(value)) {
    return buildValueWithAttributes(key, value.value, attrs, wrap);
  }

  const children = buildChildren(entries, options);

  return wrap(key, children, attrs);
};

// Formateos
const toPrimitive = (value: unknown): string => {
  if (value === null || value === undefined) return "";

  if (value instanceof Date) return value.toISOString();

  if (
    typeof value === "string" ||
    typeof value === "number" ||
    typeof value === "boolean" ||
    typeof value === "bigint"
  ) {
    return String(value);
  }

  return "";
};

const escapeXml = (xml?: XmlPrimitive): string => {
  if (xml === null || xml === undefined) return "";
  const value = toPrimitive(xml);

  return value
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&apos;");
};

// Construcciones de payload
export const cdata = (value: XmlValue | XmlObject, ns = ""): XmlCData => {
  const xml =
    typeof value === "object" &&
    value !== null &&
    !Array.isArray(value) &&
    !(value instanceof Date)
      ? Object.entries(value as XmlObject)
          .map(([k, v]) => buildNode(k, v, { ns, raw: true }))
          .join("")
      : toPrimitive(value);

  return { cdata: xml };
};

export const buildPayload = (
  body: Record<string, Record<string, XmlValue>> | Record<string, XmlValue>,
  ns = "tem",
): string => {
  const fields = Object.entries(body ?? {})
    .map(([key, value]) => buildNode(key, value, { ns }))
    .join("");

  return fields.trim();
};

const serializeXmlNode = (tagName: string, value: unknown): string => {
  if (value === null || value === undefined) {
    return `<${tagName}></${tagName}>`;
  }

  if (Array.isArray(value)) {
    return value.map((item) => serializeXmlNode(tagName, item)).join("");
  }

  if (typeof value === "object" && !(value instanceof Date)) {
    const children = Object.entries(value as Record<string, unknown>)
      .map(([key, childValue]) => serializeXmlNode(key, childValue))
      .join("");

    return `<${tagName}>${children}</${tagName}>`;
  }

  return `<${tagName}>${escapeXml(toPrimitive(value))}</${tagName}>`;
};

export const toSimpleXml = <T extends Record<string, unknown>>(body: T): string => {
  const entries = Object.entries(body ?? {});

  if (entries.length === 0) {
    return '<?xml version="1.0" encoding="UTF-8"?>';
  }

  if (entries.length === 1) {
    const [rootName, rootValue] = entries[0];
    return `<?xml version="1.0" encoding="UTF-8"?>\n${serializeXmlNode(rootName, rootValue)}`;
  }

  const children = entries
    .map(([key, value]) => serializeXmlNode(key, value))
    .join("");

  return `<?xml version="1.0" encoding="UTF-8"?>\n<root>${children}</root>`;
};
