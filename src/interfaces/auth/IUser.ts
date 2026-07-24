import type { IUserProfile } from "@/interfaces/auth/IUserProfile";
import type { IPrintType } from "@/interfaces/auth/IPrintType";

export interface IUser {
  id: string;
  name: string;
  username: string;
  email: string;
  roles: string[];
  profile?: IUserProfile;
  printType?: IPrintType;
}
