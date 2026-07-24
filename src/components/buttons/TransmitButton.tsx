import { useTranslation } from "react-i18next";

import { Field } from "@/components/ui/field";
import { Button } from "@/components/ui/button";
import IconSVG from "@/components/icons/IconSVG";
import { PrintIcon, TransmitIcon } from "@/assets/icons";
import { buildComponentId } from "@/utils/bootstrap/buildComponentId";

type IProps = Readonly<{
  onClick: () => void;
  isPrint?: boolean;
  loading?: boolean;
}>;

const TransmitButton = ({
  isPrint = false,
  onClick,
  loading,
}: IProps) => {
  const { t } = useTranslation();
  let label = t("buttons.transmit");
  if (isPrint) label = t("buttons.print");

  return (
    <Field className="w-full sm:w-fit">
      <Button
        id={buildComponentId("btn", isPrint ? "Print" : "Next")}
        className="banrural-button-base banrural-button-primary text-xs !px-6"
        data-loading={loading}
        type="button"
        onClick={onClick}
      >
        {label}
        <span>
          <IconSVG
            id={isPrint ? "buttonPrint" : "buttonNext"}
            src={isPrint ? PrintIcon : TransmitIcon}
            currentColor
          />
        </span>
      </Button>
    </Field>
  );
};

export default TransmitButton;
