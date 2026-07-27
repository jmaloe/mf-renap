export type IConsultaParametroRes = Readonly<{
    consulta_parametro: {
        resultado: {
            codigo: number;
            descripcion: string;
        };
        datos?: {
            nemonico: string;
            tipo: string;
            valor: string;
        };
    };
}>;