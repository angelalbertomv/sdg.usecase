import snowflake.connector

# Gets the version
ctx = snowflake.connector.connect(
    user='angelalbertomv',
    password='.Kirschner21',
    account='kd23129.west-europe.azure'
    )
cs = ctx.cursor()
try:
    cs.execute('''COPY INTO "SDG_DB"."SDG_USECASE"."adl_sdgtestcase" ( BUSINESS_ID, LOAD_DATE, PAYLOAD, "test" ) 
     FROM ( SELECT 'TESLA', current_timestamp(), PARSE_JSON($1), 'test'
            FROM @SDG_DB.PUBLIC.SDG_TESTSTAGE/stage/tesla )
  file_format = (type = json);''')
    cs.execute('''merge into "SDG_DB"."SDG_USECASE"."sdl_sdgtestcase" des using (select PAYLOAD:currentPrice as price, BUSINESS_ID, max(load_date) from "SDG_DB"."SDG_USECASE"."adl_sdgtestcase" group by PAYLOAD:currentPrice, BUSINESS_ID) ori
    on ori.business_id = des.business_id
    when matched then 
        update set des.price = ori.price
    when not matched then 
        insert (BUSINESS_ID,price) values (ori.BUSINESS_ID,ori.price);''')

finally:
    cs.close()
ctx.close()