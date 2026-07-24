import { useTranslation } from "react-i18next";

import type { IComboBox } from "@/interfaces/components/fields/IComboBox";
import type { IReceiptData } from "@/interfaces/services/receipt/IReceiptData";
import {
  remittanceOperations,
  telephoneOperations,
} from "@/utils/constants/receiptOperations";
import {
  decodeHtmlEntities,
  formatRemittance,
} from "@/utils/formats/formatString";
import { formatTime } from "@/utils/formats/formatDate";
import LinkButton from "@/components/buttons/LinkButton";
import type { ITransactInfo } from "@/interfaces/auth/ITransactInfo";
import type { IAuthContext } from "@/interfaces/auth/IAuthContext";
import type { INavigation } from "@/interfaces/components/navigation/INavigation";
import MainCard from "@/components/cards/MainCard";
import { buildComponentId } from "@/utils/bootstrap/buildComponentId";

type IProps = Readonly<{
  data: IReceiptData[];
  setTransactionData: (data: IReceiptData[]) => void;
  operation: IComboBox | null;
  setOperationCode: (operation: IComboBox) => void;
  user: IComboBox | null;
  setUserCode: (user: IComboBox) => void;
  authContext?: IAuthContext | null;
  onSelectPage: (item: INavigation) => void;
  setReprintData: (transactInfo: ITransactInfo) => void;
}>;

const TableTransView = ({
  data,
  operation,
  user,
  authContext,
}: IProps) => {
  const { t } = useTranslation();

  if (operation === null || user === null || data.length === 0) return null;

  const code = operation.value.trim();
  const isRemittance = remittanceOperations.includes(code);
  const isTelephone = telephoneOperations.includes(code);

  const onRequested = (transaction: ITransactInfo) => {
    // Aqui podemos mostrar un modal, o activar un service según nuestras necesidades
    // postExampleService(transaction);
  };

  const tableBody = data.map((receipt, index) => {
    const sequential = receipt.secuencial.trim();

    let description = receipt.descripcion.trim();
    if (isRemittance) description = formatRemittance(receipt.descripcion);
    if (isTelephone) description = receipt.cuenta;

    const date = receipt.fecha.trim().split(" ")[0];
    const time = receipt.hora.trim().split(" ")[1];
    const dateTime = formatTime(`${date} ${time}`);

    const amount = receipt.valor.trim();
    const currencyAmount = `${t("table.currencySymbol")}${amount}`;

    // Este es el titulo del boton
    let operationReceipt = t("table.operation.default");
    const transactInfo: ITransactInfo = {...};

    return (
      <tr key={sequential}>
        <td>{index + 1}</td>
        {isRemittance && <td>{receipt.cuenta.trim()}</td>}
        <td>{decodeHtmlEntities(description)}</td>
        <td>{dateTime}</td>
        <td>{currencyAmount}</td>
        <td>
          <LinkButton
            id={receipt.secuencial}
            label={operationReceipt}
            onClick={() => {
              onRequested(transactInfo);
            }}
          />
        </td>
      </tr>
    );
  });

  // Este arreglo de headers solo es de ejemplo, no es necesario que lo utilicen siempre.
  const headers = [
    t("table.headers.number"),
    ...(isRemittance ? [t("table.headers.remittance")] : []),
    t("table.headers.description"),
    t("table.headers.datetime"),
    t("table.headers.amount"),
    t("table.headers.operation"),
  ];

  return (
    <MainCard className="py-6 w-full">
      <div className="banrural-table-wrap">
        <table
          id={buildComponentId("tbl", "Transactions")}
          className="banrural-table !table-auto !text-base"
        >
          <thead>
            <tr>
              {headers.map((header) => (
                <th key={header} className="!text-center" scope="col">
                  {header}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>{tableBody}</tbody>
        </table>
      </div>
    </MainCard>
  );
};

export default TableTransView;
