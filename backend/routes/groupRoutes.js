const express = require('express');
const router = express.Router();
const supabase = require('../config/supabaseClient');

// @route   GET /api/v1/groups
// @desc    Get all groups for a foreman
router.get('/', async (req, res) => {
  try {
    // For MVP, just get the first foreman or a specific one if provided via query
    const foremanId = req.query.foremanId;
    let query = supabase.from('chit_groups').select('*');
    if (foremanId) query = query.eq('foreman_id', foremanId);

    const { data: groups, error } = await query;
    if (error) throw error;

    res.status(200).json({ message: 'Groups fetched successfully', data: groups });
  } catch (err) {
    console.error("Error fetching groups:", err);
    res.status(500).json({ error: 'Server Error' });
  }
});

// @route   GET /api/v1/groups/:id
// @desc    Get a single group by ID
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { data: group, error } = await supabase.from('chit_groups').select(`
      *,
      foremen ( name )
    `).eq('id', id).single();
    
    if (error) throw error;
    if (!group) return res.status(404).json({ error: 'Group not found' });

    res.status(200).json({ message: 'Group fetched successfully', data: group });
  } catch (err) {
    console.error("Error fetching group:", err);
    res.status(500).json({ error: 'Server Error' });
  }
});

// @route   POST /api/v1/groups
// @desc    Create a new chit group
router.post('/', async (req, res) => {
  const { name, monthly_amount, member_count, duration_months, foreman_id } = req.body;
  
  try {
    // For MVP, if no foreman_id is provided, use the first one available
    let actualForemanId = foreman_id;
    if (!actualForemanId) {
       const { data: foreman } = await supabase.from('foremen').select('id').limit(1).single();
       if (!foreman) return res.status(404).json({ error: 'No foreman found to assign group to' });
       actualForemanId = foreman.id;
    }

    const { data: newGroup, error } = await supabase
      .from('chit_groups')
      .insert([{
        name,
        monthly_amount,
        member_count,
        duration_months,
        foreman_id: actualForemanId,
        status: 'enrolling'
      }])
      .select()
      .single();

    if (error) throw error;

    res.status(201).json({ message: 'Group created successfully', data: newGroup });
  } catch (err) {
    console.error("Error creating group:", err);
    res.status(500).json({ error: 'Server Error' });
  }
});

module.exports = router;
