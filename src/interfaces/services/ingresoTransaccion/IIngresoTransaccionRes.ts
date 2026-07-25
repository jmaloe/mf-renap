export type IIngresoTransaccionRes = Readonly<{
    ingreso_transaccion: {
        resultado: {
            codigo: number;
            descripcion: string;
        };
    };
}>;