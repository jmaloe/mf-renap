import type { TFunction } from "i18next";
import type { IValidAmountRes } from "@/interfaces/services/validAmount/IValidAmountRes";
import type { IValidAmountReq } from "@/interfaces/services/validAmount/IValidAmountReq";
import loadEnvConfig from "@/utils/bootstrap/loadEnvConfig";
import type { IAuthContext } from "@/interfaces/auth/IAuthContext";
import { http } from "@/utils/http/httpClient";
import type { ICobroSolicitudReq } from "@/interfaces/services/cobroSolicitud/ICobroSolicitudReq";

const getValidateAmount = async (
  client: ICobroSolicitudReq,
  t: TFunction,
  authContext?: IAuthContext | null,
): Promise<ICobroSolicitudReq> => {
  const config = await loadEnvConfig();
  const token = authContext?.token ?? "";
  const transactionCode = config?.transactionCode ?? "";  
  const apiValidAmount = config?.apiRestPaths.validAmount ?? "";  

  const office = authContext?.user?.profile?.oficina ?? "";
  const invalidAmountData: IValidAmountReq = {
    codigoTransaccion: transactionCode,
    valorMonto: client.monto,
    codigoOficina: office,
  };

  let amountData: IValidAmountRes;
  try {
    amountData = await http.post<IValidAmountRes>(
      apiValidAmount,
      token,
      invalidAmountData,
    );
  } catch (error) {
    console.error(error instanceof Error ? error.message : String(error));
    throw new Error(t("msg.descriptions.invalidAmount", { ns: "error" }));
  }

  const resAmount: IValidAmountRes = {
    validarMontoRs: amountData?.validarMontoRs ?? "",
  };

  if (resAmount.validarMontoRs !== "true") {
    throw new Error(t("msg.descriptions.invalidAmount", { ns: "error" }));
  }

  return client;
};

export default getValidateAmount;
