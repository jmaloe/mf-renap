import type { TFunction } from "i18next";

import type { IOrderRes } from "@/interfaces/services/orderData/IOrderRes";
import type { IOrderReq } from "@/interfaces/services/orderData/IOrderReq";
import type { IOrderData } from "@/interfaces/services/orderData/IOrderData";
import { getCleanString, toCapitalizeFirst } from "@/utils/formats/formatString";
import { getFormatNumber } from "@/utils/formats/formatNumber";
import type { IValidAmountRes } from "@/interfaces/services/validAmount/IValidAmountRes";
import type { IValidAmountReq } from "@/interfaces/services/validAmount/IValidAmountReq";
import loadEnvConfig from "@/utils/bootstrap/loadEnvConfig";
import type { IAuthContext } from "@/interfaces/auth/IAuthContext";
import { http } from "@/utils/http/httpClient";

const getTipoTarifario = async (
  client: IOrderReq,
  t: TFunction,
  authContext?: IAuthContext | null,
): Promise<IOrderData> => {
  const config = await loadEnvConfig();
  const token = authContext?.token ?? "";
  const transactionCode = config?.transactionCode ?? "";
  const apiGetNumber = config?.apiRestPaths.phoneNumber ?? "";
  const apiValidAmount = config?.apiRestPaths.validAmount ?? "";

  let userData: IOrderRes;
  try {
    userData = await http.post<IOrderRes>(apiGetNumber, token, client);
  } catch (error) {
    console.error(error instanceof Error ? error.message : String(error));
    throw new Error(t("msg.descriptions.default", { ns: "error" }));
  }

  const result = userData?.consulta?.resultado;
  const code = result?.codigo;
  const description =
    result?.descripcion || t("msg.descriptions.default", { ns: "error" });

  if (code !== "1") {
    throw new Error(description);
  }

  const data = userData?.consulta?.datos;
  if (!data) {
    throw new Error(t("msg.descriptions.default", { ns: "error" }));
  }

  const resData: IOrderData = {
    telefono: getCleanString(client.contrato),
    factura: getCleanString(data.factura),
    fecha: getCleanString(data.fecha),
    nombre: toCapitalizeFirst(getCleanString(data.nombre)),
    saldo: getFormatNumber(data.saldo),
  };

  const office = authContext?.user?.profile?.oficina ?? "";
  const invalidAmountData: IValidAmountReq = {
    codigoTransaccion: transactionCode,
    valorMonto: resData.saldo,
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

  return resData;
};

export default getTipoTarifario;
