
import { Controller, useForm } from "react-hook-form";
import * as z from "zod";
import { zodResolver } from "@hookform/resolvers/zod";
import { useEffect, useState } from "react";
import { useTranslation } from "react-i18next";
import { FieldGroup } from "@/components/ui/field";
import TransmitButton from "@/components/buttons/TransmitButton";
import WarningModal from "@/components/modals/WarningModal";
import { useRequest } from "@/utils/http/useRequest";
import { buildComponentId } from "@/utils/bootstrap/buildComponentId";
import MainFormCard from "@/components/cards/MainFormCard";
import MainGroupButton from "@/components/buttons/MainGroupButton";
import ComboBoxField from "@/components/ui/ComboBoxField";
import getParameterQuery from "@/services/getParameterQuery";
import getRateTypes from "@/services/getRateTypes";
import getCommissionRate from "@/services/getComissionRate";

import type { INavigation } from "@/interfaces/components/navigation/INavigation";
import type { IModalData } from "@/interfaces/components/modal/IModalData";
import type { ICobroSolicitudReq } from "@/interfaces/services/cobroSolicitud/ICobroSolicitudReq";
import type { ICobroSolicitudRes } from "@/interfaces/services/cobroSolicitud/ICobroSolicitudRes";
import type { IAuthContext } from "@/interfaces/auth/IAuthContext";
import type { ITarifarioItems } from "@/interfaces/services/consultaTarifario/ITarifarioItems";
import type { ITarifarioRes } from "@/interfaces/services/consultaTarifario/ITarifarioRes";
import type { ITipoTarifarioReq } from "@/interfaces/services/consultaTipoTarifario/ITipoTarifarioReq";
import type { IConsultaComisionReq } from "@/interfaces/services/consultaComision/IConsultaComisionReq";
import type { IConsultaComisionRes } from "@/interfaces/services/consultaComision/IConsultaComisionRes";

type IProps = Readonly<{
  authContext?: IAuthContext | null;
  onSubmitOrderData: (data: ICobroSolicitudReq) => void;
  onSelectPage: (item: INavigation) => void;
}>;

const OrderView = ({
  authContext,
  onSubmitOrderData,
  onSelectPage,
}: IProps) => {
  const { t } = useTranslation();
  const { loading, execute } = useRequest<ICobroSolicitudRes>();
  const { loading: loadingTarifario, execute: executeTarifario } = useRequest<ITarifarioRes>();
  const { loading: loadingCommission, execute: executeCommission } = useRequest<IConsultaComisionRes>();
  const [rateTypes, setRateTypes] = useState<ITarifarioItems[]>([]);  
  const [onChangeModal, setOnChangeModal] = useState(false);
  const [modalData, setModalData] = useState<IModalData>();
  const [maxCopyNumbers, setMaxCopyNumbers] = useState<number>(0);
  const [unitPrice, setUnitPrice] = useState<number | null>(null);
  const [commission, setCommission] = useState<number | null>(null);
  const [totalAmmount, setTotalAmount] = useState<number | null>(null);

  const formSchema = z.object({
    rateType: z.string().trim().nonempty(t("field.rateType.nonEmpty", { ns: "error" })),
    copyNumbers: z.string().trim().nonempty(t("field.copyNumbers.nonEmpty", { ns: "error" })),
  });

  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      rateType: "",
      copyNumbers: "1",
    },
    mode: "onChange",
    reValidateMode: "onChange",
  });

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
      cantidad_copias: form.copyNumbers,
      tipo_tarifa: "",
      orden_pago: "",
      total_pagar: "",
      ip: "",
      nombre_evento: "",
      comision: ""
    };
    onSubmitOrderData(orderData);
    onSelectPage("preview");
  };

  useEffect(() => {
    const getMaxCopyNumbers = async () => {
      const response = await getParameterQuery(t, authContext);
        const copyN = response?.consulta_parametro?.datos?.valor;
        if(copyN && !isNaN(Number(copyN)) && Number(copyN) > 0){
          setMaxCopyNumbers(Number(copyN));
        }
    }
    getMaxCopyNumbers();
  }, [authContext]);
  
  useEffect(() => {
    const fetchRateTypes = async () => {
      const rateType:ITipoTarifarioReq = {
        Clta_TipoTarifario: {
          oficina: authContext?.user?.profile?.oficina ?? ""
        }
      } 
      const { data: resClientData, error: resClientError } = await executeTarifario(() =>
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

  const getCommissionAmount = async (rateType: string) => {
    const request: IConsultaComisionReq = {
      producto: "CR",
      nemonico: rateType
    };    
    const { data: comRes, error } = await executeCommission(() =>
      getCommissionRate(request, t, authContext)
    );  
    if (!comRes) { 
      setModalData({
          title: t("msg.titles.invalidData", { ns: "error" }),
          description: t("msg.descriptions.default", { ns: "error" }),
        });      
      return; 
    }
    const commissionValue = comRes?.consulta_comision?.datos?.money;
    if(commissionValue && !isNaN(Number(commissionValue))){
      setCommission(Number(commissionValue));
    } else {
      setCommission(0);
    }
  }

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
            <ComboBoxField
              key={buildComponentId("cbxRT", "rateType")}
              id={buildComponentId("cbxRT", "rateType")}
              label={t("fields.rateType.label")}              
              value={{label:field.name, value: rateTypes.find((item) => item.valor === field.value)?.valor ?? ""}}
              items={rateTypes.map((item) => ({
                value: item.valor,
                label: `${item.nombre}`,
              }))}              
              error={fieldState.error?.message}
              onChange={field.onChange}
              loading={loading}
              required
            />           
          )}
        />
        <Controller
          name="copyNumbers"
          control={form.control}
          render={({ field, fieldState }) => (
            <ComboBoxField
              key={buildComponentId("cbxCC", "copyNumbers")}
              id={buildComponentId("cbxCC", "copyNumbers")}              
              label={t("pages.order.copyCount.label")}
              items={Array.from({ length: maxCopyNumbers }, (k, i) => ({ value: `${i+1}`, label: `${i+1}` }))}
              value={{label:field.name, value:field.value}}
              onChange={field.onChange}
              error={fieldState.error?.message}
              loading={loadingTarifario}
              required
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
