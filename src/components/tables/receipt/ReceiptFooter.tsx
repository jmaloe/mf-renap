import { useTranslation } from "react-i18next";

import { buildComponentId } from "@/utils/bootstrap/buildComponentId";

type IProps = Readonly<{
  id: string;
  userName: string;
  classNameTable?: string;
}>;

export const ReceiptFooter = ({
  id,
  userName,
  classNameTable = "",
}: IProps) => {
  const { t } = useTranslation();
  return (
    <div className={classNameTable}>
      <div className="text-center leading-[1.2]">
        <span id={buildComponentId("lbl", `${id}Title`)} className="pr-1">
          {t("receipts.footer")}
        </span>
        <span id={buildComponentId("lbl", `${id}Value`)} className="uppercase">
          {userName}
        </span>
      </div>
    </div>
  );
};

export default ReceiptFooter;
