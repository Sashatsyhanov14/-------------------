// DB types matching the new RU-bot SQL schema
// Dropped: RentalUnit, SaleProperty, PropertyPhoto, RentalBooking, LegacyLead

export type BotRow = {
  id: string
  token: string
  masked_token: string
  webhook_secret_path: string
  webhook_secret_token: string
  is_active: boolean
  created_at: string
}

export type Session = {
  id: string;
  bot_id: string;
  external_user_id: string;
  context: any;
  created_at: string;
  updated_at: string;
};

export type Message = {
  id: string;
  session_id: string;
  bot_id: string;
  role: 'user' | 'assistant' | 'system' | string;
  content: string | null;
  payload: any;
  created_at: string;
};

export type Lead = {
  id: string;
  name: string | null;
  phone: string | null;
  email: string | null;
  city: string | null;
  budget_min: number | null;
  budget_max: number | null;
  source: string | null;
  source_bot_id: string | null;
  telegram_chat_id: string | null;
  data: any;
  status: string | null;
  notes: string | null;
  created_at: string;
  updated_at: string;
};
