import { useTranslation } from "react-i18next";

import WarningAlert from "@/components/alerts/WarningAlert";
import type { IAuthContext } from "@/interfaces/auth/IAuthContext";
import ActionButtonsModal from "@/components/buttons/ActionButtonsModal";

type IProps = Readonly<{
  message?: string;
  authContext?: IAuthContext | null;
}>;

const ErrorReprintView = ({ message = "", authContext }: IProps) => {
  const { t } = useTranslation();
  const msg =
    message.trim() === ""
      ? t("msg.descriptions.noPermissions", { ns: "error" })
      : message.trim();

  const onClick = () => {
    const onClose = authContext?.transactInfo?.onClose;
    if (onClose) onClose();
  };

  return (
    <section>
      <div className="flex items-center justify-center mb-4">
        <WarningAlert title={msg} />
      </div>
      <ActionButtonsModal onClick={onClick} isPrintModal />
    </section>
  );
};

export default ErrorReprintView;
