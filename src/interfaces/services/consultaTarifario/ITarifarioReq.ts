export type ITarifarioReq = Readonly<{
    Clta_Tarifario: {
        trn: string;
        oficina: string;
        rol: string;
        evento: string;
        tipoTarifario: string;
    };
}>;