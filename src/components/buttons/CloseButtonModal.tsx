import IconSVG from "@/components/icons/IconSVG";
import { Field } from "@/components/ui/field";
import { Button } from "@/components/ui/button";
import { CancelIcon } from "@/assets/icons";
import { buildComponentId } from "@/utils/bootstrap/buildComponentId";

type IProps = Readonly<{
  onClick?: () => void;
}>;

const CloseButtonModal = ({ onClick }: IProps) => {
  return (
    <Field orientation="horizontal" className="max-w">
      <Button
        id={buildComponentId("btn", "ModalClose")}
        className="banrural-modal-close"
        type="button"
        onClick={onClick}
      >
        <span>
          <IconSVG id="modalCancel" src={CancelIcon} />
        </span>
      </Button>
    </Field>
  );
};

export default CloseButtonModal;
