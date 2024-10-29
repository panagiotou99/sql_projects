-- QUERY 1 --
EXPLAIN ANALYZE
SELECT "Host".id, COUNT(*) 
FROM "Listing", "Host" 
WHERE "Host".id="Listing".host_id 
GROUP BY "Host".id;

CREATE INDEX hostIdIndex ON "Listing"(host_id);
DROP INDEX hostIdIndex;

-- QUERY 2 -- 
EXPLAIN ANALYZE
SELECT id, price 
FROM "Listing", "Price" 
WHERE "Listing".guests_included > 5 AND "Price".price > 40;

CREATE INDEX priceIndex ON "Price"(price);
DROP INDEX priceIndex;

-- QUERY 3 --

EXPLAIN ANALYZE
SELECT h.id as Host_Id,h.url as Host_URL,h.name as Host_Name,li.id as Listing_Id, pr.price as Listing_Price
FROM "Host" h 
LEFT OUTER JOIN "Listing" li 
ON li.host_id = h.id
LEFT OUTER JOIN "Price" pr
ON li.id = pr.listing_id
WHERE h.neighbourhood = 'Attiki' AND price IS NOT NULL
GROUP BY h.id,h.name,pr.price,li.id
ORDER BY pr.price ASC;

CREATE INDEX hostIdIndex ON "Listing"(host_id);
DROP INDEX hostIdIndex;



-- QUERY 4 --

EXPLAIN ANALYZE
SELECT r.listing_id,r.price,l.neighbourhood,l.zipcode
FROM "Room" r
LEFT OUTER JOIN "Location" l
ON r.listing_id = l.listing_id
WHERE r.accommodates = 2
GROUP BY r.listing_id,l.neighbourhood,l.zipcode;

SELECT * FROM "Room" LIMIT 100;
SELECT * FROM "Location" LIMIT 100;

CREATE INDEX  roomAccomIndex ON "Room"(accommodates);
DROP INDEX roomAccomIndex;

-- QUERY 5 -- 

EXPLAIN ANALYZE
SELECT pr.listing_id,l.neighbourhood,pr.price
FROM "Price" pr
INNER JOIN "Location" l
ON pr.listing_id = l.listing_id
GROUP BY pr.listing_id,pr.price,l.neighbourhood
HAVING pr.price >= 50;

CREATE INDEX priceIndex ON "Price"(price);
DROP INDEX priceIndex;


-- QUERY 6 --

EXPLAIN ANALYZE 
SELECT r.listing_id,pr.price,pr.maximum_nights
FROM "Room" r
INNER JOIN "Price" pr
ON r.listing_id = pr.listing_id
GROUP BY r.listing_id,pr.price,pr.maximum_nights
HAVING pr.maximum_nights > 30;

CREATE INDEX maxNightsIndex ON "Price"(maximum_nights);
DROP INDEX maxNightsIndex;


-- QUERY 7 --

EXPLAIN ANALYZE
SELECT l.listing_id,geo.properties_neighbourhood
FROM "Location" l
INNER JOIN "Geolocation" geo
ON l.neighbourhood_cleansed = geo.properties_neighbourhood
WHERE geo.geometry_coordinates_0_0_11_0 BETWEEN '23.760000' AND '23.788416' 
AND geo.geometry_coordinates_0_0_11_1 BETWEEN '37.956254' AND '38.000000';

CREATE INDEX geoIndex ON "Geolocation"(properties_neighbourhood);
DROP INDEX geoIndex;
