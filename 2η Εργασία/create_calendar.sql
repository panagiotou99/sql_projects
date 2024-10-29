CREATE TABLE "Calendar" (
    listing_id INT, -- e.x : 251361
	date DATE, -- e.x : 2020-03-18
	available VARCHAR(1), -- e.x : t for true / f for false 
	price VARCHAR(10), -- e.x : $136.00
	adjusted_price VARCHAR(10), -- e.x : $136.00
	minimum_nights INT, -- e.x : 5
	maximum_nights INT, -- e.x : 365
	PRIMARY KEY (listing_id, date) 
);

