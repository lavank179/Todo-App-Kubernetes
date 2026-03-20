from utils.logger import logger

async def stressCPUBlocking(count):
    logger.info("stress starting...")
    counter = 0
    for i in range(0, count):
        counter += i
    logger.info("stress done...")
    return counter