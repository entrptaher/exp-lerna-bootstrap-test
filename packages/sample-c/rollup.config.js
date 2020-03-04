import resolve from "@rollup/plugin-node-resolve";
import commonjs from "@rollup/plugin-commonjs";
import builtins from "builtin-modules";
import { terser } from "rollup-plugin-terser";

export default {
  input: "index.js",
  output: {
    dir: "dist",
    format: "cjs"
  },
  external: [builtins, "puppeteer"],
  plugins: [resolve({ resolveOnly: [/^@test*/] }), commonjs(), terser()]
};
