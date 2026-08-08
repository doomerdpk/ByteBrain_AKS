import express from 'express';
import type { Express } from 'express';
import mongoose from "mongoose";
import { userRouter } from "./routes/routes.js";
import healthRouter from "./routes/health.js";
import http from "http";
import { loadConfig, getDatabaseUrl, PORT } from "./config.js";
import cors from "cors";

const app: Express = express();
const port = Number(PORT) || 3000;

app.use(express.json());
app.use(cors());
app.use("/api/v1", healthRouter);
app.use("/api/v1", userRouter);

async function startApplication() {
  try {
    await loadConfig();
    console.log("✅ Configuration loaded from Key Vault");

    await mongoose.connect(getDatabaseUrl());
    console.log("✅ Successfully connected to the Database!");

    const server = http.createServer(app);
    server.listen(port, () => {
      console.log("🚀 Server is running on port " + port);
    });

    const gracefulShutdown = async () => {
      console.log("Shutting down...");
      await mongoose.connection.close();
      console.log("✅ Database connection closed");
      server.close(() => {
        console.log("✅ Server closed");
        process.exit(0);
      });
    };

    process.on("SIGINT", gracefulShutdown);
    process.on("SIGTERM", gracefulShutdown);
  } catch (e) {
    console.error("❌ Error starting application:", e);
    process.exit(1);
  }
}

startApplication();