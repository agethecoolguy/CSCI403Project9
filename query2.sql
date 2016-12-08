/* This query creates a table comparing the number of crime vs traffic related incidents at night vs during the day. */

DROP TABLE IF EXISTS day_night_incident_comparison;

CREATE TABLE day_night_incident_comparison(
	time_of_day text,
	violation_type text,
	num_incidents integer,
	PRIMARY KEY(time_of_day, violation_type)
);

INSERT INTO day_night_incident_comparison(time_of_day, violation_type, num_incidents)
	SELECT 'Day', 'Traffic', COUNT(*) FROM crime 
	WHERE off_code IN (SELECT off_code FROM codes WHERE is_traffic IS TRUE) 
		AND extract(hour from first_occ_date) >= 7 AND extract(hour from first_occ_date) <= 19;

INSERT INTO day_night_incident_comparison(time_of_day, violation_type, num_incidents)
	SELECT 'Day','Crime', COUNT(*) FROM crime 
	WHERE off_code IN (SELECT off_code FROM codes WHERE is_crime IS TRUE) 
		AND extract(hour from first_occ_date) >= 7 AND extract(hour from first_occ_date) <= 19;

INSERT INTO day_night_incident_comparison(time_of_day, violation_type, num_incidents)
	SELECT 'Night', 'Traffic', COUNT(*) FROM crime 
	WHERE off_code IN (SELECT off_code FROM codes WHERE is_traffic IS TRUE) 
		AND extract(hour from first_occ_date) <= 7 OR extract(hour from first_occ_date) >= 19;

INSERT INTO day_night_incident_comparison(time_of_day, violation_type, num_incidents)
	SELECT 'Night', 'Crime', COUNT(*) FROM crime 
	WHERE off_code IN (SELECT off_code FROM codes WHERE is_crime IS TRUE) 
		AND extract(hour from first_occ_date) <= 7 OR extract(hour from first_occ_date) >= 19;