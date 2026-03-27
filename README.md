# 🌊 MysticBay

> All-in-one business platform for interior designers.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Next.js 14 (App Router, TypeScript) |
| Styling | Tailwind CSS |
| Database | Supabase (Postgres + RLS) |
| Auth | Supabase Auth |
| Storage | Supabase Storage |
| Payments | Stripe |
| Canvas | Fabric.js |
| Email | Resend |
| Deployment | Vercel |

---

## Project Structure

```
src/
├── app/
│   ├── auth/
│   │   ├── login/          # Login page
│   │   └── register/       # Register page
│   ├── dashboard/
│   │   ├── projects/       # Project list + detail
│   │   ├── clients/        # Client CRM
│   │   ├── invoices/       # Invoice management
│   │   ├── contracts/      # Contract builder
│   │   └── settings/       # Account + billing
│   ├── portal/
│   │   └── [token]/        # Client portal (public, token-gated)
│   └── api/                # Route handlers
├── components/
│   ├── ui/                 # Reusable base components (buttons, inputs, etc.)
│   ├── layout/             # Sidebar, header, shell
│   ├── canvas/             # Fabric.js moodboard editor
│   ├── projects/           # Project-specific components
│   ├── clients/            # Client-specific components
│   ├── invoices/           # Invoice-specific components
│   └── portal/             # Client portal components
├── lib/
│   ├── supabase/           # Browser + server clients
│   ├── stripe/             # Stripe setup + helpers
│   └── utils/              # General utilities (cn, formatters)
├── hooks/                  # Custom React hooks
├── types/                  # Global TypeScript types
└── styles/                 # Global CSS
supabase/
└── migrations/             # SQL migration files
```

---

## Getting Started

### 1. Clone & Install

```bash
git clone https://github.com/yourname/mysticbay.git
cd mysticbay
npm install
```

### 2. Set Up Supabase

1. Create a new project at [supabase.com](https://supabase.com)
2. Go to **SQL Editor** and run `supabase/migrations/001_initial_schema.sql`
3. Enable **Email Auth** in Authentication settings
4. Create a **Storage bucket** called `assets` (public)

### 3. Set Up Stripe

1. Create a Stripe account at [stripe.com](https://stripe.com)
2. Create two products: **Pro** ($29/mo) and **Studio** ($69/mo)
3. Copy the Price IDs into your `.env.local`
4. Set up a webhook pointing to `/api/webhooks/stripe`

### 4. Configure Environment

```bash
cp .env.local.example .env.local
# Fill in all values
```

### 5. Run

```bash
npm run dev
```

---

## MVP Modules & Build Order

- [x] Phase 0 — Project scaffold & schema
- [ ] Phase 1 — Auth, dashboard shell, project CRUD
- [ ] Phase 2 — Moodboard canvas (Fabric.js)
- [ ] Phase 3 — Product library
- [ ] Phase 4 — Client portal + commenting
- [ ] Phase 5 — Invoicing + Stripe payments
- [ ] Phase 6 — Contracts + intake forms

---

## Subscription Tiers

| Feature | Free | Pro ($29/mo) | Studio ($69/mo) |
|---|---|---|---|
| Projects | 1 | Unlimited | Unlimited |
| Boards / project | 2 | Unlimited | Unlimited |
| Clients | 3 | Unlimited | Unlimited |
| Invoices | 5 | Unlimited | Unlimited |
| Storage | 100 MB | 5 GB | 20 GB |
| Client portals | ✓ | ✓ | ✓ |
| Contracts | ✗ | ✓ | ✓ |
| Team seats | ✗ | ✗ | ✓ |
