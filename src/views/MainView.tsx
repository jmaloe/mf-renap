import { useTranslation } from "react-i18next";
import { useEffect, useRef, useState, type JSX } from "react";

import type { IAuthContext } from "@/interfaces/auth/IAuthContext";
import ClientView from "@/views/pages/ClientView";
import type { INavigation } from "@/interfaces/components/navigation/INavigation";
import PreviewView from "@/views/pages/PreviewView";
import type { IClientData } from "@/interfaces/services/clientData/IClientData";
import HomeView from "@/views/pages/HomeView";
import ReceiptView from "@/views/pages/ReceiptView";
import type { IReceiptData } from "@/interfaces/components/receipt/IReceiptData";
import getReprintData from "@/services/getReprintData";
import MainLoader from "@/components/loader/MainLoader";
import ErrorReprintView from "@/views/pages/reprint/ErrorReprintView";
import { setCurrentScreen } from "@/utils/bootstrap/buildComponentId";
import { setIsReprint } from "@/utils/bootstrap/buildReprint";

type IAuthProps = Readonly<{
  authProps: IAuthContext;
}>;

const MainView = ({ authProps }: IAuthProps) => {
  const { t } = useTranslation();
  const [isLoading, setIsLoading] = useState(true);
  const [page, setPage] = useState<INavigation>("home");
  const [errorMsg, setErrorMsg] = useState("");
  const [clientData, setClientData] = useState<IClientData>();
  const [receiptData, setReceiptData] = useState<IReceiptData>();
  const hasLoadedRef = useRef(false);

  useEffect(() => {
    if (page) {
      window.scrollTo(0, 0);
    }
  }, [page]);

  useEffect(() => {
    if (hasLoadedRef.current) return;
    hasLoadedRef.current = true;

    const loadReprintData = async () => {
      try {
        if (authProps?.transactInfo) {
          const data = await getReprintData(t, authProps);
          if (typeof data === "string") {
            setErrorMsg(data);
            setPage("error");
          } else {
            setReceiptData(data);
            setIsReprint();
            setPage("receipt");
          }
        }
      } finally {
        setIsLoading(false);
      }
    };
    loadReprintData();
  }, [authProps, t]);

  if (isLoading) {
    return <MainLoader />;
  }

  const selectPage = (item: INavigation) => {
    if (!item) {
      setClientData(undefined);
      setReceiptData(undefined);
    }
    setPage(item);
  };
  const submitClientData = (data: IClientData) => setClientData(data);
  const submitReceiptData = (data: IReceiptData) => setReceiptData(data);

  const views: Record<INavigation, JSX.Element | null> = {
    error: <ErrorReprintView authContext={authProps} message={errorMsg} />,
    home: (
      <HomeView
        authContext={authProps}
        onSubmitClientData={submitClientData}
        onSelectPage={selectPage}
      />
    ),
    client: clientData ? (
      <ClientView client={clientData} onSelectPage={selectPage} />
    ) : null,
    preview: clientData ? (
      <PreviewView
        authContext={authProps}
        client={clientData}
        onSubmitReceiptData={submitReceiptData}
        onSelectPage={selectPage}
      />
    ) : null,
    receipt: receiptData ? (
      <ReceiptView
        authContext={authProps}
        receipt={receiptData}
        onSelectPage={selectPage}
      />
    ) : null,
  };

  const currentPage: INavigation = views[page] ? page : "home";
  setCurrentScreen(currentPage);
  return views[currentPage];
};

export default MainView;
