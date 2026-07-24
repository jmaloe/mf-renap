import { getFormatBaseUrl } from "@/utils/formats/formatUrl";

const baseUrlFromImportMeta = (moduleUrl: string = import.meta.url): string => {
  const currentUrl = new URL(moduleUrl);
  const origin = currentUrl.origin;
  const viteBaseUrl = import.meta.env.BASE_URL;

  if (viteBaseUrl) {
    return getFormatBaseUrl(new URL(viteBaseUrl, origin).toString());
  }

  const path = currentUrl.pathname;
  const assetIndex = path.lastIndexOf("/assets/");
  if (assetIndex >= 0)
    return getFormatBaseUrl(`${origin}${path.slice(0, assetIndex)}`);

  const srcIndex = path.lastIndexOf("/src/");
  if (srcIndex >= 0)
    return getFormatBaseUrl(`${origin}${path.slice(0, srcIndex)}`);

  return getFormatBaseUrl(origin);
};

export default baseUrlFromImportMeta;
