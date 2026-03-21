# ChitOS — Chit Fund Management Platform

## Project Structure

chitos-project/
├── dashboard.html      → Foreman dashboard (full app)
├── join.html           → Member self-registration page
└── README.md           → This file

## Pages

### dashboard.html
The main foreman app. 3-language support (Telugu / Telugu+English / English).
Screens: Home, Groups, Collections, Auctions, Members, Member Portal, More (WhatsApp + Compliance + Reports)

### join.html
The link foreman shares with members on WhatsApp.
Member picks language → enters name + phone → OTP verify → joins group.

## How to Continue in Antigravity

1. Create a new project in Antigravity
2. Upload both HTML files
3. Start building backend:
   - Node.js or Python (FastAPI) backend
   - PostgreSQL or Firebase for database
   - WhatsApp Business API (Twilio / Gupshup / Wati) for OTP + notifications
   - Host on Vercel (frontend) + Railway or Render (backend)

## Database Schema (Starting Point)

### foremen
- id, name, phone, email, plan_type, groups_count, created_at

### chit_groups
- id, foreman_id, name, monthly_amount, member_count, duration_months,
  commission_pct, auction_type, start_date, status, created_at

### members
- id, name, phone, aadhaar_last4, joined_at, verified (bool)

### group_members
- id, group_id, member_id, joined_at, is_prized, prize_month

### collections
- id, group_id, member_id, month, amount, paid_at, method (upi/cash/bank), status

### auctions
- id, group_id, month_number, winner_member_id, bid_amount,
  prize_paid, commission_earned, dividend_per_member, conducted_at

### whatsapp_messages
- id, to_phone, message_type, content, sent_at, status

## Key Features to Build Next

Phase 1 (MVP — get first 10 foremen paying):
  - Foreman signup + login (phone OTP)
  - Create chit group
  - Generate join link per group
  - Member joins via link (name + phone OTP)
  - Mark payment as collected
  - Record auction + auto calculate dividend
  - WhatsApp reminder (manual trigger)

Phase 2 (make them sticky):
  - Member portal (view own history via phone number)
  - Auto WhatsApp reminders (cron jobs)
  - Payment receipt auto-send
  - Auction result broadcast

Phase 3 (monetize deeper):
  - GST invoice generation
  - Subscriber ledger PDF export
  - Member reliability scores
  - Multi-staff access
  - Renewal pipeline

## Pricing Logic
- ₹499 per active chit group per month
- Foreman pays for number of groups they are running
- Free for first group (trial) — then billing starts

## WhatsApp API Recommendation
Use Gupshup or Wati — both have good India support, Telugu template approval.
Twilio works too but more expensive for India numbers.

## Tech Stack Recommendation
Frontend  : HTML/CSS/JS (already built) → later React Native for app
Backend   : Node.js + Express OR Python FastAPI
Database  : PostgreSQL (Supabase is easiest to start)
Auth      : Phone OTP (Firebase Auth or custom with MSG91)
WhatsApp  : Gupshup API
Hosting   : Vercel (frontend) + Supabase (DB + auth) + Railway (backend)
Payments  : Razorpay (for foreman subscription billing)
