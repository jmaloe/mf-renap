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
import getClientData from "@/services/getClientData";
import type { IClientReq } from "@/interfaces/services/clientData/IClientReq";
import type { IClientData } from "@/interfaces/services/clientData/IClientData";
import type { IAuthContext } from "@/interfaces/auth/IAuthContext";
import MainFormCard from "@/components/cards/MainFormCard";
import MainGroupButton from "@/components/buttons/MainGroupButton";

type IProps = Readonly<{
  authContext?: IAuthContext | null;
  onSubmitClientData: (data: IClientData) => void;
  onSelectPage: (item: INavigation) => void;
}>;

const HomeView = ({
  authContext,
  onSubmitClientData,
  onSelectPage,
}: IProps) => {
  const { t } = useTranslation();
  const { loading, execute } = useRequest<IClientData>();
  const [onChangeModal, setOnChangeModal] = useState(false);
  const [modalData, setModalData] = useState<IModalData>();

  const formSchema = z.object({
    clientContract: z
      .string()
      .trim()
      .nonempty(t("field.clientContract.nonEmpty", { ns: "error" }))
      .regex(/^\d+$/, t("field.clientContract.digit", { ns: "error" }))
      .length(8, t("field.clientContract.length", { ns: "error" })),
  });

  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      clientContract: "",
    },
    mode: "onChange",
    reValidateMode: "onChange",
  });

  const onSubmit = async (form: z.infer<typeof formSchema>) => {
    const baseUrl = import.meta.env.BASE_URL;

    const user = authContext?.user?.username ?? "";
    const office = authContext?.user?.profile?.oficina ?? "";
    const profileId = authContext?.user?.profile?.id ?? "";
    const clientData: IClientReq = {
      contrato: form.clientContract,
      usuario: user,
      caja_rural: office,
      url: baseUrl,
      grupo: profileId,
    };

    const { data: resClientData, error: resClientError } = await execute(() =>
      getClientData(clientData, t, authContext),
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

    onSubmitClientData(resClientData);
    onSelectPage("client");
  };

  return (
    <MainFormCard
      titleCard={t("pages.home.title")}
      className="w-full sm:w-auto"
      loading={loading}
    >
      <FieldGroup>
        <Controller
          name="clientContract"
          control={form.control}
          render={({ field, fieldState }) => (
            <MainInput
              id="clientContract"
              label={t("pages.home.clientContract.label")}
              field={field}
              fieldState={fieldState}
              placeholder={t("pages.home.clientContract.placeholder")}
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

export default HomeView;
