const supabase = require('./config/supabaseClient');

async function testConnection() {
  console.log("Testing Supabase Connection...");
  const { data, error } = await supabase.from('foremen').select('*').limit(1);
  
  if (error) {
    console.error("❌ Connection failed. Error details:", error.message);
    process.exit(1);
  } else {
    console.log("✅ Connection successful! Supabase is configured correctly and tables exist.");
    process.exit(0);
  }
}

testConnection();
