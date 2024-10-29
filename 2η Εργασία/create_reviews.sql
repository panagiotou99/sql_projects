CREATE TABLE "Reviews"(
   listing_id INT, --ex: 10595
   id INT, -- ex: 271535
   date DATE, -- ex: 2011-05-20
   reviewer_id INT, -- ex: 189305
   reviewer_name VARCHAR(50), -- ex: Pamela
   comments TEXT, -- ex:"The apartment was wonderful, fully equiped..."
   PRIMARY KEY (id)
);