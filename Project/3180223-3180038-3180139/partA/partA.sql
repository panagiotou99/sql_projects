--First we are going to create our starter tables so we can fill them up with all the information there is in the .csv files

CREATE TABLE "CreditsTemp"(
"cast" VARCHAR(100000), --ex: "[{'cast_id': 14, 'character': 'Woody (voice)', 'credit_id': '52fe4284c3a36847f8024f95', 'gender': 2, 'id': 31, 'name': 'Tom Hanks', 'order': 0, 'profile_path': '/pQFoyx7rp09CJTAb932F2g8Nlho.jpg'}, {'cast_id': 15, 'character': 'Buzz Lightyear (voice)', 'credit_id': '52fe4284c3a36847f8024f99', 'gender': 2, 'id': 12898, 'name': 'Tim Allen', 'order': 1, 'profile_path': '/uX2xVf6pMmPepxnvFWyBtjexzgY.jpg'}, ...]"
crew VARCHAR(100000), --ex: "[{'credit_id': '52fe4284c3a36847f8024f49', 'department': 'Directing', 'gender': 2, 'id': 7879, 'job': 'Director', 'name': 'John Lasseter', 'profile_path': '/7EdqiNbr4FRjIhKHyPPdFfEEEFG.jpg'}, {'credit_id': '52fe4284c3a36847f8024f4f', 'department': 'Writing', 'gender': 2, 'id': 12891, 'job': 'Screenplay', 'name': 'Joss Whedon', 'profile_path': '/dTiVsuaTVTeGmvkhcyJvKp2A5kr.jpg'}, ...]"
id INT --ex: 862
);

CREATE TABLE "KeywordsTemp"(
id INT, --ex: 862
keywords VARCHAR(10000) --ex: "[{'id': 931, 'name': 'jealousy'}, {'id': 4290, 'name': 'toy'}, {'id': 5202, 'name': 'boy'}, {'id': 6054, 'name': 'friendship'}, {'id': 9713, 'name': 'friends'}, {'id': 9823, 'name': 'rivalry'}, {'id': 165503, 'name': 'boy next door'}, {'id': 170722, 'name': 'new toy'}, {'id': 187065, 'name': 'toy comes to life'}]"
);

CREATE TABLE "LinksTemp"(
movieId INT, --ex: 1
imdbId INT, --ex: 0114709
tmdbId INT --ex: 862
);

CREATE TABLE "Movies_MetadataTemp"(
   adult BOOLEAN, --ex: FALSE
   belongs_to_collection VARCHAR(5000), --ex: "{'id': 10194, 'name': 'Toy Story Collection', 'poster_path': '/7G9915LfUQ2lVfwMEEhDsn3kT4B.jpg',...}"
   budget INT, --ex: 30000000
   genres VARCHAR(500), --ex: "[{'id': 16, 'name': 'Animation'}, {'id': 35, 'name': 'Comedy'},...]"
   homepage VARCHAR(5000), --ex: http://toystory.disney.com/toy-story,862,tt0114709
   id INT, --ex: 862
   imdb_id VARCHAR(10), --ex: tt0114709
   original_language VARCHAR(10), --ex: en
   original_title VARCHAR(5000), --ex: Toy Story
   overview VARCHAR(5000), --ex: "Led by Woody, Andy's toys live happily in his room..."
   popularity FLOAT, --ex: 21.946943
   poster_path VARCHAR(100), --ex: /rhIRbceoE9lR4veEXuwCC2wARtG.jpg
   production_companies VARCHAR(5000), --ex:  "[{'name': 'Pixar Animation Studios', 'id': 3}]"
   production_countries VARCHAR(5000), --ex: "[{'iso_3166_1': 'US', 'name': 'United States of America'}]"
   release_date DATE, --ex: 1995-10-30
   revenue BIGINT, --ex: 373554033
   runtime FLOAT, --ex: 81.0
   spoken_languages VARCHAR(5000), --ex: "[{'iso_639_1': 'en', 'name': 'English'}]"
   status VARCHAR(100), --ex: Released
   tagline VARCHAR(300), --ex: Get ready for this adventure!
   title VARCHAR(110), --ex: Toy Story
   video BOOLEAN, --ex: False 
   vote_average FLOAT, --ex: 7.7
   vote_count INT --ex: 5415
);

