//https://nitro.unjs.io/config
export default defineNitroConfig({
  preset: "bun",
  srcDir: "server",
  errorHandler: "~/error-handler",
  routeRules: {
    '/api/**': { cors: true, headers: { 'access-control-allow-methods': '*' } },
  }
});
