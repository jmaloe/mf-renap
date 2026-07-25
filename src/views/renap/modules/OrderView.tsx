import { Controller, useForm } from "react-hook-form";
import * as z from "zod";
import { zodResolver } from "@hookform/resolvers/zod";
import { useEffect, useState } from "react";
import { useTranslation } from "react-i18next";

import { FieldGroup } from "@/components/ui/field";
import TransmitButton from "@/components/buttons/TransmitButton";
import type { INavigation } from "@/interfaces/components/navigation/INavigation";
import MainInput from "@/components/fields/MainInput";
import WarningModal from "@/components/modals/WarningModal";
import type { IModalData } from "@/interfaces/components/modal/IModalData";
import { useRequest } from "@/utils/http/useRequest";
import getRateTypes from "@/services/getRateTypes";
import renapPaymentService from "@/services/renapPaymentService";
import type { ICobroSolicitudReq } from "@/interfaces/services/cobroSolicitud/ICobroSolicitudReq";
import type { ICobroSolicitudRes } from "@/interfaces/services/cobroSolicitud/ICobroSolicitudRes";
import type { IAuthContext } from "@/interfaces/auth/IAuthContext";
import MainFormCard from "@/components/cards/MainFormCard";
import MainGroupButton from "@/components/buttons/MainGroupButton";
import type { ITipoTarifarioReq } from "@/interfaces/services/consultaTipoTarifario/ITipoTarifarioReq";
import type { ITarifarioItems } from "@/interfaces/services/consultaTarifario/ITarifarioItems";
import type { ITarifarioRes } from "@/interfaces/services/consultaTarifario/ITarifarioRes";

type IProps = Readonly<{
  authContext?: IAuthContext | null;
  onSubmitOrderData: (data: ICobroSolicitudRes) => void;
  onSelectPage: (item: INavigation) => void;
}>;

const OrderView = ({
  authContext,
  onSubmitOrderData,
  onSelectPage,
}: IProps) => {
  const { t } = useTranslation();
  const { loading, execute } = useRequest<ICobroSolicitudRes>();
  const { loading: loadingRateTypes, execute: executeRateTypes } = useRequest<ITarifarioRes>();
  const [onChangeModal, setOnChangeModal] = useState(false);
  const [modalData, setModalData] = useState<IModalData>();
  const [rateTypes, setRateTypes] = useState<ITarifarioItems[]>([]);

  const formSchema = z.object({
    rateType: z
      .string()
      .trim()
      .nonempty(t("field.rateType.nonEmpty", { ns: "error" }))
      .regex(/^\d+$/, t("field.rateType.digit", { ns: "error" }))
      .length(8, t("field.rateType.length", { ns: "error" })),
  });

  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      rateType: "",
    },
    mode: "onChange",
    reValidateMode: "onChange",
  });

  useEffect(() => {
    const fetchRateTypes = async () => {
      const rateType:ITipoTarifarioReq = {
        Clta_TipoTarifario: {
          oficina: authContext?.user?.profile?.oficina ?? ""
        }
      } 
      const { data: resClientData, error: resClientError } = await executeRateTypes(() =>
        getRateTypes(rateType, t, authContext)
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
      setRateTypes(resClientData?.Clta_Tarifario?.datos ?? []);
    };
    fetchRateTypes();
  }, [authContext]);    

  const onSubmit = async (form: z.infer<typeof formSchema>) => {
    const baseUrl = import.meta.env.BASE_URL;

    const user = authContext?.user?.username ?? "";
    const office = authContext?.user?.profile?.oficina ?? "";
    const profileId = authContext?.user?.profile?.id ?? "";
    const orderData: ICobroSolicitudReq = {      
      codigo_evento: form.rateType,      
      usuario: user,
      caja_rural: office,
      url: baseUrl,
      grupo: profileId,
      monto: "",
      cantidad_copias: "",
      tipo_tarifa: "",
      orden_pago: "",
      total_pagar: "",
      ip: "",
      nombre_evento: ""
    };

    const { data: resClientData, error: resClientError } = await execute(() =>
      renapPaymentService(orderData, t, authContext),
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

    onSubmitOrderData(resClientData);
    onSelectPage("preview");
  };

  return (
    <MainFormCard
      titleCard={t("pages.order.title")}
      className="w-full sm:w-auto"
      loading={loading}
    >
      <FieldGroup>
        <Controller
          name="rateType"
          control={form.control}
          render={({ field, fieldState }) => (
            <MainInput
              id="rateType"
              label={t("pages.order.rateType.label")}
              field={field}
              fieldState={fieldState}
              placeholder={t("pages.order.rateType.placeholder")}
              size={10}
              maxLength={8}
            />
          )}
        />
      </FieldGroup>
      <MainGroupButton>
        <TransmitButton
          onClick={form.handleSubmit(onSubmit)}
          loading={loading}
        />
      </MainGroupButton>
      <WarningModal
        title={modalData?.title}
        description={modalData?.description}
        onChangeModal={onChangeModal}
        setOnChangeModal={setOnChangeModal}
      />
    </MainFormCard>
  );
};

export default OrderView;
