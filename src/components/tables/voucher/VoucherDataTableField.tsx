import { buildComponentId } from "@/utils/bootstrap/buildComponentId";

type IProps = Readonly<{
  id: string;
  label: string;
  value: string;
}>;

const VoucherDataTableField = ({ id, label, value }: IProps) => {
  return (
    <div className="grid grid-cols-2 gap-2 leading-tight">
      <span
        id={buildComponentId("lbl", `${id}Title`)}
        className="text-right break-words"
      >
        {label}
      </span>
      <span
        id={buildComponentId("lbl", `${id}Value`)}
        className="text-left break-words"
      >
        {value}
      </span>
    </div>
  );
};

export default VoucherDataTableField;
