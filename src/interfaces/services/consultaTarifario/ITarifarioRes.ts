import type { ITarifarioItems } from "./ITarifarioItems";
export type ITarifarioRes = Readonly<{
    Clta_Tarifario: {
        resultado: {
            codigo: number;
            descripcion: string;
        };
        datos?: [ITarifarioItems];
    };
}>;