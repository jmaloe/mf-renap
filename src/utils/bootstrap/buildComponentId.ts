import type { INavigation } from "@/interfaces/components/navigation/INavigation";
import { toCapitalizeFirst } from "@/utils/formats/formatString";

let currentScreen: INavigation = "home";

export const setCurrentScreen = (screen: INavigation): void => {
  currentScreen = screen;
};

const getTransaction = (): string => {
  const baseName: string = import.meta.env.VITE_BASE_ID ?? "root";
  return baseName
    .replace(/[^a-zA-Z0-9-]/g, "")
    .split("-")
    .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
    .join("");
};

export const buildComponentId = (type: string, name: string): string => {
  const newType = type.toLowerCase();
  const newName = toCapitalizeFirst(name);
  const transaction = getTransaction();
  const screen = toCapitalizeFirst(currentScreen);

  return `${newType}${screen}${newName}${transaction}`;
};
