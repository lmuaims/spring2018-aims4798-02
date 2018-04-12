USE classwork;
CREATE TABLE realestatedata(
    property_id INT PRIMARY KEY, 
	home_type VARCHAR(255), 
	city VARCHAR(255), 
	beds INT, 
	baths INT, 
	sqft INT, 
	lot_size INT, 
	ratio DECIMAL(4,2), 
	age INT, 
	year_built VARCHAR(255), 
	list_price DECIMAL(15,2),
	days_on_market INT, 
	price_per_sqft DECIMAL(7,2), 
	original_list_price DECIMAL(15,2),
	last_sale_price DECIMAL(15,2),
	last_sale_date VARCHAR(255)
	);
	
LOAD DATA INFILE '/var/lib/mysql-files/realestatedata.csv'
INTO TABLE realestatedata FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES
   (property_id, 
	home_type, 
	city, 
	beds, 
	baths, 
	sqft, 
	lot_size, 
	ratio, 
	age, 
	year_built, 
	list_price,
	days_on_market, 
	price_per_sqft, 
	original_list_price,
	last_sale_price,
	@lpsqft, 
	last_sale_date,
	@lat, @long
	);
