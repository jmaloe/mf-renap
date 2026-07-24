import { useTranslation } from "react-i18next";

import { buildComponentId } from "@/utils/bootstrap/buildComponentId";

type IProps = Readonly<{
  loading?: boolean;
}>;

const MainLoader = ({ loading = true }: IProps) => {
  const { t } = useTranslation();
  if (loading === undefined || loading) {
    return (
      <section
        id={buildComponentId("section", "Loader")}
        className="fixed inset-0 z-32 flex items-center justify-center bg-black/10"
      >
        <article className="banrural-modal-panel max-h-[95dvh] !w-fit">
          <div
            className="banrural-loader"
            role="status"
            aria-live="polite"
            aria-busy="true"
          >
            <span className="banrural-loader-spinner" aria-hidden="true"></span>
            <p className="banrural-loader-label">{t("loader.label")}</p>
          </div>
        </article>
      </section>
    );
  }

  return null;
};

export default MainLoader;
