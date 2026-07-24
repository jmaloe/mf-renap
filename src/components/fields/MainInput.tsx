import type { InputHTMLAttributes } from "react";
import type {
  ControllerFieldState,
  ControllerRenderProps,
  FieldValues,
  Path,
} from "react-hook-form";
import { useTranslation } from "react-i18next";

import { Field, FieldError, FieldLabel } from "@/components/ui/field";
import { Input } from "@/components/ui/input";
import IconSVG from "@/components/icons/IconSVG";
import { ErrorIcon, SuccessIcon } from "@/assets/icons";
import { buildComponentId } from "@/utils/bootstrap/buildComponentId";

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
  ...conf
}: IProps<TFieldValues, TName>) => {
  const { t } = useTranslation();
  const isInvalid = fieldState.invalid;
  const hasValue = field.value !== "" && field.value !== undefined;
  const isValid = !fieldState.invalid && fieldState.isDirty && hasValue;

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
