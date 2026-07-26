import { useState } from "react";
import { useTranslation } from "react-i18next";
import TransmitButton from "@/components/buttons/TransmitButton";
import { FieldGroup } from "@/components/ui/field";
import CancelButton from "@/components/buttons/CancelButton";
import ReadOnlyField from "@/components/fields/ReadOnlyField";
import { useRequest } from "@/utils/http/useRequest";
import {renapPaymentService, getDateAndTime } from "@/services/renapPaymentService";
import WarningModal from "@/components/modals/WarningModal";
import getInitials from "@/utils/formats/getInitials";
import MainFormCard from "@/components/cards/MainFormCard";
import MainGroupButton from "@/components/buttons/MainGroupButton";
import loadEnvConfig from "@/utils/bootstrap/loadEnvConfig";

import type { INavigation } from "@/interfaces/components/navigation/INavigation";
import type { ICobroSolicitudReq } from "@/interfaces/services/cobroSolicitud/ICobroSolicitudReq";
import type { IModalData } from "@/interfaces/components/modal/IModalData";
import type { IReceiptData } from "@/interfaces/components/receipt/IReceiptData";
import type { IAuthContext } from "@/interfaces/auth/IAuthContext";
import type { IReadOnlyField } from "@/interfaces/components/fields/IReadOnlyField";
import type { ICobroSolicitudRes } from "@/interfaces/services/cobroSolicitud/ICobroSolicitudRes";

type IProps = Readonly<{
  authContext?: IAuthContext | null;
  client: ICobroSolicitudReq;  
  onSubmitReceiptData: (data: IReceiptData) => void;
  onSelectPage: (item: INavigation) => void;  
}>;

const PreviewView = ({
  authContext,
  client,
  onSubmitReceiptData,
  onSelectPage,
}: IProps) => {
  const { t } = useTranslation();
  const { loading, execute } = useRequest<ICobroSolicitudRes>();
  const [onChangeModal, setOnChangeModal] = useState(false);
  const [modalData, setModalData] = useState<IModalData>();

  const onSubmit = async () => {
    const user = authContext?.user?.username ?? "";
    const office = authContext?.user?.profile?.oficina ?? "";    

    const { data: resClientData, error: resClientError } = await execute(() =>
      renapPaymentService(client, t, authContext),
    );
    if (!resClientData) {
      setModalData({
        title: t("msg.titles.invalidData", { ns: "error" }),
        description:
          resClientError || t("msg.descriptions.default", { ns: "error" }),
      });
      setOnChangeModal(true);
      return;
    }

    const userName = authContext?.user?.profile?.nombre ?? "";
    const userInitials = getInitials(
      authContext?.user?.profile?.descripcion ?? "",
    );
    const department = authContext?.user?.profile?.departmentData?.departamento ?? "";
    const city = authContext?.user?.profile?.departmentData?.municipio ?? "";
    const serviceResponseData = resClientData?.cobro_solicitud?.datos ?? null;
    const config = await loadEnvConfig();
    const transactionDateTime = await getDateAndTime(config, t, authContext?.token ?? "");
    const receiptData: IReceiptData = {
      payment: client.total_pagar ?? "",
      amount: client.monto ?? "",
      invoice: serviceResponseData?.boleta_pago ?? "",
      receiptNumber: serviceResponseData?.recibo ?? "",
      date: transactionDateTime ?? "",
      office: office,
      user: user,
      userName: userName,
      userInitials: userInitials,
      department: department,
      city: city,      
      secuencial: serviceResponseData?.secuencial ?? "",
      secuencial_comision: serviceResponseData?.secuencial_comision ?? "",
      referencia: serviceResponseData?.referencia ?? "",
      boleta_pago: serviceResponseData?.boleta_pago ?? "",
      recibo: serviceResponseData?.recibo ?? "",
      fecha: serviceResponseData?.fecha ?? "",
      linea_1: serviceResponseData?.linea_1 ?? "",
      linea_2: serviceResponseData?.linea_2 ?? "",
      linea_3: serviceResponseData?.linea_3 ?? ""
    };

    onSubmitReceiptData(receiptData);
    onSelectPage("receipt");
  };

  const fields: IReadOnlyField[] = [
    {
      id: "paymentService",
      label: t("fields.service.label"),
      description: client.nombre_evento ?? "N/A",
    },
    {
      id: "copyNumbers",
      label: t("fields.copyNumbers.label"),
      description: client.cantidad_copias ?? "0.00",
    },
    {
      id: "unitPrice",
      label: t("fields.unitPrice.label"),
      description: client.monto ?? "0.00",
    },
    {
      id: "comission",
      label: t("fields.comission.label"),
      description: `${client.comision ?? "0.00"}`,
    },
    {
      id: "paymentAmount",
      label: t("fields.totalAmount.label"),
      description: client.total_pagar ?? "0.00",
    },
  ];

  return (
    <MainFormCard className="w-full sm:w-3xl" loading={loading}>
      <FieldGroup>
        {fields.map(({ id, label, description }) => (
          <ReadOnlyField
            key={id}
            id={id}
            label={label}
            description={description}
          />
        ))}
      </FieldGroup>
      <MainGroupButton hasSeparator isAlert>
        <CancelButton
          onClick={() => onSelectPage("home")}
          loading={loading}
          isCancel
        />
        <TransmitButton onClick={onSubmit} loading={loading} />
      </MainGroupButton>
      <WarningModal
        title={modalData?.title}
        description={modalData?.description}
        onChangeModal={onChangeModal}
        setOnChangeModal={setOnChangeModal}
        onConfirm={() => onSelectPage("home")}
      />
    </MainFormCard>
  );
};

export default PreviewView;
