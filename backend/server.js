const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());

// Serve static frontend files
const path = require('path');
app.use(express.static(path.join(__dirname, '../')));

// Routes
const authRoutes = require('./routes/authRoutes');
const groupRoutes = require('./routes/groupRoutes');
const memberRoutes = require('./routes/memberRoutes');
const dashboardRoutes = require('./routes/dashboardRoutes');

app.use('/api/v1/auth', authRoutes);
app.use('/api/v1/groups', groupRoutes);
app.use('/api/v1/members', memberRoutes);
app.use('/api/v1/dashboard', dashboardRoutes);

// Health Check
app.get('/api/v1/health', (req, res) => {
  res.status(200).json({ status: 'healthy', message: 'ChitOS Server is running' });
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
