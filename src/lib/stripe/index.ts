import Stripe from "stripe";

export const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
  apiVersion: "2024-04-10",
  typescript: true,
});

// Subscription tier limits
export const TIER_LIMITS = {
  free: {
    projects: 1,
    boards_per_project: 2,
    clients: 3,
    invoices: 5,
    storage_mb: 100,
  },
  pro: {
    projects: Infinity,
    boards_per_project: Infinity,
    clients: Infinity,
    invoices: Infinity,
    storage_mb: 5000,
  },
  studio: {
    projects: Infinity,
    boards_per_project: Infinity,
    clients: Infinity,
    invoices: Infinity,
    storage_mb: 20000,
  },
} as const;

export type TierLimits = typeof TIER_LIMITS;

// Price IDs map
export const PRICE_IDS = {
  pro: process.env.STRIPE_PRO_MONTHLY_PRICE_ID!,
  studio: process.env.STRIPE_STUDIO_MONTHLY_PRICE_ID!,
};
