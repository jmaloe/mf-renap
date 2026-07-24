import { useEffect, useRef, useState } from "react";
import { useReactToPrint } from "react-to-print";
import { useTranslation } from "react-i18next";

import CancelButton from "@/components/buttons/CancelButton";
import TransmitButton from "@/components/buttons/TransmitButton";
import PrintTypeRadioButton from "@/components/radios/PrintTypeRadioButton";
import type { INavigation } from "@/interfaces/components/navigation/INavigation";
import type { IPrintNavigation } from "@/interfaces/components/navigation/IPrintNavigation";
import VoucherView from "@/views/pages/receipts/VoucherView";
import LetterView from "@/views/pages/receipts/LetterView";
import type { IReceiptData } from "@/interfaces/components/receipt/IReceiptData";
import WarningAlert from "@/components/alerts/WarningAlert";
import type { IAuthContext } from "@/interfaces/auth/IAuthContext";
import useAutoScale from "@/hooks/useAutoScale";
import {
  letterSize,
  printTypes,
  voucherSize,
} from "@/utils/constants/receiptData";
import PrintCard from "@/components/cards/PrintCard";
import MainGroupButton from "@/components/buttons/MainGroupButton";

type IProps = Readonly<{
  authContext?: IAuthContext | null;
  receipt: IReceiptData;
  onSelectPage: (item: INavigation) => void;
}>;

const ReceiptView = ({ authContext, receipt, onSelectPage }: IProps) => {
  const { t } = useTranslation();
  const baseName = import.meta.env.VITE_BASE_NAME ?? "mf-root";
  const printRef = useRef<HTMLDivElement>(null);
  const [contentHeight, setContentHeight] = useState(0);

  const idPrintType = (authContext?.user?.printType?.codigo ?? "").trim();
  let isVoucher = true;
  let isLetter = true;
  if (idPrintType && idPrintType !== "") {
    isVoucher =
      idPrintType === printTypes.hibrid || idPrintType === printTypes.voucher;
    isLetter =
      idPrintType === printTypes.hibrid || idPrintType === printTypes.letter;
  }
  const shouldShowPrint = isVoucher || isLetter;

  const getInitialPrintType = (): IPrintNavigation => {
    if (isVoucher) return "voucher";
    if (isLetter) return "letter";
    return "";
  };
  const [printType, setPrintType] = useState<IPrintNavigation>(
    getInitialPrintType(),
  );

  useEffect(() => {
    if (!printRef.current) return;

    const updateHeight = () => {
      const realHeight = printRef.current?.scrollHeight ?? 0;
      setContentHeight(realHeight);
    };

    updateHeight();
    const resizeObserver = new ResizeObserver(updateHeight);
    resizeObserver.observe(printRef.current);
    return () => resizeObserver.disconnect();
  }, [printType, receipt]);

  const contentWidth =
    printType === "voucher" ? voucherSize.width : letterSize.width;
  const { containerRef, scale } = useAutoScale({ contentWidth });

  const onPrint = useReactToPrint({
    contentRef: printRef,
    documentTitle:
      printType === "voucher"
        ? "comprobante-voucher"
        : "comprobante-media-carta",
    pageStyle: `
            @media print {
                @page {
                    margin: 0;
                    size: ${
                      isVoucher
                        ? `${voucherSize.width}px auto`
                        : `${letterSize.width}px ${letterSize.height}px`
                    }
                }
            }
        `,
  });

  const onCancel = () => {
    const onClose = authContext?.transactInfo?.onClose;
    if (onClose) onClose();
    else onSelectPage("home");
  };

  return (
    <PrintCard>
      {!isVoucher && !isLetter ? (
        <div className="mt-1">
          <WarningAlert title={t("alerts.print")} />
        </div>
      ) : (
        <div
          ref={containerRef}
          className="w-full overflow-hidden flex justify-center"
        >
          <div
            style={{
              transform: `scale(${scale})`,
              transformOrigin: "top center",
              height: `${contentHeight * scale}px`,
            }}
          >
            <div id={baseName} className="h-auto! min-h-auto!" ref={printRef}>
              {printType === "voucher"
                ? isVoucher && (
                    <VoucherView receipt={receipt} size={voucherSize} />
                  )
                : isLetter && (
                    <LetterView receipt={receipt} size={letterSize} />
                  )}
              {printType !== "voucher" && isLetter && (
                <div className="overflow-hidden h-0 print:overflow-visible print:h-auto">
                  <LetterView receipt={receipt} size={letterSize} isSecond />
                </div>
              )}
            </div>
          </div>
        </div>
      )}
      {isVoucher && isLetter && (
        <PrintTypeRadioButton value={printType} onChangeValue={setPrintType} />
      )}
      <MainGroupButton hasSeparator>
        <CancelButton onClick={onCancel} />
        {shouldShowPrint && <TransmitButton onClick={onPrint} isPrint />}
      </MainGroupButton>
    </PrintCard>
  );
};

export default ReceiptView;
