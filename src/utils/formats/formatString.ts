export const getCleanString = (text?: string): string => {
  if (!text) return "";

  return decodeHtmlEntities(
    text
      .replaceAll(/\s+/g, " ")
      .replaceAll(/[()'"?*]+/g, "")
      .normalize("NFD")
      .replaceAll(/[\u0300-\u036f]/g, "")
      .toLowerCase()
      .trim(),
  );
};

export const toSentenceCase = (text?: string): string => {
  if (!text) return "";

  return text
    .toLowerCase()
    .replaceAll(/(^\s*\p{L}|[.!?]\s*\p{L})/gu, (match) => match.toUpperCase());
};

export const toCapitalizeFirst = (text?: string): string => {
  if (!text) return "";

  return text
    .split(" ")
    .map((word) => (word ? word.charAt(0).toUpperCase() + word.slice(1) : ""))
    .join(" ")
    .trim();
};

export const decodeHtmlEntities = (text?: string): string => {
  if (!text) return "";

  if (typeof document === "undefined") {
    return text
      .replace(/&iacute;/gi, "í")
      .replace(/&eacute;/gi, "é")
      .replace(/&oacute;/gi, "ó")
      .replace(/&aacute;/gi, "á")
      .replace(/&uacute;/gi, "ú")
      .replace(/&ntilde;/gi, "ñ")
      .replace(/&lt;/gi, "<")
      .replace(/&gt;/gi, ">")
      .replace(/&amp;/gi, "&");
  }

  const textarea = document.createElement("textarea");
  textarea.innerHTML = text;

  return textarea.value;
};
