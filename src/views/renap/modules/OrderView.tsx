import { Controller, useForm } from "react-hook-form";
import * as z from "zod";
import { zodResolver } from "@hookform/resolvers/zod";
import { useState } from "react";
import { useTranslation } from "react-i18next";

import { FieldGroup } from "@/components/ui/field";
import TransmitButton from "@/components/buttons/TransmitButton";
import type { INavigation } from "@/interfaces/components/navigation/INavigation";
import MainInput from "@/components/fields/MainInput";
import WarningModal from "@/components/modals/WarningModal";
import type { IModalData } from "@/interfaces/components/modal/IModalData";
import { useRequest } from "@/utils/http/useRequest";
import getTipoTarifario from "@/services/getClientData";
import type { IOrderReq } from "@/interfaces/services/orderData/IOrderReq";
import type { IOrderData } from "@/interfaces/services/orderData/IOrderData";
import type { IAuthContext } from "@/interfaces/auth/IAuthContext";
import MainFormCard from "@/components/cards/MainFormCard";
import MainGroupButton from "@/components/buttons/MainGroupButton";

type IProps = Readonly<{
  authContext?: IAuthContext | null;
  onSubmitOrderData: (data: IOrderData) => void;
  onSelectPage: (item: INavigation) => void;
}>;

const OrderView = ({
  authContext,
  onSubmitOrderData,
  onSelectPage,
}: IProps) => {
  const { t } = useTranslation();
  const { loading, execute } = useRequest<IOrderData>();
  const [onChangeModal, setOnChangeModal] = useState(false);
  const [modalData, setModalData] = useState<IModalData>();

  const formSchema = z.object({
    clientOrder: z
      .string()
      .trim()
      .nonempty(t("field.clientOrder.nonEmpty", { ns: "error" }))
      .regex(/^\d+$/, t("field.clientOrder.digit", { ns: "error" }))
      .length(8, t("field.clientOrder.length", { ns: "error" })),
  });

  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      clientOrder: "",
    },
    mode: "onChange",
    reValidateMode: "onChange",
  });

  const onSubmit = async (form: z.infer<typeof formSchema>) => {
    const baseUrl = import.meta.env.BASE_URL;

    const user = authContext?.user?.username ?? "";
    const office = authContext?.user?.profile?.oficina ?? "";
    const profileId = authContext?.user?.profile?.id ?? "";
    const orderData: IOrderReq = {
      contrato: form.clientOrder,
      usuario: user,
      caja_rural: office,
      url: baseUrl,
      grupo: profileId,
    };

    const { data: resClientData, error: resClientError } = await execute(() =>
      getTipoTarifario(orderData, t, authContext),
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
          name="clientOrder"
          control={form.control}
          render={({ field, fieldState }) => (
            <MainInput
              id="clientOrder"
              label={t("pages.order.clientOrder.label")}
              field={field}
              fieldState={fieldState}
              placeholder={t("pages.order.clientOrder.placeholder")}
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
