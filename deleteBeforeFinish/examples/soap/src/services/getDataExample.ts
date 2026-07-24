import loadEnvConfig from "@/utils/bootstrap/loadEnvConfig";
import type { IAuthContext } from "@/interfaces/auth/IAuthContext";
import { soap, type ISoapResponse } from "@/utils/http/soapClient";
import defaultPayload from "@/utils/http/payloads/defaultPayload";
import { cdata } from "@/utils/formats/formatXml";

// Si lo desean pueden crear un interface individual, por motivos del ejemplo se dejara aqui
type IExampleReq = {
  Obtiene_NivelResult?: {
    resultado?: { codigo?: string; descripcion?: string };
    datos_transaccion?: Array<{
      id?: number;
      padre?: number;
      url?: string;
      nombre?: string;
      imagen?: string | null;
    }>;
  };
};

const getUserAccess = async (
  authContext?: IAuthContext | null,
): Promise<boolean> => {
  const config = await loadEnvConfig();
  const token = authContext?.token ?? "";
  const path = config?.apiSoap?.transactionSubMenu?.path ?? "";
  const soapAction = config?.apiSoap?.transactionSubMenu?.action ?? "";

  // Metodo que construye el request final (Se pueden generar cuantos sean necesarios)
  const xml = defaultPayload({
    // Para cuando el request utiliza <![CDATA[....]]>
    strInput: cdata({
      Obtiene_Nivel: {
        operacion: "CST",
        rol: "55",
        padre: "18000",
        nivel: "2",
        oficina: "50201",
        login: "226513100721",
      },
    }),
    /*
     * Si dado el caso un campo interno del body necesita un atributo podemos usar lo siguiente:
     * Observar que si queremos que el mismo campo tenga el valor además del atributo
     * Debemos ocupar el valor "value", estos datos se encuentran en src > utils > http > soapClient.ts
     * Y en src > utils > formats > formatXml.ts
     */
    example1: {
      attr: {
        xmlns: "http://schemas.xmlsoap.org/soap/envelope/",
      },
      value: "This is an example",
    },
    example2: {
      attr: {
        xmlns: "http://schemas.xmlsoap.org/soap/envelope/",
      },
      cliente: {
        datos: "####",
      },
    },
  });

  let resData: ISoapResponse<IExampleReq>;
  try {
    resData = await soap.call<IExampleReq>(path, soapAction, xml, token);
  } catch (error) {
    console.error(error instanceof Error ? error.message : String(error));
    return false;
  }

  const success = resData?.success ?? false;
  if (!success) {
    throw new Error(`Transaction submenu API error: ${resData.error}`);
  }

  // Obtenemos el response en json directamente
  const data = resData?.data ?? {};
  // Formateamos según nuestras necesidades y utilizamos como otro service
  return data;
};

export default getUserAccess;
