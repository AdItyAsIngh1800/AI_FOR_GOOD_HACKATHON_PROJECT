USE SCHEMA PUBLIC;
USE DATABASE inventory_a4g;
USE WAREHOUSE WH_INVENTORY;

use role role_inventory_a4g;

SELECT CURRENT_DATABASE(), CURRENT_SCHEMA(), CURRENT_WAREHOUSE(), CURRENT_ROLE();

GRANT CREATE STAGE
ON SCHEMA inventory_a4g.public
TO ROLE role_inventory_a4g;

CREATE OR REPLACE FILE FORMAT FF_DAILY_STOCK_CSV
TYPE = CSV
SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
NULL_IF = ('', 'NULL', 'null');

CREATE OR REPLACE STAGE STG_DAILY_STOCK
FILE_FORMAT = FF_DAILY_STOCK_CSV;

CREATE OR REPLACE TABLE LAND_DAILY_STOCK (
  stock_date       DATE,
  location         STRING,
  item             STRING,
  opening_stock    NUMBER(18,2),
  received         NUMBER(18,2),
  issued           NUMBER(18,2),
  closing_stock    NUMBER(18,2),
  lead_time_days   NUMBER(10,0),
  file_name        STRING,
  load_ts          TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

COPY INTO LAND_DAILY_STOCK
(stock_date, location, item, opening_stock, received, issued, closing_stock, lead_time_days, file_name)
FROM (
  SELECT
    $1::DATE,
    $2::STRING,
    $3::STRING,
    $4::NUMBER(18,2),
    $5::NUMBER(18,2),
    $6::NUMBER(18,2),
    $7::NUMBER(18,2),
    $8::NUMBER(10,0),
    METADATA$FILENAME
  FROM @STG_DAILY_STOCK
);

-- Tracks newly inserted rows in landing table

GRANT CREATE STREAM
ON SCHEMA inventory_a4g.public
TO ROLE role_inventory_a4g;


CREATE OR REPLACE STREAM STR_LAND_DAILY_STOCK
ON TABLE LAND_DAILY_STOCK
APPEND_ONLY = TRUE;

GRANT USAGE
ON WAREHOUSE WH_INVENTORY
TO ROLE role_inventory_a4g;

GRANT CREATE TASK, CREATE STAGE, CREATE FILE FORMAT
ON SCHEMA inventory_a4g.public
TO ROLE role_inventory_a4g;


CREATE OR REPLACE TASK TASK_INGEST_DAILY_STOCK
WAREHOUSE = WH_INVENTORY
SCHEDULE = 'USING CRON 0 2 * * * Asia/Kolkata'
AS
INSERT INTO RAW_DAILY_STOCK
(stock_date, location, item, opening_stock, received, issued, closing_stock, lead_time_days, source_file)
SELECT
  stock_date,
  location,
  item,
  opening_stock,
  received,
  issued,
  closing_stock,
  lead_time_days,
  file_name
FROM STR_LAND_DAILY_STOCK;


ALTER TASK TASK_INGEST_DAILY_STOCK RESUME;

EXECUTE TASK TASK_INGEST_DAILY_STOCK;

-- verification queries
LIST @STG_DAILY_STOCK;

SELECT * FROM LAND_DAILY_STOCK;

SELECT * FROM STR_LAND_DAILY_STOCK;

SELECT * FROM RAW_DAILY_STOCK ORDER BY ingested_at DESC;

