
DROP TABLE IF EXISTS corrtable;

CREATE TABLE corrtable (
	off_code integer,
	occ_hour integer
);

INSERT INTO corrtable(off_code, occ_hour)
	(SELECT off_code, EXTRACT(HOUR FROM first_occ_date) FROM crime GROUP BY off_code, first_occ_date);

/*This return the off_code that shows up the most between 8pm and 4am*/
SELECT off_code, count(off_code) FROM corrtable WHERE occ_hour < 4 OR occ_hour > 20 GROUP BY off_code ORDER BY count(off_code) DESC;


/*I'm tired af, so I'm gonna continue this tomorrow but I'll basically query the opposite. I may get fancy and actually go into the extension but we will see. I want it to reference the crime table to show the name not the code persay.. yay gnight nerds*/
