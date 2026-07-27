import { useTranslation } from "react-i18next";

import ReceiptUserTable from "@/components/tables/receipt/ReceiptUserTable";
import type { IReceiptData } from "@/interfaces/components/receipt/IReceiptData";
import type { ISize } from "@/interfaces/components/receipt/ISize";
import LetterDataTable from "@/components/tables/letter/LetterDataTable";
import ReceiptFooter from "@/components/tables/receipt/ReceiptFooter";
import ReceiptTitle from "@/components/titles/ReceiptTitle";
import type { IFieldData } from "@/interfaces/components/receipt/IFieldData";
import type { ISuffixLetter } from "@/interfaces/components/receipt/letter/ISuffixLetter";
import { buildComponentId } from "@/utils/bootstrap/buildComponentId";
import { getIsReprint } from "@/utils/bootstrap/buildReprint";

type IProps = Readonly<{
  receipt: IReceiptData;
  size: ISize;
  isSecond?: boolean;
}>;

const LetterView = ({ receipt, size, isSecond = false }: IProps) => {
  const { t } = useTranslation();
  const width = size.width + "px";
  const halfHeight = (size.height ?? 0) / 2;
  const height = halfHeight + "px";
  const suffix: ISuffixLetter = isSecond ? "Second" : "First";

  const contract = t("receipts.data.contract").toUpperCase();
  const currencySymbol = t("receipts.data.currencySymbol").toUpperCase();
  const invoiceSymbol = t("receipts.data.invoiceSymbol");
  const isReprint = getIsReprint();
  const fields: IFieldData[] = isReprint
    ? [
        {
          key: "top",
          label: "",
          value: "",
          hasReprint: true,
        },
        {
          key: "payment",
          label: t("receipts.data.payment"),
          value: contract,
        },
        {
          key: "referenceNumber",
          label: t("receipts.data.referenceNumber"),
          value: receipt.referencia,
        },
        {
          key: "concept",
          label: t("receipts.data.concept"),
          value: receipt.serviceName,
          hasReprint: true,
        }, 
        {
          key: "copyNumber",
          label: t("receipts.data.copynumbers"),
          value: String(receipt.copyNumbers)
        },
        {
          key: "amount",
          label: t("receipts.data.amount"),
          value: currencySymbol + receipt.amount,
        },                               
        {
          key: "invoice",
          label: t("receipts.data.invoice"),
          value: receipt.invoice,
        },
        {
          key: "receiptNumber",
          label: t("receipts.data.receiptNumber"),
          value: receipt.receiptNumber,
        },
        { 
          key: "date", 
          label: t("receipts.data.date"), 
          value: receipt.date 
        },
        {
          key: "bottom",
          label: "",
          value: "",
          hasReprint: true,
        },
      ]
    : [
        {
          key: "payment",
          label: t("receipts.data.payment"),
          value: contract,
        },
        {
          key: "referenceNumber",
          label: t("receipts.data.referenceNumber"),
          value: receipt.referencia,
        },
        {
          key: "concept",
          label: t("receipts.data.concept"),
          value: receipt.serviceName,
          hasReprint: true,
        }, 
        {
          key: "copyNumber",
          label: t("receipts.data.copynumbers"),
          value: String(receipt.copyNumbers)
        },
        {
          key: "amount",
          label: t("receipts.data.amount"),
          value: currencySymbol + receipt.amount,
        },                               
        {
          key: "invoice",
          label: t("receipts.data.invoice"),
          value: receipt.invoice,
        },
        {
          key: "receiptNumber",
          label: t("receipts.data.receiptNumber"),
          value: receipt.receiptNumber,
        },
        { 
          key: "date", 
          label: t("receipts.data.date"), 
          value: receipt.date 
        },
      ];

  return (
    <section id={buildComponentId("section", `Letter${suffix}`)}>
      <div
        className="mx-auto bg-white py-10"
        style={{ width, minHeight: height }}
      >
        <div
          id={buildComponentId("div", `LetterContent${suffix}`)}
          className="w-full h-full ring-0 border-2 border-gray-400 print:border-0 print:mx-auto print:px-[78.5px]"
        >
          <div className="text-black text-[14px] tracking-wide text-center">
            <div className="border-b-2 border-gray-400 text-center print:border-0">
              <ReceiptTitle className="text-sm" title={t("receipts.title")} />
            </div>
            <div
              className={`${isReprint ? "py-1" : "py-5"} px-5 grid gap-3 leading-[1.4]`}
            >
              <LetterDataTable
                fields={fields}
                suffix={suffix}
                t={t}
              />
              {isReprint && (
                <ReceiptTitle
                  className="mt-0 leading-[1.4]"
                  title={t("receipts.reprint.subtitle")}
                />
              )}
              <ReceiptUserTable
                id="letter"
                receipt={receipt}
                classNameTable={isReprint ? "mt-0" : "mt-6"}
                suffix={suffix}
              />
              <ReceiptFooter
                id="letterFooter"
                userName={receipt.userName}
                classNameTable={isReprint ? "mt-0" : "mt-6"}
              />
            </div>
          </div>
        </div>
      </div>
    </section>
  );
};

export default LetterView;
