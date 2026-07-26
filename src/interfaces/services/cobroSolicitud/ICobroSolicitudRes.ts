export type ICobroSolicitudRes = Readonly<{
  cobro_solicitud: {
    resultado: {
      codigo: string;
      descripcion: string;
    };
    datos?: {
      secuencial: string;
      secuencial_comision: string;
      referencia: string;
      boleta_pago: string;
      recibo: string;
      fecha: string;
      linea_1: string;
      linea_2: string;
      linea_3: string;
      dateTime: string;
    };
  };
}>;