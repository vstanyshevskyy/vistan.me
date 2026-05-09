import js from "@eslint/js";
import { FlatCompat } from "@eslint/eslintrc";
import astro from "eslint-plugin-astro";
import eslintConfigPrettier from "eslint-config-prettier";

const compat = new FlatCompat({
  baseDirectory: import.meta.dirname,
});

export default [
  js.configs.recommended,
  ...astro.configs["flat/recommended"],
  {
    ignores: ["dist/", ".astro/", ".netlify/", "node_modules/"],
  },
  ...compat.extends("airbnb-base").map((config) => ({
    ...config,
    files: ["**/*.{js,mjs,cjs}"],
  })),
  {
    files: ["**/*.{js,mjs,cjs}"],
    languageOptions: {
      ecmaVersion: "latest",
      sourceType: "module",
    },
  },
  {
    files: ["astro.config.mjs", "eslint.config.js", "tailwind.config.mjs"],
    rules: {
      "import/no-extraneous-dependencies": "off",
      "import/no-unresolved": "off",
    },
  },
  {
    files: ["**/*.astro"],
    rules: {
      "import/no-unresolved": "off",
      "import/extensions": "off",
    },
  },
  eslintConfigPrettier,
];
