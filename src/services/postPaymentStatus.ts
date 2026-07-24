import type { TFunction } from "i18next";

import type { IPaymentReq } from "@/interfaces/services/paymentData/IPaymentReq";
import type { IPaymentRes } from "@/interfaces/services/paymentData/IPaymentRes";
import type { IPaymentData } from "@/interfaces/services/paymentData/IPaymentData";
import { getCleanString } from "@/utils/formats/formatString";
import loadEnvConfig from "@/utils/bootstrap/loadEnvConfig";
import type { IAuthContext } from "@/interfaces/auth/IAuthContext";
import validateHour from "@/utils/errors/validateHour";
import type { IDateTimeRes } from "@/interfaces/services/dateTime/IDateTimeRes";
import { http } from "@/utils/http/httpClient";

const postPaymentStatus = async (
  client: IPaymentReq,
  t: TFunction,
  authContext?: IAuthContext | null,
): Promise<IPaymentData> => {
  const start = Number(t("schedule.start", { ns: "error" }));
  const end = Number(t("schedule.end", { ns: "error" }));
  if (!validateHour(start, end)) {
    throw new Error(t("msg.descriptions.outOfHours", { ns: "error" }));
  }

  const config = await loadEnvConfig();
  const token = authContext?.token ?? "";
  const apiPayment = config?.apiRestPaths.paidData ?? "";

  let paymentData: IPaymentRes;
  try {
    paymentData = await http.post<IPaymentRes>(apiPayment, token, client);
  } catch (error) {
    console.error(error instanceof Error ? error.message : String(error));
    throw new Error(t("msg.descriptions.default", { ns: "error" }));
  }

  const result = paymentData?.pago?.resultado;
  const code = result?.codigo;
  const description =
    result?.descripcion || t("msg.descriptions.default", { ns: "error" });

  if (code !== "1") {
    throw new Error(description);
  }

  const data = paymentData?.pago?.datos;
  if (!data) {
    throw new Error(t("msg.descriptions.default", { ns: "error" }));
  }

  const apiDateTime = config?.apiRestPaths.dateTimeData ?? "";
  let dateTimeData: IDateTimeRes | undefined;

  try {
    dateTimeData = await http.get<IDateTimeRes>(apiDateTime, token);
  } catch (error) {
    console.error(error instanceof Error ? error.message : String(error));
  }

  const dateTime = dateTimeData?.data?.datetime ?? "";

  const resData: IPaymentData = {
    referencia: getCleanString(data.referencia.trim()),
    dateTime: dateTime,
  };

  return resData;
};

export default postPaymentStatus;
