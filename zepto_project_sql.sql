drop table if exists zepto;
create table zepto(
   sku_id serial primary key,
   category varchar(120),
   Name varchar(150) not null,
   Mrp numeric(8,2),
   Discountpercent numeric(5,2),
   Availablequantity int,
   Discountedsellingprice numeric(8,2),
   Weightingms int,
   Outofstock boolean,
   Quantity int

);


-- to see the table
select * from zepto;

-- import data from file
-- total number of rows
select count(*) from zepto;

--simple data 
select * from zepto limit 10;

--null values
  select * from zepto
   where category is null
   OR
   name is null
   OR 
   mrp is null
    OR 
	discountpercent is null
	OR 
	availablequantity is null
	OR 
	weightingms is null
	 OR
	 outofstock is null
	 OR
	 quantity is null;

--different product categories
   select distinct  category from zepto
    group by category;

--products in stock vs out of stock
   select outofstock,count(sku_id) as stock_vs_outofstock
    from zepto group by outofstock; 

--product names present multiple times
   select name,count(sku_id) as name_twice
   from zepto
   group by name
   having count(sku_id)>1
   order by count(sku_id) desc limit 10;

-- get first 3 letter 
    select left(name,3) from zepto;
-- get right 3 latter
     select right(name,3) from zepto;

--Data Cleaning
--products with price = 0

  select * from zepto
   where mrp=0 and discountedsellingprice =0;

   delete from zepto
    where mrp=0;

--convert paise to rupees
update zepto
 set mrp=mrp/100,
 discountedsellingprice=discountedsellingprice/100; 

 select mrp,discountedsellingprice from zepto;

--data analysis
-- Q1. Find the top 10 best-value products based on the discount percentage.
      SELECT DISTINCT name, mrp, discountPercent
        FROM zepto
        ORDER BY discountPercent DESC
        LIMIT 10;

--Q2.What are the Products with High MRP but Out of Stock.
     select distinct name,mrp from zepto
	  where outofstock = true and mrp>300
	  order by mrp desc;

-- to see product out of stock
   select distinct * from zepto 
    where outofstock = true;
 
--Q3.Calculate Estimated Revenue for each category
    SELECT category,
      SUM(discountedSellingPrice * availableQuantity) AS total_revenue
      FROM zepto
      GROUP BY category
      ORDER BY total_revenue;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
     select distinct name,mrp,discountpercent 
	 from zepto
	 where mrp>500
	 and discountpercent<10
	 order by mrp desc , discountpercent desc;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
      select category,
	  round( avg(discountpercent),2) as avg_discount
	  from zepto
	  group by category
	  order by avg_discount desc;
  
  select 
* from zepto

-- Q6. Find the price per gram for products above 100g and sort by best value.
     select name,weightingms,discountedsellingprice,
	  round(discountedsellingprice/weightingms,2) as per_grms
	  from zepto
	  where weightingms>=100
	  order by per_grms desc;


--Q7.Group the products into categories like Low, Medium, Bulk.
  select distinct name,weightingms,
   CASE  WHEN weightingms < 1000 then 'low'
	WHEN weightingms< 5000 then 'medium'
	else
	   'Bulk'
	   end as weight_category
	  from zepto;

 --Q8.What is the Total Inventory Weight Per Category 
    select category,
	sum(weightingms*availablequantity) as total_weight
	from zepto
	group by category
	order by total_weight desc;

	   