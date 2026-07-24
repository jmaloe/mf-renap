export interface ITransactInfo {
  horaTransaccion: string;
  fechaTransaccion: string;
  nombreTransaccion: string;
  monto: string;
  codigoTransaccion: string;
  secuencial: string;
  cuenta: string;
  estado: string | null;
  onClose?: () => void;
}
