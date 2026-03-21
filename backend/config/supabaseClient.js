const { createClient } = require('@supabase/supabase-js');
require('dotenv').config();

const supabaseUrl = process.env.SUPABASE_URL || 'https://placeholder.supabase.co';
const supabaseKey = process.env.SUPABASE_KEY || 'placeholder-key';

if (supabaseUrl === 'https://placeholder.supabase.co') {
  console.warn('⚠️ Missing SUPABASE_URL or SUPABASE_KEY in environment variables. Using placeholder.');
}

const supabase = createClient(supabaseUrl, supabaseKey);

module.exports = supabase;
