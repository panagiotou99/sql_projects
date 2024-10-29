/* #1 Query 
Output: 480 rows
Description: Shows all the hosts that have at least a house listed in Ampelokipoi.
This may be useful for users to ask hosts about area related questions*/
SELECT DISTINCT L.host_id, L.host_url, L.host_name
FROM "Listings" L 
WHERE L.neighbourhood='Ambelokipi';

/* #2 Query 
Output: 531 rows
Description: Shows the id of the apartments in Ampelokipoi where maximum nights somebody can stay are more than 10 days. 
The listings are ordered from the one with the most bedrooms to the one with the least.
Τhis is needed if a user only cares about staying there for 10 days or more */
SELECT L.id, L.maximum_nights , L.bedrooms
FROM "Listings" L
WHERE  L.neighbourhood='Ambelokipi' AND L.maximum_nights>10 AND L.bedrooms>=1
ORDER BY L.bedrooms DESC;

/* #3 Query
Output: 3859 rows
Description: Shows the id of the listings that reviewers have recommended the most times in their comments, using the keyword "Highly recommended". It's a usual phrase you see in any kind of review and this is why we're using it. 
This is needed if somebody looks for a destination only caring about the quality of the house they want to stay */
SELECT R.listing_id, Count(R.comments)
FROM "Reviews" R 
WHERE comments LIKE '%highly recommended%' OR comments LIKE '%Highly recommended%'
GROUP BY (R.listing_id)
ORDER BY Count(R.comments) DESC;

/* #4 Query 
Output: 45 rows
Description: For each neighbourhood this query shows the minimum and maximu price you can rent a house in the area */
SELECT LS.neighbourhood,
MAX(LS.price::numeric) AS Most_Expensive_Listing,
MIN(LS.price::numeric) AS Least_Expensive_Listing
FROM "Listings-Summary" LS
WHERE LS.PRICE>0
GROUP BY (LS.neighbourhood)
ORDER BY LS.neighbourhood;

/* #5 Query
Output: 395 rows
Description: Shows all the listings available for a specific day in Ampelokipoi.
This is needed if somebody just wants to stay in for a really short amount of time.*/
SELECT L.id , C.available
FROM "Listings" L 
INNER JOIN "Calendar" C 
ON L.id = C.listing_id
WHERE L.neighbourhood='Ambelokipi' AND C.date = '2020-04-16' AND C.available='t';


/* #6 Query 
Output: 100 rows , 4906 without limitation 
Description: Shows the top 100 listings which have been reviewed the most in 2020, ordering them from most reviews to least 
*/
SELECT L.id, Count(RS.listing_id) AS No_Reviews_2020
FROM "Listings" L
INNER JOIN "Reviews-Summary" RS 
ON L.id=RS.listing_id
WHERE RS.date > '2020-1-1'
GROUP BY (L.id)
ORDER BY No_Reviews_2020 DESC
LIMIT 100;

/* #7 Query 
Output: 10 rows, 45 without limitation
Description: Shows the top 10 cheapest neighbourhoods to stay in */
SELECT LS.neighbourhood, ROUND(AVG(LS.price::numeric),2) AS average_price_of_neighbourhood
FROM "Listings-Summary" LS
INNER JOIN "Neighbourhoods" N
ON LS.neighbourhood=N.neighbourhood
GROUP BY (LS.neighbourhood)
ORDER BY average_price_of_neighbourhood ASC
LIMIT 10;

/* #8 Query 
Output: 4614 rows
Description: Shows all houses that are contained in the area specified by the coordinates.
This could be searched by someone who wants to rent a house at a very specific location inside an area
Output : 4614 rows*/
SELECT L.id , GEO.properties_neighbourhood
FROM "Listings" L
INNER JOIN "Geolocation" GEO
ON GEO.properties_neighbourhood = L.neighbourhood_cleansed
WHERE GEO.geometry_coordinates_0_0_29_0 BETWEEN '23.724727' AND '23.744308' 
AND GEO.geometry_coordinates_0_0_29_1 BETWEEN '37.968134' AND '38.015347';
*/

/* #9 Query 
Output: 45 rows
Description: Shows the amounts of listings per neighbourhood */
SELECT N.neighbourhood, COUNT(L.neighbourhood_cleansed) AS Number_Of_Listings
FROM "Neighbourhoods" N
INNER JOIN "Listings" L
ON N.neighbourhood=L.neighbourhood_cleansed
GROUP BY (N.neighbourhood)
ORDER BY Number_Of_Listings DESC;

/* #10 Query 
Output: 45 rows
Description: Find the average number of bedrooms in each area's houses.
A person could search this to see which area has bigger houses than others in order to narrow down his search of houses in that area.
*/

SELECT N.neighbourhood,ROUND(AVG(bedrooms))
FROM "Listings" L
JOIN "Neighbourhoods" N
ON N.neighbourhood = L.neighbourhood_cleansed
GROUP BY N.neighbourhood;
				 
/* #11 Query 
Output: 3 rows 
Description: Shows all the listings a specific user has left a review for 

*/
SELECT R.reviewer_id, R.reviewer_name, L.* 
FROM "Reviews" R
FULL OUTER JOIN "Listings" L
ON R.listing_id=L.id
WHERE R.reviewer_id = 46799390 ;

/* #12 Query 
Output : 1 row
Description: Shows the number of reviews that have been made for listings in Ampelokipoi up until now this year 
*/
SELECT COUNT(*) AS number_of_reviewers_with_no_name
FROM 
(SELECT R.date, L.id , L.neighbourhood
FROM  "Reviews" R  LEFT OUTER JOIN  "Listings" L on R.listing_id = L.id) AS TEMP
WHERE (TEMP.date BETWEEN '2020-01-01' AND '2020-04-17') AND TEMP.neighbourhood='Ambelokipi'