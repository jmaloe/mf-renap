import type { TFunction } from "i18next";

import LetterDataTableField from "@/components/tables/letter/LetterDataTableField";
import type { ISuffixLetter } from "@/interfaces/components/receipt/letter/ISuffixLetter";
import type { IFieldData } from "@/interfaces/components/receipt/IFieldData";
import { buildComponentId } from "@/utils/bootstrap/buildComponentId";
import { getIsReprint } from "@/utils/bootstrap/buildReprint";

type IProps = Readonly<{
  fields: IFieldData[];
  suffix: ISuffixLetter;
  t: TFunction;
}>;

export const LetterDataTable = ({ fields, suffix, t }: IProps) => {
  const isReprint = getIsReprint();
  return (
    <div id={buildComponentId("tbl", `LetterData${suffix}`)} className="w-full">
      <div className={`${isReprint ? "space-y-1" : "space-y-2"} leading-6`}>
        {fields.map(({ key, label, value, hasReprint }) => (
          <LetterDataTableField
            key={key}
            id={`${key}${suffix}`}
            label={label}
            value={value}
            t={t}
            hasReprint={hasReprint}
          />
        ))}
      </div>
    </div>
  );
};

export default LetterDataTable;
