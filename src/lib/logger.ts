import "server-only";

import pino, { type Bindings, type Logger } from "pino";

const isDevelopment = process.env.NODE_ENV === "development";

const logger = pino({
  base: {
    env: process.env.NODE_ENV,
    service: process.env.LOG_SERVICE_NAME ?? "frontend",
  },
  formatters: {
    level(label) {
      return { level: label };
    },
  },
  level: process.env.LOG_LEVEL ?? (isDevelopment ? "debug" : "info"),
  redact: {
    censor: "[Redacted]",
    paths: [
      "authorization",
      "cookie",
      "headers.authorization",
      "headers.cookie",
      "password",
      "token",
      "secret",
      "apiKey",
      "*.authorization",
      "*.cookie",
      "*.password",
      "*.token",
      "*.secret",
      "*.apiKey",
    ],
  },
  timestamp: pino.stdTimeFunctions.isoTime,
});

export type AppLogger = Logger;

export function createLogger(bindings: Bindings): AppLogger {
  return logger.child(bindings);
}

export { logger };
