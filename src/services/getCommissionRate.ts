import type { TFunction } from "i18next";
import type { IConsultaComisionRes } from "@/interfaces/services/consultaComision/IConsultaComisionRes";
import type { IConsultaComisionReq } from "@/interfaces/services/consultaComision/IConsultaComisionReq";
import type { IAuthContext } from "@/interfaces/auth/IAuthContext";
import loadEnvConfig from "@/utils/bootstrap/loadEnvConfig";
import { http } from "@/utils/http/httpClient";

const getCommissionRate = async (  
  client: IConsultaComisionReq,
  t: TFunction,
  authContext?: IAuthContext | null,
): Promise<IConsultaComisionRes> => {
  const config = await loadEnvConfig();
  const token = authContext?.token ?? "";    
  const apiCommission = config?.apiRestPaths.consultaComision ?? "";  

  let serviceCommissionResponse: IConsultaComisionRes;      
  
  try {
    serviceCommissionResponse = await http.post<IConsultaComisionRes>(
      apiCommission,
      token,
      client      
    );
  } catch (error) {
    console.error(error instanceof Error ? error.message : String(error));
    throw new Error(t("msg.descriptions.invalidParameters", { ns: "error" }));
  }  
  
  if (Number(serviceCommissionResponse?.consulta_comision?.resultado.codigo) !== 1) {
    throw new Error(t("msg.descriptions.invalidParameters", { ns: "error" }));
  }

  return serviceCommissionResponse;
};

export default getCommissionRate;
