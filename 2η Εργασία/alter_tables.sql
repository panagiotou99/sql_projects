BEGIN;
ALTER TABLE "Calendar"
ADD FOREIGN KEY (listing_id) REFERENCES "Listings"(id);

ALTER TABLE "Neighbourhoods"
ADD FOREIGN KEY (neighbourhood) REFERENCES "Geolocation"(properties_neighbourhood);

ALTER TABLE "Reviews"
ADD FOREIGN KEY (listing_id) REFERENCES "Listings"(id);

ALTER TABLE "Listings"
ADD FOREIGN KEY (neighbourhood_cleansed) REFERENCES "Neighbourhoods"(neighbourhood);

ALTER TABLE "Listings-Summary"
ADD FOREIGN KEY(id) REFERENCES "Listings"(id);

ALTER TABLE "Reviews-Summary"
ADD FOREIGN KEY (listing_id) REFERENCES "Listings"(id);

COMMIT;