export type IOrderRes = Readonly<{
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

/*
{
    "cobro_solicitud": {
        "resultado": {
            "codigo": 1,
            "descripcion": "OPERACION REALIZADA EXITOSAMENTE"
        },
        "datos": {
            "secuencial": "93741191",
            "secuencial_comision": "93741196",
            "referencia": "93741192",
            "boleta_pago": "37950020996",
            "recibo": "5004869",
            "fecha": "20260618",
            "linea_1": "Forma 63-A2 Electronico del 24,000,001 al 29,000,000 Serie BR1 autorizada segun resolucion",
            "linea_2": " JMADRIZ./002762 Gestion: 300119 de Fecha 26-10-2018 Correl. de Fecha 7-10-2019 E.Fiscal 4",
            "linea_3": "-A1-CCC 16251 de Fecha 7-10-2019.LIBRO  AB2.FOLIO 314, RENAP NIT 5246905-0"
        }
    }
}
*/