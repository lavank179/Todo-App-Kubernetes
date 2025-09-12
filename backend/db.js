const mongoose = require("mongoose");
const { logger } = require("./utils/logger");

module.exports = async () => {
    try {
        const connectionParams = {
            // user: process.env.MONGO_USERNAME,
            // pass: process.env.MONGO_PASSWORD,
            useNewUrlParser: true,
            // useCreateIndex: true,
            useUnifiedTopology: true,
        };
        const useDBAuth = process.env.USE_DB_AUTH || false;
        if(useDBAuth){
            connectionParams.user = process.env.MONGO_USERNAME;
            connectionParams.pass = process.env.MONGO_PASSWORD;
        }
        await mongoose.connect(
           process.env.MONGO_CONN_STR,
           connectionParams
        );
        logger.info("Connected to database.");
    } catch (error) {
        logger.info("Could not connect to database.", error);
    }
};
