const express = require('express');
const cors = require('cors');
const mysql = require('mysql2');
const app = express();
const port = 5000;
const path = require('path');

// app.use(express.static(path.join(__dirname, 'public')));       -> USE IN PRODUCTION

const pool = mysql.createPool({
  host: 'mydb',              // docker image name (service name in k8s) -  on PRODUCTION - also can ${ENV_VARIABLE}
  user: 'cash100m',
  password: '9TToo02345/55',
  database: 'mydb',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

pool.getConnection((err, connection) => {
  if(err) {
    console.error("Something went wrong connecting to the database ...");
    console.error(err.stack);
    return;
  }
  console.log("Connected as id " + connection.threadId);
});


app.use(cors());


app.get('/', (req, res) => {
  res.send('Welcome to the server!');
});

app.get('/api/products', (req, res) => {
  pool.query('SELECT * FROM products', (err, results) => {
    if (err) {
      console.error('Error querying the database: ' + err.stack);
      res.status(500).send('Error querying the database');
    } else {
      res.json(results);
    }
  });
});

// app.get('*', (req, res) => {
//           res.sendFile(path.join(__dirname, 'public', 'index.html'));
// });


app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});