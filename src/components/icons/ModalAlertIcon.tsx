import { WarningIcon } from "@/assets/icons";
import IconSVG from "@/components/icons/IconSVG";

const ModalAlertIcon = () => {
  return (
    <div className="banrural-modal-alert" aria-hidden="true">
      <span className="text-yellow-600 p-8">
        <IconSVG id="modalWarning" src={WarningIcon} />
      </span>
    </div>
  );
};

export default ModalAlertIcon;
