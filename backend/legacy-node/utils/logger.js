const fs = require('fs');
const path = require('path');

const dateTime = new Date();
const dateString = dateTime.toISOString().split('T')[0];

// Ensure logs directory exists
const logsDir = path.join(__dirname, '..', 'tlogs');
if (!fs.existsSync(logsDir)) {
  fs.mkdirSync(logsDir, { recursive: true });
}

const logFilePath = path.join(logsDir, 'app.log');

// Simple logger that mimics winston's interface
const logger = {
  info: (message) => {
    const timestamp = new Date().toISOString().replace('T', ' ').substring(0, 23);
    const logEntry = JSON.stringify({
      timestamp,
      level: 'info',
      pid: process.pid,
      message
    }) + '\n';

    fs.appendFileSync(logFilePath, logEntry);
    console.log(`[INFO] ${message}`);
  },

  error: (message) => {
    const timestamp = new Date().toISOString().replace('T', ' ').substring(0, 23);
    const logEntry = JSON.stringify({
      timestamp,
      level: 'error',
      pid: process.pid,
      message
    }) + '\n';

    fs.appendFileSync(logFilePath, logEntry);
    console.error(`[ERROR] ${message}`);
  },

  warn: (message) => {
    const timestamp = new Date().toISOString().replace('T', ' ').substring(0, 23);
    const logEntry = JSON.stringify({
      timestamp,
      level: 'warn',
      pid: process.pid,
      message
    }) + '\n';

    fs.appendFileSync(logFilePath, logEntry);
    console.warn(`[WARN] ${message}`);
  },

  debug: (message) => {
    const timestamp = new Date().toISOString().replace('T', ' ').substring(0, 23);
    const logEntry = JSON.stringify({
      timestamp,
      level: 'debug',
      pid: process.pid,
      message
    }) + '\n';

    fs.appendFileSync(logFilePath, logEntry);
    console.log(`[DEBUG] ${message}`);
  }
};

module.exports = { logger };
