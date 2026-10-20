const { defineConfig } = require("vite");

// Le token Pinata reste côté serveur : Vite relaie uniquement /api vers le service local.
module.exports = defineConfig({
  server: { proxy: { "/api": "http://127.0.0.1:8787" } }
});
