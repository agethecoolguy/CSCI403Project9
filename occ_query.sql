
DROP TABLE IF EXISTS corrtable;

CREATE TABLE corrtable (
	off_code integer,
	off_code_ext integer,
	occ_hour integer
);

INSERT INTO corrtable(off_code, off_code_ext, occ_hour)
	(SELECT off_code, off_code_ext, EXTRACT(HOUR FROM first_occ_date) FROM crime GROUP BY off_code, off_code_ext, first_occ_date);

/*This returns the off_code, name, and amount of occurences of that incident before 4am and after 8pm*/
SELECT c.off_code, c.off_type_name, count(*) 
FROM codes AS c, corrtable AS ct
WHERE (ct.occ_hour <= 4 OR ct.occ_hour >= 20) AND ct.off_code = c.off_code AND ct.off_code_ext = c.off_code_ext
GROUP BY c.off_code, c.off_type_name 
ORDER BY count(*) DESC 
LIMIT 15;

/*This returns the off_code, name, and amount of occurences of that incident between 4am and 8pm*/
SELECT c.off_code, c.off_type_name, count(*) 
FROM codes AS c, corrtable AS ct
WHERE (ct.occ_hour > 4 AND ct.occ_hour < 20) AND ct.off_code = c.off_code AND ct.off_code_ext = c.off_code_ext
GROUP BY c.off_code, c.off_type_name 
ORDER BY count(*) DESC 
LIMIT 15;

/*counts the occurences in the timess respectively*/
SELECT 'd count: ' || count(*) FROM corrtable
WHERE occ_hour > 4 AND occ_hour < 20;

SELECT 'n count: ' || count(*) FROM corrtable
WHERE occ_hour <= 4 OR occ_hour >= 20;



/*Quick comparison of equal hour lengths*/
SELECT 'Early Morning(12-8am): ' || count(*) FROM corrtable
WHERE occ_hour < 8 AND occ_hour >= 0;

SELECT 'Mid-day(8am-4pm) count: ' || count(*) FROM corrtable
WHERE occ_hour >= 8 AND occ_hour < 16;

SELECT 'Night(4pm-12am): ' || count(*) FROM corrtable
WHERE occ_hour > 16 AND occ_hour < 24;


/*Which hour of the day has the most crimes*/
SELECT c.occ_hour, count(*)
FROM corrtable AS c
GROUP BY c.occ_hour
ORDER BY count(*) DESC
LIMIT 5;

/*Which hour has the most 'Window Peeping' tickets*/
SELECT c.off_type_name, ct.occ_hour, count(*)
FROM codes AS c, corrtable AS ct
WHERE 'Window Peeping' = c.off_type_name AND ct.off_code = c.off_code AND ct.off_code_ext = c.off_code_ext
GROUP BY c.off_type_name, ct.occ_hour
ORDER BY count(*) DESC
LIMIT 5;
