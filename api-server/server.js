const express = require('express');
const cors = require('cors');
const mysql = require('mysql2');
const app = express();
const port = 5000;
const path = require('path');

// app.use(express.static(path.join(__dirname, 'public')));       -> USE IN PRODUCTION

// Read the environment variable
const isNotSSL = process.env.IS_MYSQL_SSL === 'noMysqlSSL'; // Check if IS_SSL is explicitly set to 'noMysqlSSL'

// Build the configuration object
const poolConfig = {
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_USER_PASSWORD,
  database: 'mydb',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
};

// Add SSL configuration only if IS_MYSQL_SSL is NOT 'noMysqlSSL'
// if (!isNotSSL) -> this is equal to if NOT
// If there is not IS_MYSQL_SSL = 'noMysqlSSL', then sll = rejectUnathorized will exist, if there is variable set it will not exist
if (!isNotSSL) {
  poolConfig.ssl = {
    rejectUnauthorized: true,
  };
}

// Create the connection pool
const pool = mysql.createPool(poolConfig);

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