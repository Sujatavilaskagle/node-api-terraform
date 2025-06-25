const express = require('express');
const cors = require('cors');

const app = express();
const PORT = 6382;
let employees = [];

app.use(cors());
app.use(express.json());

app.get('/employees', (req, res) => res.json(employees));

app.post('/employees', (req, res) => {
  const { name, position, salary } = req.body;
  if (!name || !position || salary == null)
    return res.status(400).json({ message: 'All fields required' });

  const employee = { id: employees.length + 1, name, position, salary };
  employees.push(employee);
  res.status(201).json(employee);
});

app.listen(PORT, () => {
  console.log(`🚀 API running at http://localhost:${PORT}`);
});
