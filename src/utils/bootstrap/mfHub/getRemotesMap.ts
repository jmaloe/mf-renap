import type { IMfHubRemote } from "@/interfaces/components/mfHub/IMfHubRemote";
import type { IMfHubRuntime } from "@/interfaces/components/mfHub/IMfHubRuntime";
import loadEnvConfig from "@/utils/bootstrap/loadEnvConfig";
import {
  getFormatBaseUrl,
  getFormatEndpoint,
  isAbsoluteUrl,
} from "@/utils/formats/formatUrl";

let mfHubRuntimeMapCache: Promise<IMfHubRuntime> | null = null;

export const getMFRuntimeRemotesMap = async (): Promise<IMfHubRuntime> => {
  if (!mfHubRuntimeMapCache) {
    const config = await loadEnvConfig();
    const origin = globalThis.location.origin;
    const hostUrl = getFormatBaseUrl(origin);
    const runtimePath = getFormatEndpoint(config?.hostJsons?.runtime ?? "");
    const url = isAbsoluteUrl(runtimePath)
      ? runtimePath
      : `${hostUrl}${runtimePath}`;
    mfHubRuntimeMapCache = fetch(url)
      .then(async (response) => {
        if (!response.ok) {
          throw new Error(`Error cargando mf-config: ${response.status}`);
        }
        return response.json() as Promise<IMfHubRuntime>;
      })
      .catch((error) => {
        mfHubRemotesMapCache = null;
        throw error;
      });
  }
  return mfHubRuntimeMapCache;
};

let mfHubRemotesMapCache: Promise<Record<string, IMfHubRemote>> | null = null;

export const getMfHubRemotesMap = async (): Promise<
  Record<string, IMfHubRemote>
> => {
  if (!mfHubRemotesMapCache) {
    const config = await loadEnvConfig();
    const origin = globalThis.location.origin;
    const hostUrl = getFormatBaseUrl(origin);
    const remotePath = getFormatEndpoint(config?.hostJsons?.remotes ?? "");
    const url = isAbsoluteUrl(remotePath)
      ? remotePath
      : `${hostUrl}${remotePath}`;
    mfHubRemotesMapCache = fetch(url)
      .then(async (response) => {
        if (!response.ok) {
          throw new Error(`Error cargando mf-hub-remotes: ${response.status}`);
        }
        return response.json() as Promise<Record<string, IMfHubRemote>>;
      })
      .catch((error) => {
        mfHubRemotesMapCache = null;
        throw error;
      });
  }
  return mfHubRemotesMapCache;
};
