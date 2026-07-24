import {
  getFormatBaseUrl,
  getFormatEndpoint,
  isAbsoluteUrl,
} from "@/utils/formats/formatUrl";
import loadEnvConfig from "@/utils/bootstrap/loadEnvConfig";

export abstract class BaseHttpClient {
  protected async buildUrl(endpoint: string): Promise<string> {
    const config = await loadEnvConfig();
    const apiBase = getFormatBaseUrl(config?.apiBaseUrl?.trim() || "/api");
    const path = getFormatEndpoint(endpoint);
    return isAbsoluteUrl(endpoint) ? endpoint : `${apiBase}${path}`;
  }

  protected async execute(
    endpoint: string,
    init: RequestInit,
  ): Promise<Response> {
    const url = await this.buildUrl(endpoint);
    let response = await fetch(url, init);

    if (dpopNonceRetry(response)) {
      response = await fetch(url, init);
    }

    if (!response.ok) {
      const error = await response.text();
      throw new Error(error || `Error ${response.status}`);
    }

    return response;
  }
}

export const dpopNonceRetry = (response: Response): boolean => {
  if (response.status !== 401) return false;
  const wwwAuth = response.headers.get("www-authenticate");
  if (
    wwwAuth?.toLowerCase().includes("dpop") &&
    wwwAuth.toLowerCase().includes('error="use_dpop_nonce"')
  )
    return true;
  return response.headers.has("dpop-nonce");
};
