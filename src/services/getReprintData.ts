import type { TFunction } from "i18next";

import type { IAuthContext } from "@/interfaces/auth/IAuthContext";
import type { ITransactInfo } from "@/interfaces/auth/ITransactInfo";
import type { IReceiptData } from "@/interfaces/components/receipt/IReceiptData";
import type { IDetailTransactionReq } from "@/interfaces/services/detailTransaction/IDetailTransactionReq";
import type { IDetailTransactionRes } from "@/interfaces/services/detailTransaction/IDetailTransactionRes";
import loadEnvConfig from "@/utils/bootstrap/loadEnvConfig";
import { formatDate } from "@/utils/formats/formatDate";
import getInitials from "@/utils/formats/getInitials";
import { operationType } from "@/utils/constants/reprint";
import { http } from "@/utils/http/httpClient";

const getReprintData = async (
  t: TFunction,
  authContext?: IAuthContext | null,
): Promise<IReceiptData | string> => {
  const config = await loadEnvConfig();
  const transactInfo = authContext?.transactInfo ?? ({} as ITransactInfo);
  const token = authContext?.token ?? "";
  const apiGetDetailTransaction = config?.apiRestPaths.detailTransaction ?? "";

  const user = authContext?.user?.username ?? "";
  const office = authContext?.user?.profile?.oficina ?? "";
  const userName = authContext?.user?.profile?.nombre ?? "";
  const userInitials = getInitials(
    authContext?.user?.profile?.descripcion ?? "",
  );
  const department =
    authContext?.user?.profile?.departmentData?.departamento ?? "";
  const city = authContext?.user?.profile?.departmentData?.municipio ?? "";

  const detailTransaction: IDetailTransactionReq = {
    operacion: operationType.trim(),
    usuario: user,
    secuencial: transactInfo.secuencial,
    fecha: transactInfo.fechaTransaccion,
    noRemesa: transactInfo.cuenta,
    oficina: office,
  };

  let detailData: IDetailTransactionRes;
  try {
    detailData = await http.post<IDetailTransactionRes>(
      apiGetDetailTransaction,
      token,
      detailTransaction,
    );
  } catch (error) {
    console.error(error instanceof Error ? error.message : String(error));
    return t("msg.descriptions.noResponseService", { ns: "error" });
  }

  const result = detailData?.detalleTransacciones?.resultado;
  const code = result?.codigo;

  if (code !== "1") {
    return t("msg.descriptions.noDataTransaction", { ns: "error" });
  }

  const data = detailData?.detalleTransacciones?.datos;
  if (!data) {
    return t("msg.descriptions.noDataTransaction", { ns: "error" });
  }

  const arrayDate = data.fecha.split(" ");
  let strDate = arrayDate[0];
  strDate = formatDate(strDate);
  const arrayTime = data.hora.split(" ");
  const strTime =
    arrayTime[1].substring(0, 8) + " " + arrayTime[1].substring(8);

  const receiptData: IReceiptData = {
    payment: data.cuenta,
    amount: data.valor,
    invoice: data.descripcion,
    receiptNumber: data.secuencial,
    date: `${strDate} ${strTime}`,
    office: office,
    user: user,
    userName: userName,
    userInitials: userInitials,
    department: department,
    city: city,
  };
  return receiptData;
};

export default getReprintData;
