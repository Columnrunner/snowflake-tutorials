-- create a db
create or replace database sf_tuts1;

-- create table
create or replace table emp_basic1 (
  first_name string ,
  last_name string ,
  email string ,
  streetaddress string ,
  city string ,
  start_date date
  );

-- create a warehouse
create or replace warehouse sf_tuts_wh1 with
  warehouse_size='X-SMALL'
  auto_suspend = 180
  auto_resume = true
  initially_suspended=true;


-- stage data files
put file:///Users/yunfeimao/snowflake-tutorials/dataset/employees0*.csv @sf_tuts1.public.%emp_basic1;


-- copy data to target tables
copy into emp_basic1
  from @%emp_basic1
  file_format = (type = csv field_optionally_enclosed_by='"')
  pattern = '.*employees0[1-5].csv.gz'
  on_error = 'skip_file';


create function mythirdfunc()
returns table(email String, city string) 
as
$$
select email, city from EMP_BASIC1
$$;

select * from table(mythirdfunc());

-- run sql file and export output into a file
-- snowsql -f /Users/yunfeimao/snowflake-tutorials/scripts/wholeprocess.sql -o header=false -o timing=false -o friendly=false  > output_file.csv