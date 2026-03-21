const supabase = require('./config/supabaseClient');

async function seed() {
  console.log("Seeding Database...");

  let foremanId;

  // 1. Ensure a Foreman exists
  const { data: existingForeman } = await supabase.from('foremen').select('*').limit(1).single();
  
  if (!existingForeman) {
    console.log("Creating default foreman...");
    const { data: newForeman, error: fError } = await supabase
      .from('foremen')
      .insert([{ name: 'Ramesh Kumar', phone: '9999999999', plan_type: 'pro', groups_count: 1 }])
      .select()
      .single();

    if (fError) {
       console.error("Foreman creation error:", fError.message);
       process.exit(1);
    }
    foremanId = newForeman.id;
  } else {
    console.log("Foreman already exists.");
    foremanId = existingForeman.id;
  }

  // 2. Ensure a Chit Group exists
  const { data: existingGroup } = await supabase.from('chit_groups').select('*').eq('foreman_id', foremanId).limit(1).single();

  if (!existingGroup) {
    console.log("Creating default chit group...");
    const { data: newGroup, error: gError } = await supabase
      .from('chit_groups')
      .insert([{
        foreman_id: foremanId,
        name: 'Gold Group A',
        monthly_amount: 1000,
        member_count: 20,
        duration_months: 20,
        commission_pct: 5,
        auction_type: 'lowest_bid',
        status: 'enrolling'
      }])
      .select()
      .single();

    if (gError) {
      console.error("Group creation error:", gError.message);
    } else {
      console.log("Seeding complete! Group created with ID:", newGroup.id);
    }
  } else {
    console.log("Group already exists with ID:", existingGroup.id);
  }

  process.exit(0);
}

seed();
