const express = require('express');
const router = express.Router();
const supabase = require('../config/supabaseClient');

// @route   GET /api/v1/dashboard/summary
// @desc    Get dashboard metrics for a foreman
router.get('/summary', async (req, res) => {
  try {
    // For MVP, just get the first foreman or a specific one if provided
    const foremanId = req.query.foremanId;
    let query = supabase.from('foremen').select('id');
    if (foremanId) query = query.eq('id', foremanId);
    
    const { data: foreman } = await query.limit(1).single();
    if (!foreman) return res.status(404).json({ error: 'No foreman found' });

    // Fetch total active groups managed by foreman
    const { data: groups } = await supabase.from('chit_groups').select('id, member_count, status').eq('foreman_id', foreman.id);
    const activeGroupsCount = groups ? groups.length : 0;
    
    // Sum member counts theoretically across these groups
    const totalMembers = groups ? groups.reduce((acc, g) => acc + g.member_count, 0) : 0;
    
    let realMembersCount = 0;
    let earnedThisMonth = 0;
    let paidMembers = 0;
    let pendingMembers = 0;

    if (groups && groups.length > 0) {
        const groupIds = groups.map(g => g.id);
        
        // Count real joined members from group_members table
        const { count } = await supabase.from('group_members')
          .select('id', { count: 'exact', head: true })
          .in('group_id', groupIds);
        realMembersCount = count || 0;

        // Calculate earnings and payments for the current month
        // Assuming current month is 1 for simplicity in MVP, or we can fetch all collections
        const currentMonth = 1;
        const { data: collections } = await supabase.from('collections')
          .select('amount, status')
          .in('group_id', groupIds)
          .eq('month', currentMonth);

        if (collections) {
           collections.forEach(c => {
               if (c.status === 'paid') {
                   earnedThisMonth += c.amount;
                   paidMembers++;
               } else {
                   pendingMembers++;
               }
           });
        }
    }

    res.status(200).json({
      earned_this_month: earnedThisMonth,
      groups_count: activeGroupsCount,
      total_expected_members: totalMembers,
      total_joined_members: realMembersCount,
      paid_members: paidMembers,
      pending_members: pendingMembers
    });

  } catch (err) {
    console.error("Dashboard error:", err);
    res.status(500).json({ error: 'Server Error' });
  }
});

module.exports = router;
