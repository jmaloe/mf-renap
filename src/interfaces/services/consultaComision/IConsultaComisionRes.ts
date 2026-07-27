export type IConsultaComisionRes = Readonly<{
    consulta_comision: {
        resultado: {
            codigo: number;
            descripcion: string;
        };
        datos?: {
            parametro: string;
            char: string;
            tinyint: string | null;
            smallint: string | null;
            int: string | null;
            money: number | null;
            datetime: string | null;
            float: string | null;
        };
    };
}>;