CREATE TABLE "RatingsTemp"(
userId INT, --ex: 1
movieId INT , --ex: 110
rating NUMERIC(10,2), --ex: 1.0
timestamp INT --ex: 1425941529
); 

/*
Then, we run the following commands on the postgres shell to insert the data into our temp tables: 
\copy "CreditsTemp" FROM 'credits.csv' DELIMITER ',' CSV HEADER;
\copy "KeywordsTemp" FROM 'keywords.csv' DELIMITER ',' CSV HEADER;
\copy "LinksTemp" FROM 'links.csv' DELIMITER ',' CSV HEADER;
\copy "Movies_MetadataTemp" FROM 'movies_metadata.csv' DELIMITER ',' CSV HEADER;
\copy "RatingsTemp" FROM 'ratings_small.csv' DELIMITER ',' CSV HEADER;
*/

--Now we create our real tables, while making sure no duplicates get on them
CREATE TABLE "Credits" AS SELECT DISTINCT * FROM "CreditsTemp";
CREATE TABLE "Keywords" AS SELECT DISTINCT * FROM "KeywordsTemp";
CREATE TABLE "Links" AS SELECT DISTINCT * FROM "LinksTemp";
CREATE TABLE "Movies_Metadata" AS SELECT DISTINCT * FROM "Movies_MetadataTemp";
CREATE TABLE "Ratings" AS SELECT * FROM "RatingsTemp";

--Making sure we following  the assigment's rules
DELETE FROM "Credits" WHERE id NOT IN (SELECT m.id FROM "Movies_Metadata" m)
DELETE FROM "Keywords" WHERE id NOT IN (SELECT m.id FROM "Movies_Metadata" m)
DELETE FROM "Links" WHERE tmdbId NOT IN (SELECT m.id FROM "Movies_Metadata" m)
DELETE FROM "Ratings" WHERE movieId NOT IN (SELECT m.id FROM "Movies_Metadata" m)

--There are some instances where two rows are having the same ids but different values in a single column, so the following queries solve this problem
DELETE FROM "Movies_Metadata" T1 USING "Movies_Metadata" T2 WHERE  T1.popularity < T2.popularity AND T1.id=T2.id;
DELETE FROM "Credits" T1 USING "Credits" T2 WHERE T1.crew < T2.crew AND T1.id=T2.id;

--Time to add primary keys 
ALTER TABLE "Credits" ADD PRIMARY KEY (id);
ALTER TABLE "Keywords" ADD PRIMARY KEY (id);
ALTER TABLE "Links" ADD PRIMARY KEY (movieId);
ALTER TABLE "Movies_Metadata" ADD PRIMARY KEY (id);
ALTER TABLE "Ratings" ADD PRIMARY KEY (userId,movieId);

--Time to add foreign keys
ALTER TABLE "Credits" ADD FOREIGN KEY (id) REFERENCES "Movies_Metadata"(id);
ALTER TABLE "Keywords" ADD FOREIGN KEY (id) REFERENCES "Movies_Metadata"(id);
ALTER TABLE "Links" ADD FOREIGN KEY (tmdbId) REFERENCES "Movies_Metadata"(id);
ALTER TABLE "Ratings" ADD FOREIGN KEY (movieId) REFERENCES  "Movies_Metadata"(id);

--Time to drop our starter tables
DROP TABLE "CreditsTemp";
DROP TABLE "KeywordsTemp";
DROP TABLE "LinksTemp";
DROP TABLE "Movies_MetadataTemp";
DROP TABLE "RatingsTemp";