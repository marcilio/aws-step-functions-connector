
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handler(event, context):
    try:
        # Do something with employee data - irrelevant for this project
        return event
    except Exception as e:
        logger.error(str(e))
        raise
