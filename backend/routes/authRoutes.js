const express = require('express');
const router = express.Router();
const supabase = require('../config/supabaseClient');

// @route   POST /api/v1/auth/send-otp
router.post('/send-otp', async (req, res) => {
  const { phone } = req.body;
  if (!phone) return res.status(400).json({ error: 'Phone number is required' });

  // Add actual WhatsApp/OTP integration logic here later
  console.log(`Simulated sending OTP to ${phone}`);
  res.status(200).json({ message: 'OTP sent successfully (Simulated)' });
});

// @route   POST /api/v1/auth/verify-otp
router.post('/verify-otp', async (req, res) => {
  const { phone, otp, name, groupId } = req.body; // In a real app we'd verify OTP properly
  if (!phone || !otp) return res.status(400).json({ error: 'Phone and OTP are required' });

  // Simulate OTP Verification
  if (otp !== '1234') {
    return res.status(400).json({ error: 'Invalid OTP' });
  }

  try {
    // Check if member already exists
    let { data: member } = await supabase.from('members').select('*').eq('phone', phone).single();

    if (!member) {
      if (!name) return res.status(400).json({ error: 'Name is required for new users' });
      const { data: newMember, error: insertError } = await supabase
        .from('members')
        .insert([{ phone, name, verified: true }])
        .select().single();
      
      if (insertError) throw insertError;
      member = newMember;
    }

    // Join the specified group if provided
    if (groupId) {
      // Ignore unique constraint errors using upsert or just catch
      const { error: joinError } = await supabase
        .from('group_members')
        .insert([{ group_id: groupId, member_id: member.id }]);
      if (joinError && joinError.code !== '23505') {
        console.error("Error joining group:", joinError.message);
      }
    }

    res.status(200).json({ message: 'Verified successfully', user: member });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Server Error' });
  }
});

module.exports = router;
