import { useTranslation } from "react-i18next";

import TransmitButton from "@/components/buttons/TransmitButton";
import type { INavigation } from "@/interfaces/components/navigation/INavigation";
import { FieldGroup } from "@/components/ui/field";
import DisabledInput from "@/components/fields/DisabledInput";
import CancelButton from "@/components/buttons/CancelButton";
import type { IOrderData } from "@/interfaces/services/orderData/IOrderData";
import MainFormCard from "@/components/cards/MainFormCard";
import MainGroupButton from "@/components/buttons/MainGroupButton";

type IProps = Readonly<{
  client: IOrderData;
  onSelectPage: (item: INavigation) => void;
}>;

const ClientView = ({ client, onSelectPage }: IProps) => {
  const { t } = useTranslation();

  const onSubmit = () => {
    onSelectPage("preview");
  };

  const onCancel = () => {
    onSelectPage("home");
  };

  return (
    <MainFormCard className="w-full">
      <FieldGroup>
        <DisabledInput
          id="phone"
          label={t("fields.phone.label")}
          value={client.telefono}
          required
        />
        <div className="flex flex-row xs:flex-col gap-6">
          <DisabledInput
            id="invoice"
            label={t("fields.invoice.label")}
            value={client.factura}
            required
          />
          <DisabledInput
            id="date"
            label={t("fields.date.label")}
            value={client.fecha}
            required
          />
        </div>
        <DisabledInput
          id="name"
          label={t("fields.name.label")}
          value={client.nombre}
          required
        />
        <DisabledInput
          id="amount"
          label={t("fields.amount.label")}
          value={client.saldo}
          required
        />
      </FieldGroup>
      <MainGroupButton>
        <CancelButton onClick={onCancel} isCancel />
        <TransmitButton onClick={onSubmit} />
      </MainGroupButton>
    </MainFormCard>
  );
};

export default ClientView;
