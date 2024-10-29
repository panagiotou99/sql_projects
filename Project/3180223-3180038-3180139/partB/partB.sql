--1st: To get "movies_per_year":
SELECT date_trunc('year',release_date) AS year_released,count(1) AS movies_per_year
FROM "Movies_Metadata" 
WHERE date_trunc('year', release_date) IS NOT NULL 
GROUP BY 1 
ORDER BY date_trunc('year',release_date)

/* On the postgres shell we run: 
\copy x TO '/Users/peter/downloads/movies_per_year.csv' DELIMITER ',' CSV HEADER; 
where x is the query above.
(or we could just download it with pgadmin when we run the query)
Then we make the neccesary changes to the csv file, which means deleting the '-01-01 00:00:00+00' part.
We format the .csv into an Excel file.
Now we can make our graph."
*/ 

-----2nd: To get "movies_per_genre"---
ALTER TABLE "Movies_Metadata" ADD new_genres text;
UPDATE "Movies_Metadata" SET new_genres = genres;

UPDATE "Movies_Metadata" SET new_genres = REPLACE(new_genres,'[', '{');
UPDATE "Movies_Metadata" SET new_genres = REPLACE(new_genres,']', '}');

CREATE TABLE Temp_Genres AS (SELECT UNNEST(new_genres::text[]) AS genre_text,id AS movie_id FROM "Movies_Metadata");

CREATE Table Temp_Genres2 AS (SELECT movie_id,genre_text FROM Temp_Genres WHERE genre_text LIKE '%name%');
UPDATE Temp_Genres2 SET genre_text= REPLACE(REPLACE(genre_text,E'\'',''),'name:','');

SELECT T.genre_text as Genre,COUNT(1) AS Movies_Per_Genre
FROM Temp_Genres2 T
JOIN "Movies_Metadata" M
ON M.id=t.movie_id
GROUP BY 1
/* 
To be quick, we just copy and paste the query results into an excel file.
Now we can make our graph."
*/ 

--3rd: To get "movies_per_genre_and_year"
SELECT date_trunc('year',release_date) AS year_released, genre_text, COUNT(id)
FROM "Movies_Metadata" M
JOIN Temp_Genres2 T
ON M.id=T.movie_id
WHERE date_trunc('year',release_date) IS NOT NULL
GROUP BY year_released,genre_text
ORDER BY year_released
/*
Using pgAdmin we export the .csv file.
We replace the '-01-01 00:00:00+00' part from the year_released column in notepad++.
Then we form it as a table in excel.
Now we can make our graph.
*/

/*4th: To get "average_rating_per_genre", there are two ways. One, gets the average from the ratings of the users:
 
SELECT T.genre_text as Genre,ROUND(AVG(R.rating),1) AS Average_Rating_Per_Genre
FROM Temp_Genres2 T
JOIN "Ratings" R
ON R.movieId=t.movie_id
GROUP BY T.genre_text

But the data we get isn't very reliable. 
*/ 
--The other one is to get it based on the votes on "Movies_Metadata" so we have:
SELECT T.genre_text as Genre,ROUND(AVG(M.vote_average::numeric),2) AS Average_Rating_Per_Genre
FROM Temp_Genres2 T
JOIN "Movies_Metadata" M
ON M.id=t.movie_id 
GROUP BY T.genre_text
/* 
To be quick, we just copy and paste the query results into an excel file.
Now we can make our graph."
*/ 

--Now we are dropping the tables we are not going to need anymore.
ALTER TABLE "Movies_Metadata" DROP COLUMN new_genres;
DROP TABLE Temp_Genres;
DROP TABLE Temp_Genres2;

--5th: To get "count_ratings_per_user" 
SELECT R.userid,COUNT(1) AS count_ratings_per_user
FROM "Movies_Metadata" M
JOIN "Ratings" R
ON R.movieId=M.id
GROUP BY 1
ORDER BY R.userid
/* 
To be quick, we just copy and paste the query results into an excel file.
Now we can make our graph."
*/ 

--6th: To get "average_ratings_per_user": 
SELECT R.userid,ROUND(AVG(R.rating),1) AS average_rating_per_user
FROM "Movies_Metadata" M
JOIN "Ratings" R
ON R.movieId=M.id
GROUP BY R.userid
ORDER BY R.userid
/* 
To be quick, we just copy and paste the query results into an excel file.
Now we can make our graph."
*/ 

--Lastly, let's create the view table

CREATE VIEW UserInfo AS
SELECT R.userid,COUNT(1) AS count_ratings_per_user , ROUND(AVG(R.rating),1) AS average_rating_per_user
FROM "Movies_Metadata" M
JOIN "Ratings" R
ON R.movieId=M.id
GROUP BY R.userid
ORDER BY R.userid

/*The insight we get from this relation is : How big or small the average ratings of the users can get is depending on the amount of their ratings. This makes us able to see how strict their judgmenet is. For example, a user with an average vote of 5.0 and 3000 ratings means they are objective. However, if a user has made 100 ratings and his average vote is 2.0, it means that they are very subjective and there are very few movies they actually like.

Η πληροφορία που παίρνουμε απο αυτή τη σχέση είναι: Το πόσο μεγάλος ή μικρός είναι ο μέσος όρος βαθμολογίας των χρηστών βασίζεται στο πόσες ταινίες έχουν ψηφίσει. Έτσι έχουμε τη δυνατότητα να δούμε ποσο αυστηροί είναι με τη βαθμολογία. Για παράδειγμα, ένας χρήστης που έχει μέση βαθμολογία 5.0 και 3000 ψήφους , πάει να πει πως είναι αντικειμενικός. Άντιθετα, ένας άλλος χρήστης που έχει κάνει 100 κριτικές και η μέση βαθμολογία του είναι 2.0, είναι πιθανότητα πολύ υποκειμενικός και υπάρχουν πολύ λίγες (ως και καμία) ταινία που όντως του αρέσουν. 
*/