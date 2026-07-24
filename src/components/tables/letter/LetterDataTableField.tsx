import type { TFunction } from "i18next";

import { buildComponentId } from "@/utils/bootstrap/buildComponentId";
import { getIsReprint } from "@/utils/bootstrap/buildReprint";

type IProps = Readonly<{
  id: string;
  label: string;
  value: string;
  t: TFunction;
  hasReprint?: boolean;
}>;

const LetterDataTableField = ({ id, label, value, t, hasReprint }: IProps) => {
  const isReprint = getIsReprint();
  return (
    <div
      className={
        isReprint ? "grid-cols-4 grid gap-4" : "grid-cols-2 grid gap-8"
      }
    >
      {isReprint && (
        <p
          id={buildComponentId("lbl", `${id}Reprint`)}
          className="text-center break-words font-bold text-[16px]"
        >
          {hasReprint && t("receipts.reprint.title")}
        </p>
      )}
      <p
        id={buildComponentId("lbl", `${id}Title`)}
        className="text-right break-words uppercase"
      >
        <span className="leading-tight">{label}</span>
      </p>
      <p
        id={buildComponentId("lbl", `${id}Value`)}
        className="text-left break-words"
      >
        <span className="leading-tight">{value}</span>
      </p>
      {isReprint && (
        <p
          id={buildComponentId("lbl", `${id}Reprint`)}
          className="text-center break-words font-bold text-[16px]"
        >
          {hasReprint && t("receipts.reprint.title")}
        </p>
      )}
    </div>
  );
};

export default LetterDataTableField;
