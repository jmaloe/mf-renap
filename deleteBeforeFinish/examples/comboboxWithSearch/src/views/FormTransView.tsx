import { useEffect, useState } from "react";
import { useTranslation } from "react-i18next";

import type { IAuthContext } from "@/interfaces/auth/IAuthContext";
import getOperations from "@/services/getOperations";
import { FieldGroup } from "@/components/ui/field";
import TransmitButton from "@/components/buttons/TransmitButton";
import type { IComboBox } from "@/interfaces/components/fields/IComboBox";
import ComboBoxField from "@/components/fields/ComboBoxField";
import { useRequest } from "@/utils/http/useRequest";
import type { IOperationData } from "@/interfaces/services/operation/IOperationData";
import getReceipts from "@/services/getReceipts";
import type { IReceiptData } from "@/interfaces/services/receipt/IReceiptData";
import WarningModal from "@/components/modals/WarningModal";
import type { IModalData } from "@/interfaces/components/modal/IModalData";
import MainCard from "@/components/cards/MainCard";
import MainGroupButton from "@/components/buttons/MainGroupButton";
import type { IComboBoxData } from "@/interfaces/components/fields/IComboBoxData";
import { buildComponentId } from "@/utils/bootstrap/buildComponentId";

type IProps = Readonly<{
  setOperationCode: (operation: IComboBox) => void;
  setTransactionData: (data: IReceiptData[]) => void;
  authContext?: IAuthContext | null;
}>;

const FormTransView = ({
  setOperationCode,
  setTransactionData,
  authContext,
}: IProps) => {
  const { t } = useTranslation();
  const { loading, execute } = useRequest<IOperationData>();
  const { loading: loadingSubmit, execute: executeSubmit } =
    useRequest<IReceiptData[]>();
  const [onChangeModal, setOnChangeModal] = useState(false);
  const [modalData, setModalData] = useState<IModalData>();
  const username = authContext?.user?.username ?? "";

  const [operationData, setOperationData] = useState<IComboBox[]>([]);
  const [operation, setOperation] = useState<IComboBox | null>(null);
  const [operationError, setOperationError] = useState("");

  useEffect(() => {
    const loadData = async () => {
      // Carga de los datos del comboBox
      const { data, error } = await execute(() =>
        getOperations(t, authContext),
      );
      if (!data) {
        console.error(error || t("msg.descriptions.default", { ns: "error" }));
        return;
      }
      setOperationData(data.operations);
    };

    loadData();
  }, [authContext, execute, t, username]);

  const operationValid =
    operation !== null &&
    operationData.some(
      (item) => item.value.toLowerCase() === operation.value.toLowerCase(),
    );

  const onSubmit = async () => {
    if (hasErrors) {
      setOperationError(t("field.operation.noData", { ns: "error" }));
      return;
    }

    const { data, error } = await executeSubmit(() =>
      // Consumo de servicio cualquiera
      getReceipts(operation.value, t, authContext),
    );
    if (!data) {
      setModalData({
        title: t("msg.titles.invalidData", { ns: "error" }),
        description: error || t("msg.descriptions.default", { ns: "error" }),
      });
      setOnChangeModal(true);
      return;
    }

    setOperationCode(operation);
    setTransactionData(data);
  };

  const dataField: IComboBoxData[] = [
    {
      id: "operation",
      label: t("fields.operation.label"),
      items: operationData,
      value: operation,
      error: operationError,
      onChange: setOperation,
    },
  ];

  return (
    <MainCard
      loading={loading || loadingSubmit}
      className="p-6 w-full sm:w-lg overflow-visible"
    >
      <form
        id={buildComponentId("form", "Transactions")}
        className="flex flex-col gap-6"
        autoComplete="off"
        onSubmit={onSubmit}
      >
        <FieldGroup>
          {dataField.map((field) => (
            <ComboBoxField
              key={field.id}
              id={field.id}
              label={field.label}
              items={field.items}
              value={field.value}
              error={field.error}
              onChange={field.onChange}
              loading={loading}
              required
            />
          ))}
        </FieldGroup>
        <MainGroupButton>
          <TransmitButton
            onClick={onSubmit}
            loading={loading}
            disabled={!operationValid}
          />
        </MainGroupButton>
      </form>
      <WarningModal
        title={modalData?.title}
        description={modalData?.description}
        onChangeModal={onChangeModal}
        setOnChangeModal={setOnChangeModal}
      />
    </MainCard>
  );
};

export default FormTransView;
