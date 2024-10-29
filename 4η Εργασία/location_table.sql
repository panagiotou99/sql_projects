--1st Step: Creation of "Location" table 
CREATE TABLE "Location" AS
(SELECT DISTINCT
id as listing_id,
street,
neighbourhood,
neighbourhood_cleansed,
city,
state,
zipcode,
market,
smart_location,
country_code,
country,
latitude,
longitude,
is_location_exact
FROM "Listings");

--2nd Step: Delete the fields from "Listings" we don't need 
ALTER TABLE "Listings"
DROP COLUMN street,
DROP COLUMN neighbourhood,
DROP COLUMN neighbourhood_cleansed,
DROP COLUMN city,
DROP COLUMN state,
DROP COLUMN zipcode,
DROP COLUMN market,
DROP COLUMN smart_location,
DROP COLUMN country_code,
DROP COLUMN country,
DROP COLUMN latitude,
DROP COLUMN longitude,
DROP COLUMN is_location_exact

--3rd Step: Add a foreign key to "Location" table 
ALTER TABLE "Location"
ADD FOREIGN KEY (listing_id) REFERENCES "Listings"(id)

/*--4th Step: Using the following query , we're going to get the name of the FK constraint
SELECT CONSTRAINT_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'Listings'

It is "Listings_neighbourhood_cleansed_fkey" 
*/

--5th Step: Delete the relation of "Listings" table with the "Neighbourhoods" table 
ALTER TABLE "Listings"
DROP CONSTRAINT "Listings_neighbourhood_cleansed_fkey";

--6th Step: Add a foreign key to "Location" table
ALTER TABLE "Location"
ADD FOREIGN KEY (neighbourhood_cleansed) REFERENCES "Neighbourhoods"(neighbourhood);