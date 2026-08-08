import { buildComponentId } from "@/utils/bootstrap/buildComponentId";

type IProps = Readonly<{
  id: string;
  label: string;
  value: string;
}>;

const VoucherDataTableField = ({ id, label, value }: IProps) => {
  if (!label) {
    return (
      <div className="text-center">
        <span
          id={buildComponentId("lbl", `${id}Value`)}
          className="block break-words leading-[1.2]"
        >
          {value}
        </span>
      </div>
    );
  }

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
