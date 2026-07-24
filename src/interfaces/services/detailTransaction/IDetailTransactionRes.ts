export type IDetailTransactionRes = Readonly<{
  detalleTransacciones: {
    resultado: {
      codigo: string;
      descripcion: string;
    };
    datos?: {
      descripcion: string;
      fecha: string;
      hora: string;
      codigoTrn: string;
      valor: string;
      tipoEmpresa: string;
      cuenta: string;
      secuencial: string;
      usuario: string;
      id: string;
    };
  };
}>;
