import { Appsignal } from "@appsignal/nodejs"

export default new Appsignal({
  active: true,
  name: "opentelemetry-fastify",
  logLevel: "trace",
  log: "file",
  logPath: "/tmp",
  pushApiKey: "not-a-real-api-key"
})
