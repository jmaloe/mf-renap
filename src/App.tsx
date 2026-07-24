import { useEffect, useRef, useState } from "react";
import { I18nextProvider } from "react-i18next";

import "@/index.css";
import { MfI18n } from "@/i18n";
import type { IAuthContext } from "@/interfaces/auth/IAuthContext";
import RenapView from "@/views/renap/RenapView";
import MainLoader from "@/components/loader/MainLoader";
import ErrorView from "@/views/ErrorView";
import getUserAccess from "@/services/getUserAccess";
import { setCurrentScreen } from "@/utils/bootstrap/buildComponentId";

type Props = Readonly<{
  authProps?: IAuthContext;
}>;

const App = ({ authProps }: Props) => {
  const i18n = MfI18n;

  const [i18nReady, setI18nReady] = useState(() => i18n.isInitialized);
  const [hasAccess, setHasAccess] = useState<boolean | null>(null);
  const baseName = import.meta.env.VITE_BASE_NAME ?? "mf-root";
  const hasLoadedRef = useRef(false);

  useEffect(() => {
    const markReady = () => setI18nReady(true);
    i18n.on("initialized", markReady);
    i18n.on("loaded", markReady);
    if (i18n.isInitialized) markReady();
    return () => {
      i18n.off("initialized", markReady);
      i18n.off("loaded", markReady);
    };
  }, [i18n]);

  useEffect(() => {
    if (hasLoadedRef.current) return;
    hasLoadedRef.current = true;

    const validateAccess = async () => {        
      if (!authProps?.isAuthenticated) return;
      try {
        const access = await getUserAccess(authProps);
        setHasAccess(access);
      } catch {
        setHasAccess(false);
      }
    };

    validateAccess();
  }, [authProps]);

  const renderContent = ({ authProps }: Props) => {
    setCurrentScreen("home");

    if (!i18nReady) return <MainLoader />;
    if (!authProps) return <ErrorView />;

    const { isAuthenticated, isLoading } = authProps;
    if (isLoading) return <MainLoader />;
    if (!isAuthenticated) return <ErrorView />;

    if (hasAccess === null) return <MainLoader />;
    if (!hasAccess) return <ErrorView />;

    return <RenapView authProps={authProps} />;
  };

  return (
    <I18nextProvider i18n={i18n}>
      <section id={baseName}>
        <div className="p-1">{renderContent({ authProps })}</div>
      </section>
    </I18nextProvider>
  );
};

export default App;
