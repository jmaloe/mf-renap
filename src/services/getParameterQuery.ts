import type { TFunction } from "i18next";
import type { IConsultaParametroRes } from "@/interfaces/services/consultaParametro/IConsultaParametroRes";

import loadEnvConfig from "@/utils/bootstrap/loadEnvConfig";
import type { IAuthContext } from "@/interfaces/auth/IAuthContext";
import { http } from "@/utils/http/httpClient";

const getParameterQuery = async (  
  t: TFunction,
  authContext?: IAuthContext | null,
): Promise<IConsultaParametroRes> => {
  const config = await loadEnvConfig();
  const token = authContext?.token ?? "";    
  const apiParameterQuery = config?.apiRestPathsRenap.consultaParametro ?? "";

  /*const queryParams: IConsultaParametroReq = {
    nemonico:"NCR",
    tipo:"T",
    producto:"CR"
  };*/

  let parameterQueryResponse: IConsultaParametroRes;      
  
  try {
    parameterQueryResponse = await http.get<IConsultaParametroRes>(
      apiParameterQuery,
      token      
    );
  } catch (error) {
    console.error(error instanceof Error ? error.message : String(error));
    throw new Error(t("msg.descriptions.invalidParameters", { ns: "error" }));
  }  
  console.log("parameterQueryResponse", JSON.stringify(parameterQueryResponse));
  if (parameterQueryResponse?.consulta_parametro?.resultado.codigo !== "1") {
    throw new Error(t("msg.descriptions.invalidParameters", { ns: "error" }));
  }

  return parameterQueryResponse;
};

export default getParameterQuery;
