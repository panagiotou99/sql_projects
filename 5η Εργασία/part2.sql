--Part 2 of assignment

/*
Find all ids,URLs and names of hosts who reside in the Attiki region , plus all of their listings (id and price only)
The output is sorted by the price of the listings. 
This could be searched by someone who wants to stay in the Attiki region and check prices in that area, but also by 
someone who is interested in hosting and wants to see the price range. 
Output : 284 rows
*/

SELECT h.id as Host_Id,h.url as Host_URL,h.name as Host_Name,li.id as Listing_Id, pr.price as Listing_Price
FROM "Host" h 
LEFT OUTER JOIN "Listing" li 
ON li.host_id = h.id
LEFT OUTER JOIN "Price" pr
ON li.id = pr.listing_id
WHERE h.neighbourhood = 'Attiki' AND price IS NOT NULL
GROUP BY h.id,h.name,pr.price,li.id
ORDER BY pr.price ASC;


/*
Find all room ids,prices and their respective neighbourhoods and zipcodes which can accommodate 2 people.
This could be searched by a couple who want to find a house in Greece and a space of 2 accommodates is enough for them.
Output : 2868 rows
*/
SELECT r.listing_id,r.price,l.neighbourhood,l.zipcode
FROM "Room" r
LEFT OUTER JOIN "Location" l
ON r.listing_id = l.listing_id
WHERE r.accommodates = 2
GROUP BY r.listing_id,l.neighbourhood,l.zipcode;

/*
Find all house ids , their neighbourhoods and their prices where the price is 50 euros or above.
This could be searched by someone who wants a specific price range to choose from (Sometimes a higher price range
means that the house could be better in terms of quality, having more space etc).
Output :  5562 rows
*/
SELECT pr.listing_id,l.neighbourhood,pr.price
FROM "Price" pr
INNER JOIN "Location" l
ON pr.listing_id = l.listing_id
GROUP BY pr.listing_id,pr.price,l.neighbourhood
HAVING pr.price >= 50;

/*
Find all house ids,prices and max nights where the maximum nights are above 30 days. 
This could be searched by someone who wants to rent a house for a month or more.
Output : 9121 rows
*/
SELECT r.listing_id,pr.price,pr.maximum_nights
FROM "Room" r
INNER JOIN "Price" pr
ON r.listing_id = pr.listing_id
GROUP BY r.listing_id,pr.price,pr.maximum_nights
HAVING pr.maximum_nights > 30;

/*
Find all house ids and their respective neighbourhoods based on a set of coordinates.
This could be searched by someone who wants to live in a very specific part in Athens and calculate it via coordinates (if for example he uses a google maps plugin) 
Output : 598 rows 
*/
SELECT l.listing_id,geo.properties_neighbourhood
FROM "Location" l
INNER JOIN "Geolocation" geo
ON l.neighbourhood_cleansed = geo.properties_neighbourhood
WHERE geo.geometry_coordinates_0_0_11_0 BETWEEN '23.760000' AND '23.788416' 
AND geo.geometry_coordinates_0_0_11_1 BETWEEN '37.956254' AND '38.000000';