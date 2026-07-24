import type { IMfHubInfo } from "@/interfaces/components/mfHub/IMfHubInfo";
import {
  getMfHubRemotesMap,
  getMFRuntimeRemotesMap,
} from "@/utils/bootstrap/mfHub/getRemotesMap";
import {
  getFormatBaseUrl,
  getFormatEndpoint,
  isAbsoluteUrl,
} from "@/utils/formats/formatUrl";
import loadEnvConfig from "@/utils/bootstrap/loadEnvConfig";

let transactionPromise: Promise<IMfHubInfo> | null = null;

const fetchMFConfig = async (): Promise<IMfHubInfo> => {
  const config = await loadEnvConfig();
  const transactionCode = config?.transactionCode ?? "";
  const runtimeMap = await getMFRuntimeRemotesMap();
  const remotes = Object.values(runtimeMap.remotes);

  const parentMatch = remotes.find(
    (remote) => remote.transactionCode === transactionCode,
  );

  const childMatch = remotes
    .flatMap((remote) =>
      (remote.children ?? []).map((child) => ({
        remote,
        child,
      })),
    )
    .find(({ child }) => child.transactionCode === transactionCode);

  const transactionRuntime = childMatch?.child ?? parentMatch;

  let transactionUrl: string = (transactionRuntime?.url ?? "").trim();
  let modulePath: string = (transactionRuntime?.modulePath ?? "./mount").trim();
  let iconUrl: string = (
    transactionRuntime?.iconUrl ??
    childMatch?.remote?.iconUrl ??
    ""
  ).trim();

  if (!transactionUrl) {
    const remotesMap = await getMfHubRemotesMap();
    const transactionRemotes = Object.values(remotesMap).find(
      (value) => value.transactionCode === transactionCode,
    );
    transactionUrl = (
      transactionRemotes?.remoteEntryUrl ?? transactionUrl
    ).trim();
    modulePath = (transactionRemotes?.modulePath ?? modulePath).trim();
    iconUrl = (transactionRemotes?.iconUrl ?? iconUrl).trim();
  }

  if (transactionUrl) {
    const origin = globalThis.location.origin;
    const path = getFormatEndpoint(transactionUrl);
    transactionUrl = isAbsoluteUrl(transactionUrl)
      ? transactionUrl.trim()
      : `${origin}${path}`;
  }

  if (iconUrl) {
    const cdnPath = getFormatBaseUrl(import.meta.env.VITE_CDN_URL ?? "");
    const iconPath = getFormatEndpoint(iconUrl);
    iconUrl = isAbsoluteUrl(iconUrl) ? iconUrl.trim() : `${cdnPath}${iconPath}`;
  }

  const transaction: IMfHubInfo = {
    transactionUrl,
    modulePath,
    iconUrl,
  };

  return transaction;
};

const loadMFConfig = (): Promise<IMfHubInfo> => {
  transactionPromise ??= fetchMFConfig().catch((e) => {
    transactionPromise = null;
    throw e;
  });
  return transactionPromise;
};

export default loadMFConfig;
