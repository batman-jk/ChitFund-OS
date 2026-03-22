const express = require('express');
const router = express.Router();
const supabase = require('../config/supabaseClient');

// Temporary in-memory store for OTPs (In production, use Redis or a DB table)
const otpStore = new Map();

// Helper to generate a 4-digit OTP
function generateOTP() {
  return Math.floor(1000 + Math.random() * 9000).toString();
}

// @route   POST /api/v1/auth/send-otp
router.post('/send-otp', async (req, res) => {
  const { phone } = req.body;
  if (!phone) return res.status(400).json({ error: 'Phone number is required' });

  const otp = generateOTP();
  otpStore.set(phone, { otp, expires: Date.now() + 5 * 60 * 1000 }); // 5 min expiry

  console.log(`\n[OTP DEBUG] Phone: ${phone}, OTP: ${otp}\n`);

  // Twilio Integration
  if (process.env.TWILIO_ACCOUNT_SID && process.env.TWILIO_AUTH_TOKEN) {
    try {
      const twilio = require('twilio')(process.env.TWILIO_ACCOUNT_SID, process.env.TWILIO_AUTH_TOKEN);
      await twilio.messages.create({
        body: `Your ChitOS verification code is: ${otp}. Do not share this with anyone.`,
        from: process.env.TWILIO_PHONE_NUMBER,
        to: `+91${phone}`
      });
      return res.status(200).json({ message: 'OTP sent successfully via Twilio' });
    } catch (err) {
      console.error('Twilio Error:', err.message);
      return res.status(500).json({ error: 'Failed to send SMS via Twilio. Check your credentials.' });
    }
  }

  // Fallback for development (Simulation)
  res.status(200).json({ 
    message: 'OTP sent successfully (Simulated)',
    debugOtp: process.env.NODE_ENV !== 'production' ? otp : undefined 
  });
});

// @route   POST /api/v1/auth/verify-otp
router.post('/verify-otp', async (req, res) => {
  const { phone, otp, name, groupId } = req.body;
  if (!phone || !otp) return res.status(400).json({ error: 'Phone and OTP are required' });

  const storedData = otpStore.get(phone);

  // Check if OTP exists and matches
  if (!storedData || storedData.otp !== otp) {
    return res.status(400).json({ error: 'Invalid OTP' });
  }

  // Check expiry
  if (Date.now() > storedData.expires) {
    otpStore.delete(phone);
    return res.status(400).json({ error: 'OTP expired. Please request a new one.' });
  }

  // Success - Clear OTP
  otpStore.delete(phone);

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
