import { useTranslation } from "react-i18next";

const SignSeparator = () => {
  const { t } = useTranslation();
  return (
    <div className="px-2 text-center">
      <div className="mx-auto flex w-[260px] max-w-full items-end justify-center gap-1 text-[10px] leading-none">
        <span className="shrink-0">{t("receipts.sign.letter")}</span>
        <div className="h-px flex-1 border-b border-black" />
      </div>
      <p className="mt-1 text-[9px] leading-none">
        {t("receipts.sign.received")}
      </p>
    </div>
  );
};

export default SignSeparator;
