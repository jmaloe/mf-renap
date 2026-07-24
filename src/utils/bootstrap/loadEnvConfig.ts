import type { IEnv } from "@/interfaces/components/env/IEnv";
import { getFormatEndpoint } from "@/utils/formats/formatUrl";

let envConfigPromise: Promise<IEnv> | null = null;

const fetchEnvConfig = async (): Promise<IEnv> => {
  const origin = globalThis.location.origin;
  const baseName = import.meta.env.VITE_BASE_NAME ?? "mf-root";
  const basePath = getFormatEndpoint(baseName);

  const response = await fetch(`${origin}${basePath}/config/env-config.json`);
  if (!response.ok) {
    throw new Error(`Error cargando config: ${response.status}`);
  }

  const config: IEnv = await response.json();
  return config;
};

const loadEnvConfig = (): Promise<IEnv> => {
  envConfigPromise ??= fetchEnvConfig().catch((e) => {
    envConfigPromise = null;
    throw e;
  });
  return envConfigPromise;
};

export default loadEnvConfig;
