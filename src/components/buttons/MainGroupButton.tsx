import type { ReactNode } from "react";
import { useTranslation } from "react-i18next";

import MainSeparator from "@/components/separators/MainSeparator";
import WarningAlert from "@/components/alerts/WarningAlert";

type IProps = Readonly<{
  hasSeparator?: boolean;
  isAlert?: boolean;
  children: ReactNode;
}>;

const MainGroupButton = ({
  hasSeparator = false,
  isAlert = false,
  children,
}: IProps) => {
  const { t } = useTranslation();

  return (
    <>
      {hasSeparator && <MainSeparator />}
      {isAlert && <WarningAlert title={t("alerts.warning")} /> }
      <div className="flex flex-col sm:flex-row justify-center gap-2">
        {children}
      </div>
    </>
  );
};

export default MainGroupButton;
