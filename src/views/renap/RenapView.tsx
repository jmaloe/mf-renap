import { useTranslation } from "react-i18next";
import { useEffect, useRef, useState, type JSX } from "react";

import type { IAuthContext } from "@/interfaces/auth/IAuthContext";
import type { INavigation } from "@/interfaces/components/navigation/INavigation";
import PreviewView from "@/views/renap/modules/PreviewView";
import OrderView from "@/views/renap/modules/OrderView";
import ReceiptView from "@/views/renap/modules/ReceiptView";
import type { IReceiptData } from "@/interfaces/components/receipt/IReceiptData";
import getReprintData from "@/services/getReprintData";
import MainLoader from "@/components/loader/MainLoader";
import ErrorReprintView from "@/views/pages/reprint/ErrorReprintView";
import { setCurrentScreen } from "@/utils/bootstrap/buildComponentId";
import { setIsReprint } from "@/utils/bootstrap/buildReprint";
import type { ICobroSolicitudRes } from "@/interfaces/services/cobroSolicitud/ICobroSolicitudRes";

type IAuthProps = Readonly<{
  authProps: IAuthContext;
}>;

const RenapView = ({ authProps }: IAuthProps) => {
  const { t } = useTranslation();
  const [isLoading, setIsLoading] = useState(true);
  const [page, setPage] = useState<INavigation>("order");
  const [errorMsg, setErrorMsg] = useState("");
  const [orderData, setOrderData] = useState<ICobroSolicitudRes>();
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
      setOrderData(undefined);
      setReceiptData(undefined);
    }
    setPage(item);
  };
  const submitOrderData = (data: ICobroSolicitudRes) => setOrderData(data);
  const submitReceiptData = (data: IReceiptData) => setReceiptData(data);

  const views: Record<INavigation, JSX.Element | null> = {
    error: <ErrorReprintView authContext={authProps} message={errorMsg} />,
    order: (
      <OrderView
        authContext={authProps}
        onSubmitOrderData={submitOrderData}
        onSelectPage={selectPage}
      />
    ),    
    preview: orderData ? (
      <PreviewView
        authContext={authProps}
        client={orderData}
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

  const currentPage: INavigation = views[page] ? page : "order";
  setCurrentScreen(currentPage);
  return views[currentPage];
};

export default RenapView;
