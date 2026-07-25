import type { ITarifarioItems } from "./ITarifarioItems";
export type ITarifarioRes = Readonly<{
    Clta_Tarifario: {
        resultado: {
            codigo: string;
            descripcion: string;
        };
        datos?: [ITarifarioItems];
    };
}>;