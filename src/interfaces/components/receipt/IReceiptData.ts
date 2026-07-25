export type IReceiptData = Readonly<{
  payment: string;
  amount: string;
  invoice: string;
  receiptNumber: string;
  date: string;
  office: string;
  user: string;
  userName: string;
  userInitials: string;
  department: string;
  city: string;

  secuencial: string;
  secuencial_comision: string;
  referencia: string;
  boleta_pago: string;
  recibo: string;
  fecha: string;
  linea_1: string;
  linea_2: string;
  linea_3: string;
}>;
