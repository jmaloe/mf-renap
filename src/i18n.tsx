import i18next, { type i18n as I18nInstance } from "i18next";
import Backend from "i18next-http-backend";
import LanguageDetector from "i18next-browser-languagedetector";
import { initReactI18next } from "react-i18next";

import layoutEs from "@/lang/es/layout.json";
import errorsEs from "@/lang/es/errors.json";
import { getFormatBaseUrl } from "@/utils/formats/formatUrl";
import baseUrlFromImportMeta from "@/utils/bootstrap/baseUrlFromImportMeta";

export const CreateMfI18n = (): I18nInstance => {
  const instance = i18next.createInstance();

  const baseUrl = getFormatBaseUrl(baseUrlFromImportMeta());

  instance
    .use(Backend)
    .use(LanguageDetector)
    .use(initReactI18next)
    .init({
      resources: {
        es: {
          layout: layoutEs,
          error: errorsEs,
        },
      },
      showSupportNotice: false,
      lng: "es",
      fallbackLng: "es",
      ns: ["layout", "error"],
      defaultNS: "layout",
      interpolation: {
        escapeValue: false,
      },
      detection: {
        order: ["localStorage", "navigator", "htmlTag"],
        lookupLocalStorage: "i18nextLng",
        caches: ["localStorage"],
      },
      backend: {
        loadPath: `${baseUrl}/locales/{{lng}}/{{ns}}.json`,
        withCredentials: false,
      },
      react: {
        useSuspense: false,
      },
    });

  return instance;
};

export const MfI18n = CreateMfI18n();
