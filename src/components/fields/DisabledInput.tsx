import type { InputHTMLAttributes } from "react";
import { useTranslation } from "react-i18next";

import { Field, FieldDescription, FieldLabel } from "@/components/ui/field";
import { Input } from "@/components/ui/input";
import { buildComponentId } from "@/utils/bootstrap/buildComponentId";

type IProps = Readonly<
  InputHTMLAttributes<HTMLInputElement> & {
    id: string;
    label: string;
    value: string;
    description?: string;
    required: boolean;
  }
>;

const DisabledInput = ({
  id,
  label,
  value,
  description,
  required,
  ...conf
}: IProps) => {
  const { t } = useTranslation();
  return (
    <Field className="banrural-input-item disabled">
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
          {...conf}
          id={buildComponentId("txt", id)}
          className="border-0 focus-visible:ring-0 aria-invalid:ring-0 value"
          type="text"
          value={value}
          required={required}
          disabled
        />
      </div>
      {description && (
        <FieldDescription
          id={buildComponentId("lbl", `${id}Description`)}
          className="banrural-input-help text-base"
        >
          {description}
        </FieldDescription>
      )}
    </Field>
  );
};

export default DisabledInput;
