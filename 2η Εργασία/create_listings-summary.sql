CREATE TABLE "Listings-Summary"(
   id INT, -- ex : 10990
   name VARCHAR(100), -- ex: Athens Quality Apartments - Deluxe Apartment
   host_id INT, -- ex: 37177
   host_name VARCHAR(40), --ex: Emmanouil
   neighbourhood_group VARCHAR(10), 
   neighbourhood VARCHAR(40), --ex: ΑΜΠΕΛΟΚΗΠΟΙ
   latitude VARCHAR(10), -- ex: 37.98888
   longitude VARCHAR(10), -- ex: 23.76473
   room_type VARCHAR(20), -- ex: Entire home/apt
   price INT, -- ex: 39
   minimum_nights INT, --ex: 1
   number_of_reviews INT, --ex: 48 
   last_review DATE, --ex: 2020-01-17
   reviews_per_month VARCHAR(10), --ex: 0.53
   calculated_host_listings_count INT, --ex: 6
   availability_365 INT, --ex: 347
   PRIMARY KEY (id)
);