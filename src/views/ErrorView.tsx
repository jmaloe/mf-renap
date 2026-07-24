import { useTranslation } from "react-i18next";

import WarningAlert from "@/components/alerts/WarningAlert";

const ErrorView = () => {
  const { t } = useTranslation();

  return (
    <section className="flex items-center justify-center">
      <WarningAlert
        title={t("msg.descriptions.noPermissions", { ns: "error" })}
      />
    </section>
  );
};

export default ErrorView;
