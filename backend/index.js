const express = require('express');
const { Pool } = require('pg');
const app = express();
app.use(express.json());

const pool = new Pool({ connectionString: process.env.DATABASE_URL });

// Health check endpoint
app.get('/healthz', (req, res) => res.json({ status: 'ok' }));

// Get all users
app.get('/users', async (req, res) => {
  const { rows } = await pool.query('SELECT * FROM users');
  res.json(rows);
});

// Add a new user
app.post('/users', async (req, res) => {
  const { name } = req.body;
  const { rows } = await pool.query(
    'INSERT INTO users(name) VALUES($1) RETURNING *', [name]
  );
  res.json(rows[0]);
});

app.listen(3000, () => console.log('Backend running on port 3000'));

module.exports = app; // Export for testing