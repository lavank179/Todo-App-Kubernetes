const { logger } = require("./utils/logger");

function stressCPUBlocking(count = 5000000){
  logger.info("stress starting...");
  counter = 0;
  for (i=0; i<=count; i++){
    counter += i;
  }
  logger.info("stress done...");
  return counter;
}

module.exports = async (count) => {
  return await stressCPUBlocking(count);
}