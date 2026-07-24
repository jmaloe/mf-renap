export type IDetailTransactionReq = Readonly<{
  operacion: string;
  usuario: string;
  secuencial: string;
  fecha: string;
  noRemesa: string;
  oficina: string;
}>;
