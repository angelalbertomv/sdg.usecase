from typing import Optional
import snowflake.connector
from fastapi import FastAPI

ctx = snowflake.connector.connect(
    user='angelalbertomv',
    password='.Kirschner21',
    account='kd23129.west-europe.azure'
    )
cs = ctx.cursor()

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.get("/shares/{share_id}")
def read_share(share_id: str, price: Optional[str] = None):
    try:
        price, load_date = cs.cursor().execute("""select price, load_date from "SDG_DB"."SDG_USECASE"."sdl_sdgtestcase" where BUSINESS_ID={0};""".format(share_id)).fetchone()
    finally:
        cs.close()    
    ctx.close()
    
    return {"share_id": share_id, "price": price, "load_date": load_date}