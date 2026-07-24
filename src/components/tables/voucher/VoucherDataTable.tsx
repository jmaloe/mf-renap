import VoucherDataTableField from "@/components/tables/voucher/VoucherDataTableField";
import type { IFieldData } from "@/interfaces/components/receipt/IFieldData";
import { buildComponentId } from "@/utils/bootstrap/buildComponentId";

type IProps = Readonly<{
  fields: IFieldData[];
}>;

export const VoucherDataTable = ({ fields }: IProps) => {
  return (
    <div
      id={buildComponentId("tbl", "VoucherData")}
      className="w-full space-y-2 leading-tight uppercase"
    >
      {fields.map(({ key, label, value }) => (
        <VoucherDataTableField key={key} id={key} label={label} value={value} />
      ))}
    </div>
  );
};

export default VoucherDataTable;
