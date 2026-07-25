export type ITipoTarifarioRes = Readonly<{
  Clta_TipoTarifario: {
    resultado: {
      codigo: string;
      value: string;
    };
    datos: {
      tipo_tarifario: string;
    };
  };
}>;