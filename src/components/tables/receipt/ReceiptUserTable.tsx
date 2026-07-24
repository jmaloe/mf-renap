import { useTranslation } from "react-i18next";

import type { IReceiptData } from "@/interfaces/components/receipt/IReceiptData";
import ReceiptUserTableField from "@/components/tables/receipt/ReceiptUserTableField";
import type { ISuffixLetter } from "@/interfaces/components/receipt/letter/ISuffixLetter";
import type { IFieldUser } from "@/interfaces/components/receipt/IFieldUser";
import { buildComponentId } from "@/utils/bootstrap/buildComponentId";

type IProps = Readonly<{
  id: string;
  receipt: IReceiptData;
  classNameTable?: string;
  suffix?: ISuffixLetter;
  isVoucher?: boolean;
}>;

const ReceiptUserTable = ({
  id,
  receipt,
  classNameTable = "",
  suffix,
  isVoucher = false,
}: IProps) => {
  const { t } = useTranslation();
  const safeSuffix = suffix ?? "";
  const fields: IFieldUser[] = [
    [
      {
        key: "office",
        label: t("receipts.userData.office"),
        value: receipt.office,
        align: "left",
      },
      {
        key: "user",
        label: t("receipts.userData.user"),
        value: receipt.user,
        align: "right",
      },
    ],
    [
      {
        key: "userName",
        label: t("receipts.userData.name"),
        value: receipt.userName,
        align: "left",
      },
      {
        key: "clientName",
        label: t("receipts.userData.name"),
        value: receipt.userInitials,
        align: "right",
      },
    ],
    [
      {
        key: "department",
        label: t("receipts.userData.department"),
        value: receipt.department,
        align: "left",
      },
      {
        key: "city",
        label: t("receipts.userData.city"),
        value: receipt.city,
        align: "right",
      },
    ],
  ];
  const gapClass = isVoucher ? "gap-2" : "gap-8";
  return (
    <div
      id={buildComponentId("tbl", `${id}User${safeSuffix}`)}
      className={classNameTable}
    >
      <div className="w-full space-y-1 leading-[0.8]">
        {fields.map((field, fieldIndex) => (
          <div
            key={`${field[0].key}-${field[1].key}`}
            className={`grid grid-cols-2 ${
              fieldIndex === 0 ? gapClass : "gap-2"
            }`}
          >
            {field.map(({ key, value, align, label }) => (
              <ReceiptUserTableField
                key={key}
                id={`${key}${safeSuffix}`}
                label={label}
                value={value}
                align={align}
              />
            ))}
          </div>
        ))}
      </div>
    </div>
  );
};

export default ReceiptUserTable;
