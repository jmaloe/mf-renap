export type IRowFieldUser = Readonly<{
  key: string;
  label: string;
  value: string;
  align: "left" | "right";
}>;

export type IFieldUser = Readonly<[IRowFieldUser, IRowFieldUser]>;
