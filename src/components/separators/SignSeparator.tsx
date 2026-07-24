import { useTranslation } from "react-i18next";

const SignSeparator = () => {
  const { t } = useTranslation();
  return (
    <div className="text-center gap-2 px-2">
      <div className="flex items-center">
        <span>{t("receipts.sign.letter")}</span>
        <hr className="flex-1 border-gray-900 mt-2" />
      </div>
      <p className="mt-1">{t("receipts.sign.received")}</p>
    </div>
  );
};

export default SignSeparator;
