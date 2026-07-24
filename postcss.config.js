import dotenv from "dotenv";

dotenv.config();
const baseName = process.env.VITE_BASE_NAME || "mf-root";

export default {
  plugins: {
    "@tailwindcss/postcss": {},
    "postcss-prefix-selector": {
      prefix: `#${baseName}`,
      exclude: ["html", "body", ":root"],
      transform: function (_prefix, selector, prefixedSelector) {
        if (selector === ":root") return selector;
        return prefixedSelector;
      },
    },
  },
};
