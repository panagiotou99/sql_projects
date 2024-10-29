--=========================For price===============================
--1st Step
UPDATE "Calendar" 
SET price = REPLACE(price,'$','') WHERE price IS NOT NULL;

--2nd Step
UPDATE "Calendar" 
SET price = REPLACE(price,',','') WHERE price IS NOT NULL;

--3rd Step 
ALTER TABLE "Calendar" 
ALTER COLUMN price TYPE numeric(10,0) using price::numeric;
 
--=======================For adjusted_price===========================
UPDATE "Calendar" 
SET adjusted_price = REPLACE(adjusted_price,'$','') WHERE adjusted_price IS NOT NULL;

--2nd Step
UPDATE "Calendar" 
SET adjusted_price = REPLACE(adjusted_price,',','') WHERE adjusted_price IS NOT NULL;

--3rd Step 
ALTER TABLE "Calendar" 
ALTER COLUMN adjusted_price TYPE numeric(10,0) using adjusted_price::numeric;
--=======================For available==================================
--1st Step 
ALTER TABLE "Calendar"
ALTER COLUMN available TYPE boolean USING available::boolean
