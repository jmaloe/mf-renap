import { useState } from "react";
import { useTranslation } from "react-i18next";

import TransmitButton from "@/components/buttons/TransmitButton";
import type { INavigation } from "@/interfaces/components/navigation/INavigation";
import { FieldGroup } from "@/components/ui/field";
import CancelButton from "@/components/buttons/CancelButton";
import ReadOnlyField from "@/components/fields/ReadOnlyField";
import type { ICobroSolicitudReq } from "@/interfaces/services/cobroSolicitud/ICobroSolicitudReq";
import { useRequest } from "@/utils/http/useRequest";
import renapPaymentService from "@/services/renapPaymentService";
import type { IModalData } from "@/interfaces/components/modal/IModalData";
import WarningModal from "@/components/modals/WarningModal";
import type { IReceiptData } from "@/interfaces/components/receipt/IReceiptData";
import type { IAuthContext } from "@/interfaces/auth/IAuthContext";
import getInitials from "@/utils/formats/getInitials";
import type { IReadOnlyField } from "@/interfaces/components/fields/IReadOnlyField";
import MainFormCard from "@/components/cards/MainFormCard";
import MainGroupButton from "@/components/buttons/MainGroupButton";
import type { IConsultaComisionRes } from "@/interfaces/services/consultaComision/IConsultaComisionRes";
import type { ICobroSolicitudRes } from "@/interfaces/services/cobroSolicitud/ICobroSolicitudRes";

type IProps = Readonly<{
  authContext?: IAuthContext | null;
  client: ICobroSolicitudReq;
  comission: IConsultaComisionRes;
  onSubmitReceiptData: (data: IReceiptData) => void;
  onSelectPage: (item: INavigation) => void;  
}>;

const PreviewView = ({
  authContext,
  client,
  comission,
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
    const department =
      authContext?.user?.profile?.departmentData?.departamento ?? "";
    const city = authContext?.user?.profile?.departmentData?.municipio ?? "";
    const receiptData: IReceiptData = {
      payment: "client.telefono",
      amount: "client.saldo",
      invoice: "client.factura",
      receiptNumber: "data.referencia",
      date: "data.dateTime",
      office: office,
      user: user,
      userName: userName,
      userInitials: userInitials,
      department: department,
      city: city,
      secuencial: "string",
      secuencial_comision: "string",
      referencia: "string",
      boleta_pago: "string",
      recibo: "string",
      fecha: "string",
      linea_1: "string",
      linea_2: "string",
      linea_3: "string"
    };

    onSubmitReceiptData(receiptData);
    onSelectPage("receipt");
  };

  const fields: IReadOnlyField[] = [
    {
      id: "paymentService",
      label: t("fields.service.label"),
      description: t("fields.service.description"),
    },
    {
      id: "copyNumbers",
      label: t("fields.copyNumbers.label"),
      description: client.cantidad_copias,
    },
    {
      id: "unitPrice",
      label: t("fields.unitProce.label"),
      description: client.monto,
    },
    {
      id: "comission",
      label: t("fields.comission.label"),
      description: `${comission.consulta_comision?.datos?.money ?? "0.00"}`,
    },
    {
      id: "paymentAmount",
      label: t("fields.totalAmount.label"),
      description: client.total_pagar,
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
