export type IPaymentReq = Readonly<{
  contrato: string;
  usuario: string;
  caja_rural: string;
  factura: string;
  url: string;
  grupo: string;
  valor: string;
}>;
