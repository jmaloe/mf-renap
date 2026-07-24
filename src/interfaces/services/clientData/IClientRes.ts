export type IClientRes = Readonly<{
  consulta: {
    resultado: {
      codigo: string;
      descripcion: string;
    };
    datos?: {
      factura: string;
      fecha: string;
      nombre: string;
      saldo: string;
    };
  };
}>;
