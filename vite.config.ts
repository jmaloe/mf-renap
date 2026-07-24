import path from "node:path";
import type { IncomingMessage } from "node:http";

import { defineConfig, loadEnv } from "vite";
import react from "@vitejs/plugin-react";
import tailwindcss from "@tailwindcss/vite";
import federation from "@originjs/vite-plugin-federation";
import checker from "vite-plugin-checker";

import {
  getFormatBaseUrl,
  getFormatEndpoint,
} from "./src/utils/formats/formatUrl";

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), "");
  const baseName = env.VITE_BASE_NAME ?? "mf-root";
  const basePath = getFormatEndpoint(baseName);
  const port = Number(env.VITE_PORT) || 5173;

  const hostBaseUrl = getFormatBaseUrl(env.VITE_HOST_URL ?? "");
  const hostEndpoint = getFormatEndpoint(env.VITE_HOST_PATH ?? "");
  const proxy =
    hostBaseUrl && hostEndpoint
      ? {
          [hostEndpoint]: {
            target: hostBaseUrl,
            changeOrigin: true,
            secure: false,
            bypass(req: IncomingMessage) {
              if (req.url?.startsWith(basePath)) {
                return req.url;
              }
            },
          },
        }
      : undefined;

  return {
    base: basePath,
    plugins: [
      react(),
      tailwindcss(),
      checker({
        typescript: true,
        eslint: {
          lintCommand: 'eslint "./src/**/*.{ts,tsx}"',
        },
        overlay: false,
      }),
      federation({
        name: baseName,
        filename: "remoteEntry.js",
        exposes: {
          "./mount": "./src/mount.tsx",
        },
      }),
    ],
    esbuild: {
      pure: ["console.log"],
    },
    resolve: {
      alias: { "@": path.resolve(__dirname, "./src") },
    },
    build: {
      target: "esnext",
      modulePreload: false,
      cssCodeSplit: false,
    },
    server: {
      port,
      strictPort: true,
      cors: true,
      headers: {
        "Access-Control-Allow-Origin": "*",
      },
      proxy,
    },
    preview: {
      port,
      strictPort: true,
      cors: true,
      headers: { "Access-Control-Allow-Origin": "*" },
    },
  };
});
