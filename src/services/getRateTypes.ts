import type { TFunction } from "i18next";

import type { ITipoTarifarioReq } from "@/interfaces/services/consultaTipoTarifario/ITipoTarifarioReq";
import type { ITipoTarifarioRes } from "@/interfaces/services/consultaTipoTarifario/ITipoTarifarioRes";
import type { ITarifarioReq } from "@/interfaces/services/consultaTarifario/ITarifarioReq";
import type { ITarifarioRes } from "@/interfaces/services/consultaTarifario/ITarifarioRes";

import loadEnvConfig from "@/utils/bootstrap/loadEnvConfig";
import type { IAuthContext } from "@/interfaces/auth/IAuthContext";
import { http } from "@/utils/http/httpClient";

const getRateTypes = async (
  client: ITipoTarifarioReq,
  t: TFunction,
  authContext?: IAuthContext | null,
): Promise<ITarifarioRes> => {
  const config = await loadEnvConfig();
  const token = authContext?.token ?? "";  
  const apiTipoTarifario = config?.apiRestPathsRenap.consultaTipoTarifario ?? "";
  const apiTarifario = config?.apiRestPathsRenap.consultaTipoTarifario ?? "";

  let tipoTarifarioResp: ITipoTarifarioRes;
  try {
    tipoTarifarioResp = await http.post<ITipoTarifarioRes>(apiTipoTarifario, token, client);
  } catch (error) {
    console.error(error instanceof Error ? error.message : String(error));
    throw new Error(t("msg.descriptions.default", { ns: "error" }));
  }

  const result = tipoTarifarioResp?.Clta_TipoTarifario.resultado;
  const code = result?.codigo;
  const description = result?.value || t("msg.descriptions.default", { ns: "error" });

  if (code !== "1") {
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
    rateData = await http.post<ITarifarioRes>(
      apiTarifario,
      token,
      tarifarioRequest,
    );
  } catch (error) {
    console.error(error instanceof Error ? error.message : String(error));
    throw new Error(t("msg.descriptions.invalidRateType", { ns: "error" }));
  }  

  if (rateData?.Clta_Tarifario.resultado?.codigo !== "1") {
    throw new Error(t("msg.descriptions.invalidRateType", { ns: "error" }));
  }

  return rateData;
};

export default getRateTypes;
