import type { TFunction } from "i18next";

import loadEnvConfig from "@/utils/bootstrap/loadEnvConfig";
import { http } from "@/utils/http/httpClient";
import { toSimpleXml } from "@/utils/formats/formatXml";

import type { ITipoTarifarioReq } from "@/interfaces/services/consultaTipoTarifario/ITipoTarifarioReq";
import type { ITipoTarifarioRes } from "@/interfaces/services/consultaTipoTarifario/ITipoTarifarioRes";
import type { ITarifarioReq } from "@/interfaces/services/consultaTarifario/ITarifarioReq";
import type { ITarifarioRes } from "@/interfaces/services/consultaTarifario/ITarifarioRes";
import type { IAuthContext } from "@/interfaces/auth/IAuthContext";

const getRateTypes = async (
  client: ITipoTarifarioReq,
  t: TFunction,
  authContext?: IAuthContext | null,
): Promise<ITarifarioRes> => {
  const config = await loadEnvConfig();
  const token = authContext?.token ?? "";  
  const apiTipoTarifario = config?.apiRestPaths.consultaTipoTarifario ?? "";
  const apiTarifario = config?.apiRestPaths.consultaTarifario ?? "";

  let tipoTarifarioResp: ITipoTarifarioRes;
  try {
    const tipoTarifarioXml = toSimpleXml(client);
    tipoTarifarioResp = await http.post<ITipoTarifarioRes>(apiTipoTarifario, token, tipoTarifarioXml, {
      responseType: "xml",
    });
  } catch (error) {
    console.error(error instanceof Error ? error.message : String(error));
    throw new Error(t("msg.descriptions.default", { ns: "error" }));
  }

  const result = tipoTarifarioResp?.Clta_TipoTarifario.resultado;
  const code = result?.codigo;
  const description = result?.value || t("msg.descriptions.default", { ns: "error" });
  if (String(code) !== "1") {
    throw new Error(description);
  }

  const rateType = tipoTarifarioResp?.Clta_TipoTarifario.datos.tipo_tarifario;
  if (!rateType) {
    throw new Error(t("msg.descriptions.default", { ns: "error" }));
  }
  
  const userProfile = authContext?.user?.profile;

  const tarifarioRequest: ITarifarioReq = {
    Clta_Tarifario: {
      trn: "168283",
      oficina: userProfile?.oficina ?? "",
      rol: userProfile?.rol ?? "",
      evento: "",
      tipoTarifario: rateType
    }
  };

  let rateData: ITarifarioRes;

  try {
    const tarifarioXml = toSimpleXml(tarifarioRequest);
    rateData = await http.post<ITarifarioRes>(
      apiTarifario,
      token,
      tarifarioXml,
      { responseType: "xml" },
    );
  } catch (error) {
    console.error(error instanceof Error ? error.message : String(error));
    throw new Error(t("msg.descriptions.default", { ns: "error" }));
  }
  
  if (Number(rateData?.Clta_Tarifario.resultado?.codigo) !== 1) {
    throw new Error(t("msg.descriptions.invalidRateType", { ns: "error" }));
  }

  return rateData;
};

export default getRateTypes;
