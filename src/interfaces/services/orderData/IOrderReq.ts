export type IOrderReq = Readonly<{
  contrato: string;
  usuario: string;
  caja_rural: string;
  url: string;
  grupo: string;
}>;

/*
 "codigo_evento": "7",
    "monto": "25.00",
    "cantidad_copias": "1",
    "tipo_tarifa": "1",
    "orden_pago": "",
    "total_pagar": "25.00",
    "usuario": "226513120721",
    "caja_rural": "50201",
    "grupo": "42",
    "url": "/caja_rural/comercial/pago_servicios/CA_pago_servicios_renap_resp.asp",
    "ip": "127.0.0.1",
    "nombre_evento": "Constancia Negativa"
*/