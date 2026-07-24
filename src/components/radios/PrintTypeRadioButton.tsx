import { useTranslation } from "react-i18next";

import { FieldLabel } from "@/components/ui/field";
import type { IPrintNavigation } from "@/interfaces/components/navigation/IPrintNavigation";
import { toCapitalizeFirst } from "@/utils/formats/formatString";
import { buildComponentId } from "@/utils/bootstrap/buildComponentId";

type IProps = Readonly<{
  value: IPrintNavigation;
  onChangeValue: (value: IPrintNavigation) => void;
}>;

const PrintTypeRadioButton = ({ value, onChangeValue }: IProps) => {
  const { t } = useTranslation();
  const options = [
    {
      id: toCapitalizeFirst("voucher"),
      value: "voucher" as const,
      label: t("radioButtons.printers.voucher"),
    },
    {
      id: toCapitalizeFirst("letter"),
      value: "letter" as const,
      label: t("radioButtons.printers.letter"),
    },
  ];

  return (
    <div className="flex flex-col gap-5">
      {options.map((option) => {
        const isSelected = value === option.value;
        return (
          <FieldLabel
            key={option.value}
            className="gap-3 text-xs cursor-pointer font-normal"
          >
            <input
              id={buildComponentId("rb", `Print${option.id}`)}
              type="radio"
              className="banrural-radio"
              name={value}
              checked={isSelected}
              onChange={() => onChangeValue(option.value)}
            />
            <span>{option.label}</span>
          </FieldLabel>
        );
      })}
    </div>
  );
};

export default PrintTypeRadioButton;
