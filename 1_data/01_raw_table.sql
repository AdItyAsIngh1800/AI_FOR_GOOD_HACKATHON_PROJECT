SHOW TABLES LIKE 'RAW_DAILY_STOCK';


CREATE OR REPLACE TABLE RAW_DAILY_STOCK (
  stock_date       DATE,
  location         STRING,
  item             STRING,
  opening_stock    NUMBER(18,2),
  received         NUMBER(18,2),
  issued           NUMBER(18,2),
  closing_stock    NUMBER(18,2),
  lead_time_days   NUMBER(10,0),
  source_file      STRING,
  ingested_at      TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

DESC TABLE RAW_DAILY_STOCK;

INSERT INTO RAW_DAILY_STOCK
(stock_date, location, item, opening_stock, received, issued, closing_stock, lead_time_days, source_file)
VALUES
('2025-12-25','Hospital_A','Paracetamol_500mg',120,20,30,110,4,'seed'),
('2025-12-26','Hospital_A','Paracetamol_500mg',110,0,35,75,4,'seed'),
('2025-12-27','Hospital_A','Paracetamol_500mg',75,0,25,50,4,'seed'),
('2025-12-25','Hospital_A','ORS_Sachets',200,0,60,140,3,'seed'),
('2025-12-26','Hospital_A','ORS_Sachets',140,0,70,70,3,'seed'),
('2025-12-27','Hospital_A','ORS_Sachets',70,0,40,30,3,'seed'),
('2025-12-25','PDS_1','Rice_5kg',500,0,120,380,7,'seed'),
('2025-12-26','PDS_1','Rice_5kg',380,0,100,280,7,'seed'),
('2025-12-27','PDS_1','Rice_5kg',280,0,90,190,7,'seed'),
('2025-12-25','NGO_Camp','Blanket',80,30,10,100,10,'seed'),
('2025-12-26','NGO_Camp','Blanket',100,0,5,95,10,'seed'),
('2025-12-27','NGO_Camp','Blanket',95,0,8,87,10,'seed');
