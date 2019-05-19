CREATE database secondary;
DROP TABLE secondary.census_raw;
DROP TABLE secondary.census_all;

CREATE  EXTERNAL TABLE secondary.census_raw
(population integer,
minimum_age integer,
maximum_age integer,
gender string,
zipcode integer,
geo_id string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS
INPUTFORMAT
  'com.amazonaws.emr.s3select.hive.S3SelectableTextInputFormat'
OUTPUTFORMAT
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION 's3://snehalrawinput/census/'
TBLPROPERTIES (
  "s3select.format" = "csv",
  "s3select.headerInfo" = "ignore"
);
CREATE TABLE secondary.census_all
(population integer,
minimum_age integer,
maximum_age integer,
gender string,
zipcode integer,
geo_id string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS PARQUET
TBLPROPERTIES ("parquet.compression"="SNAPPY");


INSERT INTO secondary.census_all
SELECT * FROM secondary.census_raw;