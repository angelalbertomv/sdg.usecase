from datetime import datetime
import json
import time
from azure.eventhub import EventHubProducerClient, EventData
import yfinance as yf


i = 0
while i < 10:

# Create a producer client to send messages to the event hub.
# Specify a connection string to your event hubs namespace and
# the event hub name.
    producer = EventHubProducerClient.from_connection_string(conn_str="Endpoint=sb://unicctestcasenms.servicebus.windows.net/;SharedAccessKeyName=all;SharedAccessKey=scyfcyUTzai3oeVMeHwpztI4hilFEsyx4CcmwXMi/VM=;EntityPath=shares_prices", eventhub_name="shares_prices")

    with producer:

        now = datetime.now() 

        current_time = now.strftime("%Y%m%d_%H%M%S")

        tesla = yf.Ticker("TSLA")

        # Without specifying partition_id or partition_key
        # the events will be distributed to available partitions via round-robin.
        event_data_batch = producer.create_batch()
        event_data_batch.add(EventData(str(tesla.info)))
        producer.send_batch(event_data_batch)

    i += 1






