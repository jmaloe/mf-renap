import { useTranslation } from "react-i18next";

import { Field } from "@/components/ui/field";
import { Button } from "@/components/ui/button";
import IconSVG from "@/components/icons/IconSVG";
import { CancelIcon, ChevronLeftIcon } from "@/assets/icons";
import { buildComponentId } from "@/utils/bootstrap/buildComponentId";

type IProps = Readonly<{
  onClick: () => void;
  isCancel?: boolean;
  isModal?: boolean;
  isPrintModal?: boolean;
  loading?: boolean;
}>;

const CancelButton = ({
  onClick,
  isCancel = false,
  isModal = false,
  isPrintModal = false,
  loading,
}: IProps) => {
  const { t } = useTranslation();
  const textModal = isModal ? "Modal" : "";
  let classModal = "w-full sm:w-fit";
  if (isModal) classModal = "max-w sm:max-w-1/2";
  if (isPrintModal) classModal = "w-full";

  return (
    <Field className={classModal}>
      <Button
        id={buildComponentId(
          "btn",
          `${textModal}${isCancel ? "Cancel" : "Back"}`,
        )}
        className="banrural-button-base button-ghost text-xs !px-6"
        data-loading={loading}
        type="button"
        onClick={onClick}
      >
        {!isCancel && (
          <span>
            <IconSVG
              id={`button${textModal}Back`}
              src={ChevronLeftIcon}
              isFill
              currentColor
            />
          </span>
        )}
        {isCancel ? t("buttons.cancel") : t("buttons.back")}
        {isCancel && (
          <span>
            <IconSVG
              id={`button${textModal}Cancel`}
              src={CancelIcon}
              currentColor
            />
          </span>
        )}
      </Button>
    </Field>
  );
};

export default CancelButton;
