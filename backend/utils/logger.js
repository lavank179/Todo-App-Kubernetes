const winston = require('winston');

const dateTime = new Date();
// dateTime.setDate(dateTime.getDate());
const dateString = dateTime.toISOString().split('T')[0];

// const logFileFormat = winston.format.combine(
//   winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss.sss'}),
//   winston.format.printf(info => `${info.timestamp} ${info.level} ${process.pid} ${info.message}`), //tslint:disable-line
// );

const logFileFormat = winston.format.combine(
  winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss.SSS' }),
  winston.format((info) => {
    info.pid = process.pid;
    return info;
  })(),
  winston.format.json()
);


// Log stream to .log file.
const options = {
  console: {
    colorize: false,
    handleExceptions: true,
    level: 'debug',
    json: true
  },
  file: {
    colorize: false,
    filename: `./tlogs/app.log`,
    format: logFileFormat,
    handleExceptions: true,
    level: 'info',
    json: true
  }
};

const logger = winston.createLogger({
  level: 'info',  // Set the minimum logging level
  transports: [
    new winston.transports.File(options.file), // Log to the console
  ],
});

module.exports = { logger };
