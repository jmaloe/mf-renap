import { Controller, useForm } from "react-hook-form";
import * as z from "zod";
import { zodResolver } from "@hookform/resolvers/zod";
import { useEffect, useState } from "react";
import { useTranslation } from "react-i18next";

import { FieldGroup, FieldLabel } from "@/components/ui/field";
import TransmitButton from "@/components/buttons/TransmitButton";
import WarningModal from "@/components/modals/WarningModal";
import { useRequest } from "@/utils/http/useRequest";
import { buildComponentId } from "@/utils/bootstrap/buildComponentId";
import MainFormCard from "@/components/cards/MainFormCard";
import MainGroupButton from "@/components/buttons/MainGroupButton";
import ComboBoxField from "@/components/ui/ComboBoxField";
import getParameterQuery from "@/services/getParameterQuery";
import getRateTypes from "@/services/getRateTypes";
import getCommissionRate from "@/services/getCommissionRate";
import type { INavigation } from "@/interfaces/components/navigation/INavigation";
import type { IModalData } from "@/interfaces/components/modal/IModalData";
import type { ICobroSolicitudReq } from "@/interfaces/services/cobroSolicitud/ICobroSolicitudReq";
import type { IAuthContext } from "@/interfaces/auth/IAuthContext";
import type { IComboBox } from "@/interfaces/components/fields/IComboBox";
import type { ITarifarioItems } from "@/interfaces/services/consultaTarifario/ITarifarioItems";
import type { ITarifarioRes } from "@/interfaces/services/consultaTarifario/ITarifarioRes";
import type { ITipoTarifarioReq } from "@/interfaces/services/consultaTipoTarifario/ITipoTarifarioReq";
import type { IComboBoxData } from "@/interfaces/components/fields/IComboBoxData";
import type { IConsultaComisionReq } from "@/interfaces/services/consultaComision/IConsultaComisionReq";
import type { IConsultaParametroRes } from "@/interfaces/services/consultaParametro/IConsultaParametroRes";
import type { IConsultaComisionRes } from "@/interfaces/services/consultaComision/IConsultaComisionRes";
import {getFormatNumber} from "@/utils/formats/formatNumber";
import getValidateAmount from "@/services/getValidateAmount";

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
  const { loading: loadingValidateAmount, execute: executeValidateAmount } = useRequest<ICobroSolicitudReq>(); 
  const { loading: loadingTarifario, execute: executeTarifario } = useRequest<ITarifarioRes>();
  const { loading: loadingCommission, execute: executeCommission } = useRequest<IConsultaComisionRes>();
  const [rateTypes, setRateTypes] = useState<ITarifarioItems[]>([]);
  const [onChangeModal, setOnChangeModal] = useState(false);
  const [modalData, setModalData] = useState<IModalData>();
  const [maxCopyNumbers, setMaxCopyNumbers] = useState<IConsultaParametroRes>();
  const [commissionData, setCommissionData] = useState<IConsultaComisionRes>();
  const [rateTypeSelected, setRateTypeSelected] = useState<IComboBox | null>(null);
  const [copyNumbersSelected, setCopyNumbersSelected] = useState<IComboBox | null>(null);
  const [subtotal, setSubtotal] = useState<number|null>(0.0);  
  const [totalAmount, setTotalAmount] = useState<number|null>(0.0);
  const [operationError, setOperationError] = useState("");

  const formSchema = z.object({
    rateType: z.string().trim().nonempty(t("field.rateType.nonEmpty", { ns: "error" })),
    copyNumbers: z.string().trim().nonempty(t("field.copyNumbers.nonEmpty", { ns: "error" })),
  });

  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      rateType: "",
      copyNumbers: "",
    },
    mode: "onChange",
    reValidateMode: "onChange",
  });

  const onSubmit = async (form: z.infer<typeof formSchema>) => {    
    const baseUrl = import.meta.env.BASE_URL;
    const user = authContext?.user?.username ?? "";
    const office = authContext?.user?.profile?.oficina ?? "";
    const profileId = authContext?.user?.profile?.id ?? "";       
    const clientIp = "127.0.0.1";            

    const orderData: ICobroSolicitudReq = {
      codigo_evento: form.rateType,
      usuario: user,
      caja_rural: office,
      url: baseUrl,
      grupo: profileId,
      monto: getFormatNumber(`${subtotal}`) ?? "0.00",
      cantidad_copias: form.copyNumbers,
      tipo_tarifa: "",
      orden_pago: "",
      total_pagar: getFormatNumber(`${totalAmount}`) ?? "0.00",
      ip: clientIp,
      nombre_evento: rateTypeSelected?.label ?? "NE",
      comision: getFormatNumber(`${commissionData?.consulta_comision?.datos?.money ?? "0"}`) ?? "0.00"      
    };

    const { data: resClientData, error: resClientError } = await executeValidateAmount(() =>
      getValidateAmount(orderData, t, authContext),
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
    
    onSubmitOrderData(orderData);
    onSelectPage("preview");
  };

  useEffect(() => {
    const getMaxCopyNumbers = async () => {
      const response = await getParameterQuery(t, authContext);
        const copyN = response?.consulta_parametro?.datos?.valor;
        if(copyN && !isNaN(Number(copyN)) && Number(copyN) > 0){
          setMaxCopyNumbers(response);
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
  }, [authContext, t, executeTarifario]); 

  const rateTypeItems: IComboBox[] = rateTypes.map((item) => ({
    value: String(item.cod ?? ""),
    label: item.nombre ?? "",
  }));    

  useEffect(() => {    
    const queryCommissions = async() => {
      if(!rateTypeSelected?.value)
      return;

      const a = Number(rateTypeSelected.value ?? "0.0"); 
      setSubtotal(a);

      const commissionReq:IConsultaComisionReq = {
        producto: "CR",
        nemonico: maxCopyNumbers?.consulta_parametro?.datos?.nemonico ?? "",
      }
      
      const { data: resClientData, error: resClientError } = await executeCommission(() => 
        getCommissionRate(commissionReq, t, authContext)
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
      setCommissionData(resClientData);
      
    }    
    queryCommissions();
  }, [rateTypeSelected]);

  useEffect(() => {
    const com = Number(commissionData?.consulta_comision.datos?.money ?? 0);
    const tot = Number(copyNumbersSelected?.value ?? "0") * Number(subtotal ?? 0) + com;
    setTotalAmount(tot);
  }, [copyNumbersSelected, rateTypeSelected, subtotal, loadingCommission]);

  const cbxRateFields: IComboBoxData = {
      id: "rateType",
      label: t("fields.rateType.label"),
      items: rateTypeItems,
      value: rateTypeSelected,
      error: operationError,
      onChange: setRateTypeSelected
  };

  const cbxCopyFields: IComboBoxData = {
    id: "copyNumbers",
    label: t("fields.copyNumbers.label"),
    items: Array.from({ length: Number(maxCopyNumbers?.consulta_parametro.datos?.valor) }, (item, i) => ({
      value: `${i + 1}`,
      label: `${i + 1}`,
    })),
    value: copyNumbersSelected,
    error: operationError,
    onChange: setCopyNumbersSelected
  };

  return (
    <MainFormCard
      titleCard={t("pages.home.title")}
      className="w-full sm:w-auto"
      loading={loadingTarifario}
    >
      <FieldGroup>
        <Controller
          name="rateType"
          control={form.control}
          render={({ field, fieldState }) => {
            const selectedValue = rateTypeSelected ??
              (field.value
                ? { value: String(field.value), label: String(field.value) }
                : null);

            return (
              <ComboBoxField
                key={buildComponentId("cbxRT", cbxRateFields.id)}
                id={buildComponentId("cbxRT", cbxRateFields.id)}
                label={cbxRateFields.label}
                value={selectedValue}
                items={cbxRateFields.items}
                error={fieldState.error?.message ?? cbxRateFields.error}
                onChange={(item: IComboBox | null) => {
                  field.onChange(item?.value ?? "");
                  setRateTypeSelected(item);
                }}
                loading={loadingTarifario}
                required
              />
            );
          }}
        />
        <Controller
          name="copyNumbers"
          control={form.control}
          render={({ field, fieldState }) => {
            const selectedValue = copyNumbersSelected ??
              (field.value
                ? { value: String(field.value), label: String(field.value) }
                : null);

            return (
              <ComboBoxField
                key={buildComponentId("cbxCC", cbxCopyFields.id)}
                id={buildComponentId("cbxCC", cbxCopyFields.id)}
                label={cbxCopyFields.label}
                items={cbxCopyFields.items}
                value={selectedValue}
                error={fieldState.error?.message ?? cbxCopyFields.error}
                onChange={(item: IComboBox | null) => {
                  field.onChange(item?.value ?? "");
                  setCopyNumbersSelected(item);
                }}
                loading={loadingTarifario}
                required
              />
            );
          }}
        />
        <FieldLabel
          id={buildComponentId("lbl", "amountTitle")}
          className="banrural-input-label text-base"
          htmlFor={buildComponentId("txt", "amount")}
        >
          <strong>{t("fields.amount.label")}</strong>          
        </FieldLabel>
        <FieldLabel
          id={buildComponentId("lbl", "amountValue")}
          className="banrural-input-label text-base"
          htmlFor={buildComponentId("txt", "amount")}
        >
          {getFormatNumber(`${subtotal}`) ?? "0.00"}
        </FieldLabel>
        <FieldLabel
          id={buildComponentId("lbl", "commissionTitle")}
          className="banrural-input-label text-base"
          htmlFor={buildComponentId("txt", "commission")}
        >
          <strong>{t("fields.commission.label")}</strong>          
        </FieldLabel>
        <FieldLabel
          id={buildComponentId("lbl", "commissionValue")}
          className="banrural-input-label text-base"
          htmlFor={buildComponentId("txt", "commission")}
        >
          {getFormatNumber(`${commissionData?.consulta_comision?.datos?.money ?? "0"}`) ?? "0.00"}
        </FieldLabel>
        <FieldLabel
          id={buildComponentId("lbl", "totalTitle")}
          className="banrural-input-label text-base"
          htmlFor={buildComponentId("txt", "total")}
        >
          <strong>{t("fields.totalAmount.label")}</strong>          
        </FieldLabel>
        <FieldLabel
          id={buildComponentId("lbl", "totalValue")}
          className="banrural-input-label text-base"
          htmlFor={buildComponentId("txt", "total")}
        >
          {getFormatNumber(`${totalAmount}`) ?? "0.00"}
        </FieldLabel>
      </FieldGroup>

      <MainGroupButton>
        <TransmitButton
          onClick={form.handleSubmit(onSubmit)}
          loading={loadingTarifario}
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
