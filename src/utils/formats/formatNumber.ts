import { getCleanString } from "@/utils/formats/formatString";

export const getFormatNumber = (number?: string | number): string => {
  if (!number) return "";

  const clean = number.toString();
  const num = Number(clean);

  if (Number.isNaN(num)) return "";

  const format = num
    .toLocaleString("en-US", {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    })
    .replaceAll(",", "");

  return getCleanString(format);
};
