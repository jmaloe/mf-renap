import { buildPayload } from "@/utils/formats/formatXml";
import type { XmlValue } from "@/utils/http/soapClient";

const defaultPayload = (
  body: Record<string, Record<string, XmlValue>> | Record<string, XmlValue>,
  ns = "",
): string => {
  const xml = buildPayload(body, ns);

  return `<?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
        <Obtiene_Nivel xmlns="http://tempuri.org/">
          ${xml}
        </Obtiene_Nivel>
      </soap:Body>
    </soap:Envelope>
  `.trim();
};

export default defaultPayload;
