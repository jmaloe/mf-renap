import { useEffect, useRef, useState } from "react";
import { I18nextProvider } from "react-i18next";

import "@/index.css";
import { MfI18n } from "@/i18n";
import type { IAuthContext } from "@/interfaces/auth/IAuthContext";
import MainView from "@/views/MainView";
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

  authProps = {
    isAuthenticated: true,
    isLoading: false,
    user: {
      id: "2ef4bd18-bf43-427a-8e86-d75aa123ed76",
      name: "User BanruralTest",
      username: "226513100721",
      email: "test@test.com",
      roles: [
        "default-roles-br-cajabr-realm",
        "offline_access",
        "uma_authorization"
      ],
      profile: {
        cuenta: "3268040966",
        oficina: "50201",
        nombre: "PRUEBA 2",
        descripcion: "LUIS ORLANDO ARREDONDO AREVALO",
        rol: "55",
        id: "42",
        rest: "1",
        renap: "",
        latitud: "0.0",
        longitud: "0.0",
        rolData: {
          descripcionRol: "Administrador"
        },
        departmentData: {
          departamento: "Guatemala",
          municipio: "Fraijanes"
        }
      },
      printType: {
        codigo: "0",
        descripcion: "Hibrida"
      }
    },
    transactInfo: null,
    login: (() => (true)),
    logout: (() => (true)),
    token: import.meta.env.VITE_APIGATEWAY_TOKEN ?? "mf-root",
    tokenParsed: 'ABCDEFGHIJKLMNOPQRSTUVWX',
    loginWithAcr: (() => (true))
  }

  const renderContent = ({ authProps }: Props) => {
    setCurrentScreen("home");

    if (!i18nReady) return <MainLoader />;
    if (!authProps) return <ErrorView />;

    const { isAuthenticated, isLoading } = authProps;
    if (isLoading) return <MainLoader />;
    if (!isAuthenticated) return <ErrorView />;

    if (hasAccess === null) return <MainLoader />;
    if (!hasAccess) return <ErrorView />;

    return <MainView authProps={authProps} />;
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
