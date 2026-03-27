// ─── User & Auth ────────────────────────────────────────────

export type UserRole = "owner" | "member" | "viewer";

export type SubscriptionTier = "free" | "pro" | "studio";

export interface Profile {
  id: string;
  email: string;
  full_name: string;
  avatar_url?: string;
  business_name?: string;
  business_logo_url?: string;
  subscription_tier: SubscriptionTier;
  stripe_customer_id?: string;
  created_at: string;
  updated_at: string;
}

// ─── Projects ───────────────────────────────────────────────

export type ProjectStatus = "active" | "on_hold" | "completed" | "archived";

export interface Project {
  id: string;
  designer_id: string;
  title: string;
  description?: string;
  status: ProjectStatus;
  client_id?: string;
  client_portal_token: string; // UUID — used in shareable link
  cover_image_url?: string;
  created_at: string;
  updated_at: string;
}

// ─── Clients ────────────────────────────────────────────────

export interface Client {
  id: string;
  designer_id: string;
  full_name: string;
  email: string;
  phone?: string;
  company?: string;
  address?: string;
  notes?: string;
  created_at: string;
  updated_at: string;
}

// ─── Moodboards ─────────────────────────────────────────────

export interface Board {
  id: string;
  project_id: string;
  title: string;
  canvas_json: string; // Fabric.js serialized canvas state
  thumbnail_url?: string;
  created_at: string;
  updated_at: string;
}

// ─── Products ───────────────────────────────────────────────

export type ProductStatus = "considering" | "approved" | "ordered" | "delivered";

export interface Product {
  id: string;
  project_id: string;
  name: string;
  vendor?: string;
  price?: number;
  currency: string;
  quantity: number;
  image_url?: string;
  product_url?: string;
  sku?: string;
  notes?: string;
  status: ProductStatus;
  created_at: string;
  updated_at: string;
}

// ─── Invoices ───────────────────────────────────────────────

export type InvoiceStatus = "draft" | "sent" | "paid" | "overdue" | "cancelled";

export interface InvoiceLineItem {
  id: string;
  description: string;
  quantity: number;
  unit_price: number;
}

export interface Invoice {
  id: string;
  designer_id: string;
  client_id: string;
  project_id?: string;
  invoice_number: string;
  status: InvoiceStatus;
  line_items: InvoiceLineItem[];
  subtotal: number;
  tax_rate: number;
  tax_amount: number;
  total: number;
  currency: string;
  due_date: string;
  paid_at?: string;
  notes?: string;
  stripe_payment_intent_id?: string;
  stripe_payment_link?: string;
  created_at: string;
  updated_at: string;
}

// ─── Contracts ──────────────────────────────────────────────

export type ContractStatus = "draft" | "sent" | "signed" | "cancelled";

export interface Contract {
  id: string;
  designer_id: string;
  client_id: string;
  project_id?: string;
  title: string;
  body: string; // Rich text / markdown
  status: ContractStatus;
  client_signature?: string; // base64 signature image
  client_signed_at?: string;
  client_ip_address?: string;
  created_at: string;
  updated_at: string;
}

// ─── Comments (Client Portal) ───────────────────────────────

export interface Comment {
  id: string;
  project_id: string;
  board_id?: string;
  author_name: string;
  author_type: "designer" | "client";
  body: string;
  created_at: string;
}

// ─── Intake Forms ───────────────────────────────────────────

export interface IntakeFormField {
  id: string;
  label: string;
  type: "text" | "textarea" | "select" | "checkbox" | "date";
  required: boolean;
  options?: string[]; // for select fields
}

export interface IntakeForm {
  id: string;
  designer_id: string;
  title: string;
  fields: IntakeFormField[];
  created_at: string;
}

export interface IntakeFormResponse {
  id: string;
  form_id: string;
  client_id?: string;
  responses: Record<string, string | string[] | boolean>;
  submitted_at: string;
}

// ─── API Responses ──────────────────────────────────────────

export interface ApiResponse<T> {
  data?: T;
  error?: string;
}

// ─── Pagination ─────────────────────────────────────────────

export interface PaginatedResponse<T> {
  data: T[];
  count: number;
  page: number;
  pageSize: number;
  totalPages: number;
}
