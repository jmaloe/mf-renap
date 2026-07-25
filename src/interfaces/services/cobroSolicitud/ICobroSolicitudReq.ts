export type ICobroSolicitudReq = Readonly<{
  codigo_evento: string;
  monto: string;
  cantidad_copias: string;
  tipo_tarifa: string;
  orden_pago: string;
  total_pagar: string;
  usuario: string;
  caja_rural: string;
  grupo: string;
  url: string;
  ip: string;
  nombre_evento: string;
}>;