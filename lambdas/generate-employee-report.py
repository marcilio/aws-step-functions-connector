
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handler(event, context):
    try:
        logger.info('Employee information: [id={}, age={}, employment_status: {}]'.format(
            event['id'], event['details']['age'], event['details']['employment_status']))
        # Do something with employee data - irrelevant for this project
        return event
    except Exception as e:
        logger.error(str(e))
        raise
