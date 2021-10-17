from datetime import datetime
import json

from azure.storage.blob import BlobClient
import yfinance as yf

now = datetime.now() 

current_time = now.strftime("%Y%m%d_%H%M%S")

msft = yf.Ticker("MSFT")
tesla = yf.Ticker("TSLA")

account_url = "https://stasdgusecase.blob.core.windows.net/stage?sp=racwdl&st=2021-10-14T16:14:46Z&se=2022-10-15T00:14:46Z&spr=https&sv=2020-08-04&sr=c&sig=5yJH4LtwncFWmPWdSsK2ERVCpehByCo0sNE5NMWIPH4%3D"
sas_token = "sp=racwdl&st=2021-10-14T16:14:46Z&se=2022-10-15T00:14:46Z&spr=https&sv=2020-08-04&sr=c&sig=5yJH4LtwncFWmPWdSsK2ERVCpehByCo0sNE5NMWIPH4%3D"
container_name = "stage"
blob_name = "msft/msft_{0}".format(current_time)

msft_blob = BlobClient(account_url= account_url, credential= sas_token, container_name=container_name, blob_name= blob_name, content_type='application/json')

msft_blob.upload_blob(json.dumps(msft.info))

blob_name = "tesla/tesla_{0}".format(current_time)

tesla_blob = BlobClient(account_url= account_url, credential= sas_token, container_name=container_name, blob_name= blob_name, content_type='application/json')

tesla_blob.upload_blob(json.dumps(tesla.info))