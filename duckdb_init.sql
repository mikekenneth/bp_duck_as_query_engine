-- Enable the HTTPS Extension to connect to s3/Minio
INSTALL https;
LOAD https;

-- Set Connection settings
SET s3_region='us-east-1';
SET s3_url_style='path';
SET s3_endpoint='minio:9000';
SET s3_access_key_id='minio_root' ;
SET s3_secret_access_key='minio_toor';
SET s3_use_ssl=false; -- Needed when running without SSL


---------------- PostgreSQL ----------------

-- Load Extension
INSTALL postgres;
LOAD postgres;

-- Attach the PostgreSQL database
ATTACH 'dbname=postgres user=postgres password=postgres host=postgres port=5432' 
AS postgres_db (TYPE postgres, SCHEMA 'public');

-- Create the base table in Postgres from s3
create or replace table postgres_db.fct_trips as
(
    select *
    from read_csv("s3://duckdb-bucket/init_data/base_raw.csv")
);


---------------- MYSQL ----------------

-- Load Extension
INSTALL mysql;
LOAD mysql;

-- Attach the MYSQL database
ATTACH 'database=db user=user password=password host=mysql port=3306' 
AS mysql_db (TYPE mysql);


-- Create the base table in MySQL from s3
create or replace table mysql_db.dim_credit_card as
(
    select *
    from read_csv("s3://duckdb-bucket/init_data/base_raw.csv")
);