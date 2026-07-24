import { buildComponentId } from "@/utils/bootstrap/buildComponentId";

type IProps = Readonly<{
  id: string;
  label: string;
  value: string;
  align: "left" | "right";
}>;

export const ReceiptUserTableField = ({ id, label, value, align }: IProps) => {
  const textAlign = align === "left" ? "text-left" : "text-right";
  return (
    <p className={`${textAlign} break-words`}>
      <span id={buildComponentId("lbl", id)} className="leading-tight">
        {label + " " + value.toUpperCase()}
      </span>
    </p>
  );
};

export default ReceiptUserTableField;
