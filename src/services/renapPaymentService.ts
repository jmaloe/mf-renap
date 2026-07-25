import type { TFunction } from "i18next";
import loadEnvConfig from "@/utils/bootstrap/loadEnvConfig";
import type { IAuthContext } from "@/interfaces/auth/IAuthContext";
import validateHour from "@/utils/errors/validateHour";
import { http } from "@/utils/http/httpClient";
import type { ICobroSolicitudReq } from "@/interfaces/services/cobroSolicitud/ICobroSolicitudReq";
import type { ICobroSolicitudRes } from "@/interfaces/services/cobroSolicitud/ICobroSolicitudRes";

const renapPaymentService = async (
  client: ICobroSolicitudReq,
  t: TFunction,
  authContext?: IAuthContext | null,
): Promise<ICobroSolicitudRes> => {
  const start = Number(t("schedule.start", { ns: "error" }));
  const end = Number(t("schedule.end", { ns: "error" }));
  if (!validateHour(start, end)) {
    throw new Error(t("msg.descriptions.outOfHours", { ns: "error" }));
  }

  const config = await loadEnvConfig();
  const token = authContext?.token ?? "";
  const apiPayment = config?.apiRestPathsRenap.cobroSolicitud ?? "";

  let paymentData: ICobroSolicitudRes;
  try {
    paymentData = await http.post<ICobroSolicitudRes>(apiPayment, token, client);
  } catch (error) {
    console.error(error instanceof Error ? error.message : String(error));
    throw new Error(t("msg.descriptions.default", { ns: "error" }));
  }

  const result = paymentData?.cobro_solicitud;
  const code = result?.resultado?.codigo;
  const description = result?.resultado.descripcion || t("msg.descriptions.default", { ns: "error" });

  if (code !== "1") {
    throw new Error(description);
  }

  const data = result?.datos;
  if (!data) {
    throw new Error(t("msg.descriptions.default", { ns: "error" }));
  }

  return paymentData;
};

export default renapPaymentService;
