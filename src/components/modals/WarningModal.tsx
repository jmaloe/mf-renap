import ModalAlertIcon from "@/components/icons/ModalAlertIcon";
import ModalTitle from "@/components/titles/ModalTitle";
import CloseButtonModal from "@/components/buttons/CloseButtonModal";
import ActionButtonsModal from "@/components/buttons/ActionButtonsModal";
import { buildComponentId } from "@/utils/bootstrap/buildComponentId";

type IProps = Readonly<{
  onChangeModal: boolean;
  setOnChangeModal: (state: boolean) => void;
  title?: string;
  description?: string;
  onConfirm?: () => void;
}>;

const WarningModal = ({
  onChangeModal,
  setOnChangeModal,
  title,
  description,
  onConfirm,
}: IProps) => {
  if (!onChangeModal) return null;

  const onClick = () => {
    if (onConfirm) onConfirm();
    else setOnChangeModal(false);
  };

  return (
    <div className="fixed inset-0 z-31 flex items-center justify-center bg-black/10">
      <article
        id={buildComponentId("modal", "ClientWarning")}
        className="banrural-modal-panel max-h-[95dvh]"
      >
        <CloseButtonModal onClick={onClick} />
        <ModalAlertIcon />
        <ModalTitle title={title || ""} description={description || ""} />
        <ActionButtonsModal onClick={onClick} isModal />
      </article>
    </div>
  );
};

export default WarningModal;
