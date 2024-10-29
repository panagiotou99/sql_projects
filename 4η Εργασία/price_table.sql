--1st Step: Creation of "Price" table 
CREATE TABLE "Price" AS
(SELECT 
id as listing_id,
price,
weekly_price,
monthly_price,
security_deposit,
cleaning_fee,
guests_included,
extra_people,
minimum_nights,
maximum_nights,
minimum_minimum_nights,
maximum_minimum_nights,
minimum_maximum_nights,
maximum_maximum_nights,
minimum_nights_avg_ntm,
maximum_nights_avg_ntm
FROM "Listings");

--2nd Step: Remove the "$" from the VARCHAR columns 
UPDATE "Price" SET price = REPLACE(price,'$','') WHERE price IS NOT NULL;
UPDATE "Price" SET weekly_price = REPLACE(weekly_price,'$','') WHERE weekly_price IS NOT NULL;
UPDATE "Price" SET monthly_price = REPLACE(monthly_price,'$','') WHERE monthly_price IS NOT NULL;
UPDATE "Price" SET security_deposit = REPLACE(security_deposit,'$','') WHERE security_deposit IS NOT NULL;
UPDATE "Price" SET cleaning_fee = REPLACE(cleaning_fee,'$','') WHERE cleaning_fee IS NOT NULL;
UPDATE "Price" SET extra_people = REPLACE(extra_people,'$','') WHERE extra_people IS NOT NULL;

--3rd Step: Remove the ".00" and ',' (for ex. we want 1000 instead of 1.000) from the price columns 
UPDATE "Price" SET price = REPLACE(price,'.00','') WHERE price IS NOT NULL;
UPDATE "Price" SET weekly_price = REPLACE(weekly_price,'.00','') WHERE weekly_price IS NOT NULL;
UPDATE "Price" SET monthly_price = REPLACE(monthly_price,'.00','') WHERE monthly_price IS NOT NULL;
UPDATE "Price" SET security_deposit = REPLACE(security_deposit,'.00','') WHERE security_deposit IS NOT NULL;
UPDATE "Price" SET cleaning_fee = REPLACE(cleaning_fee,'.00','') WHERE cleaning_fee IS NOT NULL;
UPDATE "Price" SET extra_people = REPLACE(extra_people,'.00','') WHERE extra_people IS NOT NULL;
UPDATE "Price" SET price = REPLACE(price,',','') WHERE price IS NOT NULL;
UPDATE "Price" SET weekly_price = REPLACE(weekly_price,',','') WHERE weekly_price IS NOT NULL;
UPDATE "Price" SET monthly_price = REPLACE(monthly_price,',','') WHERE monthly_price IS NOT NULL;
UPDATE "Price" SET security_deposit = REPLACE(security_deposit,',','') WHERE security_deposit IS NOT NULL;
UPDATE "Price" SET cleaning_fee = REPLACE(cleaning_fee,',','') WHERE cleaning_fee IS NOT NULL;
UPDATE "Price" SET extra_people = REPLACE(extra_people,',','') WHERE extra_people IS NOT NULL;

--4th Step: Convert VARCHAR to DECIMAL 
ALTER TABLE "Price"
ALTER COLUMN price TYPE DECIMAL(10,0) 
USING price::numeric(10,0);

ALTER TABLE "Price"
ALTER COLUMN weekly_price TYPE DECIMAL(10,0)
 USING weekly_price::numeric(10,0);

ALTER TABLE "Price"
ALTER COLUMN monthly_price TYPE DECIMAL(10,0) 
USING monthly_price::numeric(10,0);

ALTER TABLE "Price"
ALTER COLUMN security_deposit TYPE DECIMAL(10,0) 
USING security_deposit::numeric(10,0);

ALTER TABLE "Price"
ALTER COLUMN cleaning_fee TYPE DECIMAL(10,0)
 USING cleaning_fee::numeric(10,0);

ALTER TABLE "Price"
ALTER COLUMN extra_people TYPE DECIMAL(10,0) 
USING extra_people::numeric(10,0);

ALTER TABLE "Price"
ALTER COLUMN minimum_nights_avg_ntm TYPE DECIMAL(10,2)  
USING minimum_nights_avg_ntm::numeric(10,2);

ALTER TABLE "Price"
ALTER COLUMN maximum_nights_avg_ntm TYPE DECIMAL(10,2) 
USING maximum_nights_avg_ntm::numeric(10,2);

--5th Step: Add a foreign key to "Price" table 
ALTER TABLE "Price"
ADD FOREIGN KEY (listing_id) REFERENCES "Listings"(id)

--6th Step: Delete the fields from "Listings" we don't need 
ALTER TABLE "Listings"
DROP COLUMN price,
DROP COLUMN weekly_price,
DROP COLUMN monthly_price,
DROP COLUMN security_deposit,
DROP COLUMN cleaning_fee,
DROP COLUMN extra_people