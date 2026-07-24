export type IPaymentRes = Readonly<{
  pago: {
    resultado: {
      codigo: string;
      descripcion: string;
    };
    datos?: {
      referencia: string;
    };
  };
}>;
