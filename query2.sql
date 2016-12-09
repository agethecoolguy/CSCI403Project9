/* Table used to compare the magnitude of incidents per hour at different times of the day*/

DROP TABLE IF EXISTS incident_comparison;
CREATE TABLE incident_comparison(
	time_of_day text,
	violation_type text,
	incidents_per_hour integer,
	PRIMARY KEY(time_of_day, violation_type)
);
/* The following queries are used to insert data into the table.*/
INSERT INTO incident_comparison(time_of_day, violation_type, incidents_per_hour)
	SELECT 'ALL', 'ALL', COUNT(*)/24 FROM crime;

INSERT INTO incident_comparison(time_of_day, violation_type, incidents_per_hour)
	SELECT 'Day', 'ALL', COUNT(*)/10 FROM crime 
	WHERE extract(hour from first_occ_date) >= 10 AND extract(hour from first_occ_date) <= 20;

INSERT INTO incident_comparison(time_of_day, violation_type, incidents_per_hour)
	SELECT 'Night', 'ALL', COUNT(*)/8 FROM crime 
	WHERE extract(hour from first_occ_date) <= 4 OR extract(hour from first_occ_date) >= 20;

INSERT INTO incident_comparison(time_of_day, violation_type, incidents_per_hour)
	SELECT 'Morning', 'ALL', COUNT(*)/6 FROM crime 
	WHERE extract(hour from first_occ_date) >= 4 AND extract(hour from first_occ_date) <= 10;

INSERT INTO incident_comparison(time_of_day, violation_type, incidents_per_hour)
	SELECT 'Drinking', 'ALL', COUNT(*)/9 FROM crime 
	WHERE extract(hour from first_occ_date) >= 15;

INSERT INTO incident_comparison(time_of_day, violation_type, incidents_per_hour)
	SELECT 'Non-Drinking', 'ALL', COUNT(*)/4 FROM crime 
	WHERE extract(hour from first_occ_date) >= 11 AND extract(hour from first_occ_date) <= 15;

INSERT INTO incident_comparison(time_of_day, violation_type, incidents_per_hour)
	SELECT 'Drinking', 'Alcohol-Related', COUNT(*)/9 FROM crime 
	WHERE off_code IN (SELECT off_code FROM codes WHERE off_type_name = 'Manufacture of liquor' 
		OR off_type_name = 'Illegal sale of liquor' OR off_type_name = 'Illegal possession of liquor' 
		OR off_type_name = 'Liquor law violation' OR off_type_name = 'Liquor law violation - other' 
		OR off_type_name = 'Public intoxication') 
		AND extract(hour from first_occ_date) >= 15;

INSERT INTO incident_comparison(time_of_day, violation_type, incidents_per_hour)
	SELECT 'Non-Drinking', 'Alcohol-Related', COUNT(*)/4 FROM crime 
	WHERE off_code IN (SELECT off_code FROM codes WHERE off_type_name = 'Manufacture of liquor' 
		OR off_type_name = 'Illegal sale of liquor' OR off_type_name = 'Illegal possession of liquor' 
		OR off_type_name = 'Liquor law violation' OR off_type_name = 'Liquor law violation - other' 
		OR off_type_name = 'Public intoxication') 
		AND extract(hour from first_occ_date) >= 11 AND extract(hour from first_occ_date) <= 15;

