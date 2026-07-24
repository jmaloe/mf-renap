import loadEnvConfig from "@/utils/bootstrap/loadEnvConfig";
import type { IAuthContext } from "@/interfaces/auth/IAuthContext";
import type { IAccessRes } from "@/interfaces/services/access/IAccessRes";
import type { IAccessReq } from "@/interfaces/services/access/IAccessReq";
import { http } from "@/utils/http/httpClient";

const getUserAccess = async (
  authContext?: IAuthContext | null,
): Promise<boolean> => {
  const config = await loadEnvConfig();
  const token = authContext?.token ?? "";
  const transactionCode = config?.transactionCode ?? "";
  const apiVerifyAccess = config?.apiRestPaths.verifyAccess ?? "";

  const user = authContext?.user?.username ?? "";
  const office = authContext?.user?.profile?.oficina ?? "";
  const reqData: IAccessReq = {
    codigoTransaccion: transactionCode,
    codigoOficina: office,
    codigoUsuario: user,
  };
  
  let accessData: IAccessRes;
  try {
    accessData = await http.post<IAccessRes>(apiVerifyAccess, token, reqData);
  } catch (error) {
    console.error(error instanceof Error ? error.message : String(error));
    return false;
  }

  return (accessData?.verificarAccesoRs ?? "").trim().toLowerCase() === "true";
};

export default getUserAccess;
