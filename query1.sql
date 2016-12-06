/* This query compares the number of liquor stores with crimes by police district */
DROP TABLE IF EXISTS cps;
DROP TABLE IF EXISTS acps;
CREATE TABLE cps(
	district integer, num_incidents integer, num_stores integer
);
CREATE TABLE acps(
	district integer, num_alc_incidents integer, num_stores integer
);

INSERT INTO cps(district, num_incidents, num_stores)
	(SELECT dist_id, n_i, n_s FROM
		(SELECT dist_id, count(*) as n_i
			FROM crime 
			GROUP BY dist_id) as incidents,
		(SELECT police_dist, count(*) as n_s
			FROM liquor_locations
			GROUP BY police_dist) as stores
	WHERE dist_id=police_dist
	ORDER BY dist_id);

	
/* Compare the number of crimes to the number of stores */
SELECT cps.district, num_incidents, num_stores, incidents_per_store FROM cps, (SELECT district, num_incidents / num_stores as incidents_per_store FROM cps) as ips WHERE cps.district=ips.district;

INSERT INTO acps(district, num_alc_incidents, num_stores)
	(SELECT dist_id, n_ai, n_s FROM
		(SELECT dist_id, count(*) as n_ai
			FROM crime
			WHERE (crime.off_code, crime.off_code_ext) in (SELECT off_code, off_code_ext FROM codes WHERE off_cat_id LIKE '%drug%')
			GROUP BY dist_id) as alc_incidents,
		(SELECT police_dist, count(*) as n_s
			FROM liquor_locations
			GROUP BY police_dist) as stores
	WHERE dist_id=police_dist
	ORDER BY dist_id);

/* Compare the number of drug related incidents to the number of stores */
SELECT acps.district, num_alc_incidents, num_stores, incidents_per_store FROM acps, (SELECT district, num_alc_incidents / num_stores as incidents_per_store FROM acps) as aips WHERE acps.district=aips.district;