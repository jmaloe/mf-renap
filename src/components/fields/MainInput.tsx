import { useEffect, useState, type InputHTMLAttributes } from "react";
import type {
  ControllerFieldState,
  ControllerRenderProps,
  FieldValues,
  Path,
} from "react-hook-form";
import { useTranslation } from "react-i18next";

import { Field, FieldError, FieldGroup, FieldLabel } from "@/components/ui/field";
import ComboBoxField from "@/components/ui/ComboBoxField";
import { Input } from "@/components/ui/input";
import IconSVG from "@/components/icons/IconSVG";
import { ErrorIcon, SuccessIcon } from "@/assets/icons";
import { buildComponentId } from "@/utils/bootstrap/buildComponentId";
import type { ITarifarioItems } from "@/interfaces/services/consultaTarifario/ITarifarioItems";
import type { ITarifarioRes } from "@/interfaces/services/consultaTarifario/ITarifarioRes";
import { useRequest } from "@/utils/http/useRequest";
import type { ITipoTarifarioReq } from "@/interfaces/services/consultaTipoTarifario/ITipoTarifarioReq";
import type { IAuthContext } from "@/interfaces/auth/IAuthContext";
import getRateTypes from "@/services/getRateTypes";
import type { IModalData } from "@/interfaces/components/modal/IModalData";
import getParameterQuery from "@/services/getParameterQuery";

type IProps<
  TFieldValues extends FieldValues = FieldValues,
  TName extends Path<TFieldValues> = Path<TFieldValues>,
> = Readonly<
  InputHTMLAttributes<HTMLInputElement> & {
    id: string;
    label: string;
    required?: boolean;
    field: ControllerRenderProps<TFieldValues, TName>;
    fieldState: ControllerFieldState;
    maxCopyNumbers?: number;
    authContext: IAuthContext | null | undefined;
    setModalModal: (modalData: IModalData) => void;
    setOnChangeModal: (isOpen: boolean) => void;
  }
>;

const MainInput = <
  TFieldValues extends FieldValues = FieldValues,
  TName extends Path<TFieldValues> = Path<TFieldValues>,
>({
  id,
  label,
  required = true,
  field,
  fieldState,  
  authContext,
  setModalModal,  
  setOnChangeModal,
  ...conf
}: IProps<TFieldValues, TName>) => {
  const { t } = useTranslation();
  const isInvalid = fieldState.invalid;
  const hasValue = field.value !== "" && field.value !== undefined;
  const isValid = !fieldState.invalid && fieldState.isDirty && hasValue;
  const [maxCopyNumbers, setMaxCopyNumbers] = useState<number>(0);  
  const { loading, execute } = useRequest<ITarifarioRes>();
  const [rateTypes, setRateTypes] = useState<ITarifarioItems[]>([]);
  
  useEffect(() => {
    const fetchRateTypes = async () => {
      const rateType:ITipoTarifarioReq = {
        Clta_TipoTarifario: {
          oficina: authContext?.user?.profile?.oficina ?? ""
        }
      } 
      const { data: resClientData, error: resClientError } = await execute(() =>
        getRateTypes(rateType, t, authContext)
      );
      if (!resClientData) {
        setModalModal({
          title: t("msg.titles.invalidData", { ns: "error" }),
          description:
            resClientError || t("msg.descriptions.default", { ns: "error" }),
        });
        setOnChangeModal(true);
        return;
      }
      setRateTypes(resClientData?.Clta_Tarifario?.datos ?? []);
      const response = await getParameterQuery(t, authContext);
      const copyN = response?.consulta_parametro?.datos?.valor;
      if(copyN && !isNaN(Number(copyN)) && Number(copyN) > 0){
        setMaxCopyNumbers(Number(copyN));
      }
    };
    fetchRateTypes();
  }, [authContext]); 

  let fieldClass = "banrural-input-item";
  let icon = null;
  if (isInvalid) {
    fieldClass += " error";
    icon = ErrorIcon;
  } else if (isValid) {
    fieldClass += " success";
    icon = SuccessIcon;
  }

  return (
    <Field className={fieldClass}>
      <FieldLabel
        id={buildComponentId("lbl", `${id}Title`)}
        className="banrural-input-label text-base"
        htmlFor={buildComponentId("txt", id)}
      >
        <strong>{label}</strong>
        {!required && <span className="optional">{t("fields.optional")}</span>}
      </FieldLabel>
      <FieldGroup>          
        <ComboBoxField
          key={buildComponentId("cbxRT", id)}
          id={buildComponentId("cbxRT", id)}
          label={t("fields.rateType.label")}
          items={rateTypes.map((item) => ({
            value: item.valor,
            label: `${item.nombre}`,
          }))}
          value={field.value}
          error={t(`errors.field.rateType.nonEmpty`)}
          onChange={field.onChange}
          loading={loading}
          required
        />      
        <ComboBoxField
          key={buildComponentId("cbxCC", id)}
          id={buildComponentId("cbxCC", id)}
          label={t("fields.copyCount.label")}
          items={Array.from({ length: maxCopyNumbers }, (_, i) => ({
            value: (i + 1).toString(),
            label: `${i + 1}`,
          }))}
          value={field.value}
          error={t(`errors.field.copyCount.nonEmpty`)}
          onChange={field.onChange}
          loading={loading}
          required
        />
      </FieldGroup>
      <div className="banrural-input-shell">
        <Input
          {...field}
          {...conf}
          id={buildComponentId("txt", id)}
          className="border-0 focus-visible:ring-0 aria-invalid:ring-0 value"
          aria-invalid={fieldState.invalid}
          type="text"
          onPaste={(e) => e.preventDefault()}
          autoComplete="off"
        />
        <span className="banrural-input-icon" aria-hidden="true">
          <IconSVG id={id} src={icon} />
        </span>
      </div>
      {fieldState.invalid && (
        <FieldError
          id={buildComponentId("lbl", `${id}Error`)}
          className="banrural-input-help text-base"
          errors={[fieldState.error]}
        />
      )}
    </Field>
  );
};

export default MainInput;
