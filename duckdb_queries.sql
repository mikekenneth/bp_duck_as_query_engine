---------------- Query multiple Data Sources Simultaneously ----------------
-- COPY (
with 
  fct_trips as (
    select *
    from postgres_db.public.fct_trips
  ),
  dim_customer as (
    select distinct *
    from read_csv('s3://duckdb-bucket/init_data/customer.csv')
  ),
  dim_creditcard as (
    select distinct *
    from mysql_db.db.dim_credit_card
  ),
  dim_companies_data_web as (
    select distinct *
    from read_json('http://nginx:80/companies_data.json')
  )
select 
  trips."Trip ID",
  -- Customer info
  dcust.id as customer_id, dcust.name as customer_name,dcust.sex as customer_sex,
  dcust.address as customer_address, dcust.birth_date as customer_birth_date,
  -- Credit Card info
  dcard.credit_card_number as credit_card_number, dcard.expire_date as credit_card_expire_date,
  dcard.provider as credit_card_provider, dcard.owner_name as credit_card_owner_name,
  -- Company info
  dcompany.name as company_name, dcompany.address as company_address,
  dcompany.created_date as company_created_date, dcompany.num_of_employee as company_num_of_employee
from fct_trips trips
LEFT JOIN dim_customer dcust on trips.customer_id = dcust.id
LEFT JOIN dim_creditcard dcard on trips.credit_card_number = dcard.credit_card_number
LEFT JOIN dim_companies_data_web dcompany on trips.Company = dcompany.name
;

/*
) TO 's3://duckdb-bucket/query_result.parquet' (FORMAT parquet)
;


select *
from 's3://duckdb-bucket/query_result.parquet'
*/
