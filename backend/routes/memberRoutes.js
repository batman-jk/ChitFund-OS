const express = require('express');
const router = express.Router();
const supabase = require('../config/supabaseClient');

// @route   GET /api/v1/members/:groupId
// @desc    Get all members in a group
router.get('/:groupId', async (req, res) => {
  const { groupId } = req.params;
  try {
    // Fetch members via group_members junction table
    const { data: groupMembers, error } = await supabase
      .from('group_members')
      .select(`
        id,
        joined_at,
        is_prized,
        prize_month,
        members ( id, name, phone, verified )
      `)
      .eq('group_id', groupId);

    if (error) throw error;

    // Flatten the nested data structure for easier frontend consumption
    const formattedData = groupMembers.map(gm => ({
      ...gm.members,
      group_member_id: gm.id,
      joined_at: gm.joined_at,
      is_prized: gm.is_prized,
      prize_month: gm.prize_month
    }));

    res.status(200).json({ message: `Fetched members for group ${groupId}`, data: formattedData });
  } catch (err) {
    console.error("Error fetching members:", err);
    res.status(500).json({ error: 'Server Error' });
  }
});

// @route   POST /api/v1/members
// @desc    Add a new member to a group manually
router.post('/', async (req, res) => {
  const { groupId, name, phone } = req.body;
  if (!groupId || !name || !phone) return res.status(400).json({ error: 'groupId, name, and phone are required' });

  try {
    // 1. Check if member exists or create
    let memberId;
    let { data: existingMember } = await supabase.from('members').select('id').eq('phone', phone).single();
    
    if (existingMember) {
      memberId = existingMember.id;
    } else {
      const { data: newMember, error: insertError } = await supabase
        .from('members')
        .insert([{ name, phone, verified: true }])
        .select('id').single();
      if (insertError) throw insertError;
      memberId = newMember.id;
    }

    // 2. Add to group
    const { error: joinError } = await supabase
      .from('group_members')
      .insert([{ group_id: groupId, member_id: memberId }]);

    // Ignore if they are already in the group
    if (joinError && joinError.code !== '23505') throw joinError;

    res.status(201).json({ message: 'Member added successfully' });
  } catch (err) {
    console.error("Error adding member:", err);
    res.status(500).json({ error: 'Server Error' });
  }
});

module.exports = router;
