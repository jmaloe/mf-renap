import { buildComponentId } from "@/utils/bootstrap/buildComponentId";
import { toSentenceCase } from "@/utils/formats/formatString";

type IProps = Readonly<{
  title: string;
  description: string;
}>;

const ModalTitle = ({ title, description }: IProps) => {
  const formatTitle = toSentenceCase(title);
  const formatDescription = toSentenceCase(description);
  return (
    <div className="banrural-modal-text">
      <h3 id={buildComponentId("lbl", "ModalTitle")}>{formatTitle}</h3>
      <p id={buildComponentId("lbl", "ModalDescription")}>{formatDescription}</p>
    </div>
  );
};

export default ModalTitle;
