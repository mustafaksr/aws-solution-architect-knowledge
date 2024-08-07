const express = require('express');
const awsServerlessExpress = require('aws-serverless-express');
const app = express();

// Middleware to handle JSON requests
app.use(express.json());

// Route handlers
app.get('/', (req, res) => {
  res.json({ message: 'salute message for main route api' });
});

// Create a server and export the handler
const server = awsServerlessExpress.createServer(app);

exports.handler = (event, context) => {
    awsServerlessExpress.proxy(server, event, context);
};
