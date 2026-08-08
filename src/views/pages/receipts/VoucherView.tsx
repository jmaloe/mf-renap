import { useTranslation } from "react-i18next";

import SignSeparator from "@/components/separators/SignSeparator";
import type { IReceiptData } from "@/interfaces/components/receipt/IReceiptData";
import type { ISize } from "@/interfaces/components/receipt/ISize";
import handleImageError from "@/utils/errors/handleImageError";
import ReceiptUserTable from "@/components/tables/receipt/ReceiptUserTable";
import VoucherDataTable from "@/components/tables/voucher/VoucherDataTable";
import ReceiptFooter from "@/components/tables/receipt/ReceiptFooter";
import ReceiptTitle from "@/components/titles/ReceiptTitle";
import type { IFieldData } from "@/interfaces/components/receipt/IFieldData";
import { ReceiptLogoImg } from "@/assets/img";
import { buildComponentId } from "@/utils/bootstrap/buildComponentId";
import { getIsReprint } from "@/utils/bootstrap/buildReprint";

type IProps = Readonly<{
  receipt: IReceiptData;
  size: ISize;
}>;

const VoucherView = ({ receipt, size }: IProps) => {
  const { t } = useTranslation();
  const width = size.width + "px";
  const isReprint = getIsReprint();

  const contract = t("receipts.data.contract").toUpperCase();
  const currencySymbol = t("receipts.data.currencySymbol").toUpperCase();
  const fields: IFieldData[] = [
    {
      key: "linea_1",
      label: "",
      value: receipt.linea_1,
    },
    {
      key: "linea_2",
      label: "",
      value: receipt.linea_2,
    },
    {
      key: "linea_3",
      label: "",
      value: receipt.linea_3,
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
    },
    {
      key: "boletaRenap",
      label: t("receipts.data.boletaRenap"),
      value: receipt.boleta_pago,
    },
    {
      key: "copyNumber",
      label: t("receipts.data.copynumbers"),
      value: String(receipt.copyNumbers),
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
      value: receipt.date,
    },
  ];

  return (
    <section id={buildComponentId("section", "Voucher")}>
      <div className="h-auto mx-auto bg-white py-1" style={{ width }}>
        <div
          id={buildComponentId("div", "VoucherContent")}
          className="w-full h-auto ring-0 border-2 border-gray-400 pt-2 pb-5 px-5 bg-white text-black text-[11px] print:border-0 print:px-9"
        >
          <div className="mb-2 flex justify-center">
            <img
              className="h-auto max-w-45 object-contain"
              alt="icon-receipt"
              src={ReceiptLogoImg}
              onError={handleImageError}
            />
          </div>
          <ReceiptTitle className="mb-4" title={t("receipts.title")} />
          <VoucherDataTable fields={fields} />
          <div className="text-[10px]">
            <div className="mt-8 leading-none">
              <SignSeparator />
            </div>
            {isReprint && (
              <ReceiptTitle
                className="mt-6 leading-[1.2]"
                title={t("receipts.reprint.subtitle")}
              />
            )}
            <ReceiptUserTable
              id="voucher"
              receipt={receipt}
              classNameTable="mt-6"
              isVoucher
            />
            <ReceiptFooter
              id="voucherFooter"
              userName={receipt.userName}
              classNameTable="mt-6"
            />
          </div>
        </div>
      </div>
    </section>
  );
};

export default VoucherView;
