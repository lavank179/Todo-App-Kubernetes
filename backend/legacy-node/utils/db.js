const mongoose = require("mongoose");
const { logger } = require("./logger");

async function connectToDB() {
  try {
    mongoose.set("strictQuery", false);

    const connectionParams = {
      useNewUrlParser: true,
      useUnifiedTopology: true,
      maxPoolSize: 20,
      minPoolSize: 5,
      serverSelectionTimeoutMS: 5000,
      socketTimeoutMS: 45000,
      w: "majority",
      wtimeoutMS: 5000,
    };

    const useDBAuth = process.env.USE_DB_AUTH === "true";
    if (useDBAuth) {
      connectionParams.user = process.env.MONGO_USERNAME;
      connectionParams.pass = process.env.MONGO_PASSWORD;
    }

    await mongoose.connect(process.env.MONGO_CONN_STR, connectionParams);
    logger.info("Connected to database.");
  } catch (error) {
    logger.error({
      message: "Could not connect to database",
      error: error.message,
      stack: error.stack
    });
  }
}

module.exports = { mongoose, connectToDB };