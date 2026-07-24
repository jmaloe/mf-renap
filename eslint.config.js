import js from "@eslint/js";
import tseslint from "typescript-eslint";
import react from "eslint-plugin-react";
import reactHooks from "eslint-plugin-react-hooks";
import reactRefresh from "eslint-plugin-react-refresh";
import boundaries from "eslint-plugin-boundaries";
import importPlugin from "eslint-plugin-import";
import checkFile from "eslint-plugin-check-file";
import globals from "globals";

export default [
  js.configs.recommended,
  ...tseslint.configs.recommended,
  {
    ignores: ["dist", "src/components/ui/**", "src/lib/**"],
  },
  {
    files: ["**/*.tsx"],
    rules: {
      // Reglas de nombrado
      "@typescript-eslint/naming-convention": [
        "error",
        // Variables y funciones normales
        {
          selector: ["variableLike", "function"],
          format: ["camelCase"],
        },
        // Componentes React (exportados)
        {
          selector: ["variable", "function"],
          modifiers: ["exported"],
          format: ["PascalCase"],
        },
        // Interfaces I + PascalCase
        {
          selector: "interface",
          format: ["PascalCase"],
          custom: {
            regex: "^I[A-Z]",
            match: true,
          },
        },
        // Types
        {
          selector: "typeAlias",
          format: ["PascalCase"],
        },
      ],
    },
  },
  {
    files: ["**/*.ts"],
    rules: {
      // Reglas de nombrado
      "@typescript-eslint/naming-convention": [
        "error",
        // Variables y funciones normales
        {
          selector: ["variableLike", "function"],
          format: ["camelCase"],
        },
        // Interfaces I + PascalCase
        {
          selector: "interface",
          format: ["PascalCase"],
          custom: {
            regex: "^I[A-Z]",
            match: true,
          },
        },
        // Types
        {
          selector: "typeAlias",
          format: ["PascalCase"],
        },
      ],
    },
  },
  {
    files: ["**/*.ts", "**/*.tsx"],
    languageOptions: {
      globals: {
        ...globals.browser,
      },
      parserOptions: {
        project: ["./tsconfig.app.json", "./tsconfig.node.json"],
        tsconfigRootDir: import.meta.dirname,
      },
    },
    plugins: {
      react,
      "react-hooks": reactHooks,
      "react-refresh": reactRefresh,
      "check-file": checkFile,
      boundaries,
      import: importPlugin,
    },
    settings: {
      react: {
        version: "detect",
      },
      "import/resolver": {
        typescript: {
          alwaysTryTypes: true,
          project: ["./tsconfig.app.json", "./tsconfig.node.json"],
          noWarnOnMultipleProjects: true,
        },
        node: {
          extensions: [".js", ".jsx", ".ts", ".tsx"],
        },
      },
      "boundaries/elements": [
        { type: "views", pattern: "src/views/*" },
        { type: "components", pattern: "src/components/*" },
        { type: "services", pattern: "src/services/*" },
        { type: "interfaces", pattern: "src/interfaces/*" },
      ],
    },
    rules: {
      // Reglas de React
      "react/jsx-pascal-case": ["error"],
      "react/react-in-jsx-scope": "off",
      "react-hooks/rules-of-hooks": ["error"],
      "react-hooks/exhaustive-deps": ["warn"],
      "react-refresh/only-export-components": ["warn"],
      // Reglas de imports
      "import/no-unresolved": ["error"],
      "import/no-relative-parent-imports": "off",
      "import/no-cycle": ["error"],
      "import/order": [
        "error",
        {
          groups: [
            "builtin",
            "external",
            "internal",
            "parent",
            "sibling",
            "index",
          ],
          "newlines-between": "always",
        },
      ],
      // Reglas de arquitectura por capas
      "boundaries/dependencies": [
        "error",
        {
          default: "disallow",
          rules: [
            {
              from: { type: "interfaces" },
              allow: {
                to: { type: ["interfaces"] },
              },
            },
            {
              from: { type: "services" },
              allow: {
                to: { type: ["interfaces", "services"] },
              },
            },
            {
              from: { type: "components" },
              allow: {
                to: { type: ["interfaces", "services", "components"] },
              },
            },
            {
              from: { type: "views" },
              allow: {
                to: { type: ["interfaces", "services", "components", "views"] },
              },
            },
          ],
        },
      ],
      "check-file/filename-naming-convention": [
        "error",
        {
          "**/*.{png,jpg,jpeg,gif,svg,webp,avif}": "SNAKE_CASE",
        },
      ],
      // Buenas prácticas
      "no-param-reassign": ["error"],
      "no-console": [
        "warn",
        {
          allow: ["warn", "error"],
        },
      ],
      "@typescript-eslint/no-unused-vars": ["error"],
    },
  },
  {
    files: ["vite.config.ts"],
    languageOptions: {
      globals: {
        ...globals.node,
      },
    },
  },
  {
    files: ["postcss.config.js"],
    languageOptions: {
      globals: {
        process: "readonly",
      },
    },
  },
];
