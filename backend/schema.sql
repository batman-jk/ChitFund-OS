-- schema.sql
-- Run this in your Supabase SQL editor

-- Foremen table
CREATE TABLE IF NOT EXISTS foremen (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  phone TEXT UNIQUE NOT NULL,
  email TEXT,
  plan_type TEXT DEFAULT 'free',
  groups_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Chit Groups table
CREATE TABLE IF NOT EXISTS chit_groups (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  foreman_id UUID REFERENCES foremen(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  monthly_amount INTEGER NOT NULL,
  member_count INTEGER NOT NULL,
  duration_months INTEGER NOT NULL,
  commission_pct INTEGER DEFAULT 5,
  auction_type TEXT,
  start_date DATE,
  status TEXT DEFAULT 'enrolling',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Members table
CREATE TABLE IF NOT EXISTS members (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  phone TEXT UNIQUE NOT NULL,
  aadhaar_last4 TEXT,
  joined_at TIMESTAMPTZ DEFAULT NOW(),
  verified BOOLEAN DEFAULT FALSE
);

-- Group Members table (Many to Many)
CREATE TABLE IF NOT EXISTS group_members (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  group_id UUID REFERENCES chit_groups(id) ON DELETE CASCADE,
  member_id UUID REFERENCES members(id) ON DELETE CASCADE,
  joined_at TIMESTAMPTZ DEFAULT NOW(),
  is_prized BOOLEAN DEFAULT FALSE,
  prize_month INTEGER,
  UNIQUE(group_id, member_id)
);

-- Collections table (Payments)
CREATE TABLE IF NOT EXISTS collections (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  group_id UUID REFERENCES chit_groups(id) ON DELETE CASCADE,
  member_id UUID REFERENCES members(id) ON DELETE CASCADE,
  month INTEGER NOT NULL,
  amount INTEGER NOT NULL,
  paid_at TIMESTAMPTZ DEFAULT NOW(),
  method TEXT,
  status TEXT DEFAULT 'paid'
);

-- Auctions table
CREATE TABLE IF NOT EXISTS auctions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  group_id UUID REFERENCES chit_groups(id) ON DELETE CASCADE,
  month_number INTEGER NOT NULL,
  winner_member_id UUID REFERENCES members(id) ON DELETE CASCADE,
  bid_amount INTEGER NOT NULL,
  prize_paid INTEGER,
  commission_earned INTEGER,
  dividend_per_member INTEGER,
  conducted_at TIMESTAMPTZ DEFAULT NOW()
);

-- WhatsApp messages log
CREATE TABLE IF NOT EXISTS whatsapp_messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  to_phone TEXT NOT NULL,
  message_type TEXT,
  content TEXT,
  sent_at TIMESTAMPTZ DEFAULT NOW(),
  status TEXT
);
