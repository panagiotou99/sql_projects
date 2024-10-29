--Part 1 of assignment

/* 
1st Step: Create a new table, with a single column for now, which is going to consist of the 'amenities' column from "Room" . The data will be taken from SQL array (hence why we're using UNNEST(...). We use distinct, which means we want no duplicates.
*/
CREATE TABLE "Amenity" AS(
	SELECT DISTINCT UNNEST(amenities::text[]) AS amenity_name FROM "Room" 
);

/*
2nd Step: We're going to need a new column, which is going to be called "amenity_id" and it's going to be the primary key of 
our table. We're using the keyword SERIAL to automatically generate unique integer numbers (auto-increment) for a column.
*/
ALTER TABLE "Amenity"
ADD COLUMN amenity_id SERIAL PRIMARY KEY;

/*
3rd Step: We create a new table called "Room_Amenity_Connection" to properly connect the "Room" and "Amenity" table. 
*/
CREATE TABLE "Room_Amenity_Connection" AS(
	SELECT DISTINCT temp.room_id,"Amenity".amenity_id AS amenity_id FROM "Amenity",
		(SELECT "Room".listing_id AS room_id ,UNNEST(amenities::text[]) AS amenity_name FROM "Room" ) AS temp
	WHERE temp.amenity_name = "Amenity".amenity_name);
	
/*
4rth Step: Add a primary key to "Room" table to make the connection possible 
*/
ALTER TABLE "Room"
ADD PRIMARY KEY (listing_id);

/*
5th Step: Add a primary key to "Room_Amenity_Connection" table 
*/	
ALTER TABLE "Room_Amenity_Connection"
ADD PRIMARY KEY(room_id,amenity_id);

/*
6th Step: Add foreign key to "Room_Amenity_Connection" table 
*/
ALTER TABLE "Room_Amenity_Connection"
ADD FOREIGN KEY (room_id) REFERENCES "Room"(listing_id),
ADD FOREIGN KEY (amenity_id) REFERENCES "Amenity"(amenity_id);

/*
7th Step: Drop column 'amenities' from "Room" table
*/
ALTER TABLE "Room"
DROP COLUMN amenities;