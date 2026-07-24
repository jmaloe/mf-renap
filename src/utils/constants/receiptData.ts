import type { IReceiptPrintType } from "@/interfaces/components/receipt/IReceiptPrintType";
import type { ISize } from "@/interfaces/components/receipt/ISize";

export const letterSize: ISize = Object.freeze({
  width: 807,
  height: 1045,
});

export const voucherSize: ISize = Object.freeze({
  width: 340,
});

export const printTypes: IReceiptPrintType = Object.freeze({
  hibrid: "0",
  letter: "1",
  voucher: "2",
});
