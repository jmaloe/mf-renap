import type { IAuthContext } from "@/interfaces/auth/IAuthContext";

export const mockAuthProps: IAuthContext = {
  isAuthenticated: true,
  isLoading: false,
  user: {
    id: "2ef4bd18-bf43-427a-8e86-d75aa123ed76",
    name: "User BanruralTest",
    username: "226513100721",
    email: "test@test.com",
    roles: [
      "default-roles-br-cajabr-realm",
      "offline_access",
      "uma_authorization"
    ],
    profile: {
      cuenta: "3268040966",
      oficina: "50201",
      nombre: "PRUEBA 3",
      descripcion: "JESUS M. E.",
      rol: "55",
      id: "42",
      rest: "1",
      renap: "",
      latitud: "0.0",
      longitud: "0.0",
      rolData: {
        descripcionRol: "Administrador"
      },
      departmentData: {
        departamento: "Guatemala",
        municipio: "Fraijanes"
      }
    },
    printType: {
      codigo: "0",
      descripcion: "Hibrida"
    }
  },
  transactInfo: null,
  login: (() => (true)),
  logout: (() => (true)),
  token: import.meta.env.VITE_APIGATEWAY_TOKEN ?? "mf-root",
  tokenParsed: 'ABCDEFGHIJKLMNOPQRSTUVWX',
  loginWithAcr: (() => (true))
};
