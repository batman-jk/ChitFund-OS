const express = require('express');
const cors = require('cors');
const path = require('path');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());

// Serve static frontend files from the project root
const staticPath = path.resolve(__dirname, '..');
app.use(express.static(staticPath));

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

// Fallback: serve dashboard.html for root
app.get('/', (req, res) => {
  res.sendFile(path.join(staticPath, 'dashboard.html'));
});

const server = app.listen(PORT, () => {
  console.log(`\n🏦 ChitOS Server is running!`);
  console.log(`   Dashboard: http://localhost:${PORT}/dashboard.html`);
  console.log(`   Join Page: http://localhost:${PORT}/join.html`);
  console.log(`   API:       http://localhost:${PORT}/api/v1/health\n`);
});

server.on('error', (err) => {
  if (err.code === 'EADDRINUSE') {
    console.error(`\n❌ Port ${PORT} is already in use!`);
    console.error(`   Run: taskkill /F /PID $(netstat -ano | findstr :${PORT})`);
    console.error(`   Or change PORT in your .env file.\n`);
  } else {
    console.error('Server error:', err);
  }
});
