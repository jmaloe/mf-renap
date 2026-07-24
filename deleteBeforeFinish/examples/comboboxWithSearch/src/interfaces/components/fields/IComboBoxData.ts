import type { Dispatch, SetStateAction } from "react";

import type { IComboBox } from "@/interfaces/components/fields/IComboBox";

export type IComboBoxData = Readonly<{
  id: string;
  label: string;
  items: IComboBox[];
  value: IComboBox | null;
  error: string;
  onChange: Dispatch<SetStateAction<Readonly<IComboBox> | null>>;
}>;
