export type IConsultaParametroRes = Readonly<{
    consulta_parametro: {
        resultado: {
            codigo: string;
            descripcion: string;
        };
        datos?: {
            nemonico: string;
            tipo: string;
            valor: string;
        };
    };
}>;