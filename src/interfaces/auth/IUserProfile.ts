import type { IRoleData } from "@/interfaces/auth/IRoleData";
import type { IDepartmentData } from "@/interfaces/auth/IDepartmentData";

export interface IUserProfile {
  cuenta: string;
  oficina: string;
  nombre: string;
  descripcion: string;
  rol: string;
  id: string;
  rest: string;
  renap: string;
  latitud: string;
  longitud: string;
  rolData?: IRoleData;
  departmentData?: IDepartmentData;
}
