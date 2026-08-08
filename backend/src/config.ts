import dotenv from "dotenv";
dotenv.config();

import { DefaultAzureCredential } from "@azure/identity";
import { SecretClient } from "@azure/keyvault-secrets";

export const saltRounds = 10;
export const PORT = 3000;

let DATABASE_URL_STR: string;
let JWT_SECRET_STR: string;

export async function loadConfig(): Promise<void> {

  if (process.env.DATABASE_URL && process.env.JWT_SECRET) {
    DATABASE_URL_STR = process.env.DATABASE_URL;
    JWT_SECRET_STR = process.env.JWT_SECRET;
    return;
  }

  const vaultUri = process.env.KEY_VAULT_URI;
  const dbSecretName = process.env.DB_CONNECTION_SECRET_NAME;
  const jwtSecretName = process.env.JWT_SECRET_SECRET_NAME;

  if (!vaultUri || !dbSecretName || !jwtSecretName) {
    throw new Error(
      "Missing required environment variables: KEY_VAULT_URI, DB_CONNECTION_SECRET_NAME, JWT_SECRET_SECRET_NAME"
    );
  }

  const credential = new DefaultAzureCredential(
    process.env.AZURE_CLIENT_ID
      ? { managedIdentityClientId: process.env.AZURE_CLIENT_ID }
      : undefined
  );
  const client = new SecretClient(vaultUri, credential);

  const [dbSecret, jwtSecret] = await Promise.all([
    client.getSecret(dbSecretName),
    client.getSecret(jwtSecretName),
  ]);

  if (!dbSecret.value) {
    throw new Error(`Secret '${dbSecretName}' has no value in Key Vault`);
  }
  if (!jwtSecret.value) {
    throw new Error(`Secret '${jwtSecretName}' has no value in Key Vault`);
  }

  DATABASE_URL_STR = dbSecret.value;
  JWT_SECRET_STR = jwtSecret.value;
}

export function getDatabaseUrl(): string {
  if (!DATABASE_URL_STR) {
    throw new Error("Config not loaded — call loadConfig() before accessing DATABASE_URL_STR");
  }
  return DATABASE_URL_STR;
}

export function getJwtSecret(): string {
  if (!JWT_SECRET_STR) {
    throw new Error("Config not loaded — call loadConfig() before accessing JWT_SECRET_STR");
  }
  return JWT_SECRET_STR;
}