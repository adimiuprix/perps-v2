import "dotenv/config";
import { PrismaClient, Prisma } from "./generated/prisma/client";
import { PrismaMariaDb } from "@prisma/adapter-mariadb";
import mariadb from "mariadb";

export { Prisma };
export type { User, Order, Fill, Position, PositionHistory, FundingRate, FundingPayment, FeeAccount, InsuranceFund } from "./generated/prisma/client";

const connectionString = process.env.DATABASE_URL;
if (!connectionString) {
  throw new Error("DATABASE_URL is not set");
}

// Convert mysql:// to mariadb:// for the adapter (MariaDB is MySQL compatible)
const mariadbConnectionString = connectionString.replace(/^mysql:\/\//, 'mariadb://');

// Prisma 7 with MySQL: Create connection pool and adapter
const pool = mariadb.createPool(mariadbConnectionString);
const adapter = new PrismaMariaDb(pool);

export const prisma = new PrismaClient({
  adapter,
  log: ['error', 'warn'],
});

export type Tx = Prisma.TransactionClient;

function isRetryable(err: unknown): boolean {
  const code = (err as { code?: string }).code;
  if (code === "P2034" || code === "40001" || code === "40P01") return true;
  const message = String((err as Error)?.message ?? "");
  return message.includes("deadlock detected") || message.includes("could not serialize") || message.includes("write conflict") || message.includes("Lock wait timeout");
}

export async function withTransaction<T>(fn: (tx: Tx) => Promise<T>, attempts = 5): Promise<T> {
  let lastError: unknown;
  for (let attempt = 1; attempt <= attempts; attempt++) {
    try {
      return await prisma.$transaction(fn, { maxWait: 10_000, timeout: 30_000 });
    } catch (err) {
      lastError = err;
      if (!isRetryable(err) || attempt === attempts) throw err;
      await new Promise((resolve) => setTimeout(resolve, 25 * attempt + Math.random() * 50));
    }
  }
  throw lastError;
}

export function isUniqueViolation(err: unknown): boolean {
  return (err as { code?: string }).code === "P2002";
}
