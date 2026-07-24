import CancelButton from "@/components/buttons/CancelButton";

type IProps = Readonly<{
  onClick: () => void;
  isModal?: boolean;
  isPrintModal?: boolean;
}>;

const ActionButtonsModal = ({
  onClick,
  isModal = false,
  isPrintModal = false,
}: IProps) => {
  return (
    <div className="banrural-modal-actions">
      <div className="flex flex-col sm:flex-row justify-center gap-2 w-full">
        <CancelButton
          onClick={onClick}
          isModal={isModal}
          isPrintModal={isPrintModal}
        />
      </div>
    </div>
  );
};

export default ActionButtonsModal;
