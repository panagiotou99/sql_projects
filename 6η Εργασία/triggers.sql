/*We create two clone tables (will be deleted later) to test our triggers:
CREATE TABLE "Listing_Copy" AS TABLE "Listing";
CREATE TABLE "Host_Copy" AS TABLE "Host";
*/

--This function does exactly what was asked for in the instructions of the assigment 
CREATE FUNCTION update_listing_count()
	RETURNS TRIGGER AS 
	' 
	BEGIN
	IF TG_OP = ''DELETE'' THEN
		UPDATE "Host"
		SET listings_count = listings_count - 1
		WHERE id = OLD.host_id;
		RETURN OLD;
	ELSIF TG_OP = ''INSERT'' THEN
		UPDATE "Host"
		SET listings_count = listings_count + 1
		WHERE id = NEW.host_id;
		RETURN NEW;
	END IF;
	END;
	'
	LANGUAGE plpgsql;

CREATE TRIGGER updateHostTrigger
AFTER DELETE OR INSERT 
ON "Listing"
FOR EACH ROW
EXECUTE PROCEDURE update_listing_count();

/*
--With the following commands and using the copies we check if our trigger works correctly for DELETE :

SELECT * FROM "Listing_Copy" WHERE id = 10595;
--We see that host_id is 37177

SELECT listings_count FROM "Host_Copy" WHERE id=37177;
--We see that the listings_count of the host is 6

DELETE FROM "Listing_Copy" WHERE id = 10595;

SELECT listings_count FROM "Host_Copy" WHERE id=37177;
--We see that the listings_count of the host is 5.

--It works!
*/

/*
--With the following and using the copies commands we check if our trigger works correctly for INSERT : 

SELECT listings_count FROM "Host_Copy" WHERE id=37177;
--We see that the listing_count of the host is 5

INSERT INTO "Listing_Copy"(id,host_id) VALUES (123456,37177);

SELECT listings_count FROM "Host_Copy" WHERE id=37177;
--We see that the listing_count of the host is 6 

--It works as well! 
*/


/* If we don't want to use our function anymore we will run the following command:
DROP FUNCTION update_listing_count() CASCADE;
*/


/*
Our trigger works as follows : when a new review is inserted/deleted into Review
then the number of reviews in the table Listing is automatically incremented/decremented.
*/

/*
CREATE TABLE "Review_Copy" AS TABLE "Review";
*/

CREATE FUNCTION update_review_number()
	RETURNS TRIGGER AS
	'BEGIN
	IF TG_OP = ''DELETE'' THEN
		UPDATE "Listing"
		SET number_of_reviews = number_of_reviews - 1
		WHERE id = OLD.listing_id;
		RETURN OLD;
	ELSIF TG_OP = ''INSERT'' THEN
		UPDATE "Listing"
		SET number_of_reviews = number_of_reviews + 1
		WHERE id = NEW.listing_id;
		RETURN NEW;
	END IF;
	END;'
	LANGUAGE plpgsql;
	
CREATE TRIGGER updateNumberReviews AFTER DELETE OR INSERT ON "Review"
FOR EACH ROW
EXECUTE PROCEDURE update_review_number();

/*
--With the following commands and using the copies we check if our trigger works correctly for DELETE :

SELECT number_of_reviews FROM "Listing_Copy" WHERE id = 10993;
--We see that number_of_reviews are 48

SELECT * FROM "Review_Copy" WHERE listing_id=10993;
--Let's say we want to delete the review with id=57744044

DELETE FROM "Review_Copy" WHERE id = 57744044;

SELECT number_of_reviews FROM "Listing_Copy" WHERE id = 10993;
--We see that number_of_reviews has become 47
--It works!
*/

/*
--With the following commands and using the copies we check if our trigger works correctly for INSERT :

SELECT number_of_reviews FROM "Listing_Copy" WHERE id = 10990;
--We see that number_of_reviews are 34

INSERT INTO "Review_Copy"(id,listing_id) VALUES (333333333,10990);
--We add a new review regarding the listing with id=10990

SELECT number_of_reviews FROM "Listing_Copy" WHERE id = 10990;
--We see that number_of_reviews has become 35
--It works as well!
*/

/*
If we don't want to use our function anymore we will run the following command:
DROP FUNCTION update_review_number() CASCADE;
*/

/* 
DROP TABLE "Listing_Copy";
DROP TABLE "Host_Copy";
DROP TABLE "Review_Copy";
*/ 