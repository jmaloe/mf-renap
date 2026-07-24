import type { IUser } from "@/interfaces/auth/IUser";
import type { ITransactInfo } from "@/interfaces/auth/ITransactInfo";

export type IAuthContext = Readonly<{
  isAuthenticated: boolean;
  isLoading: boolean;
  user: IUser | null;
  transactInfo: ITransactInfo | null;
  login: () => void;
  logout: () => void;
  token: string | undefined;
  tokenParsed: unknown;
  loginWithAcr: (acr: string) => void;
}>;
