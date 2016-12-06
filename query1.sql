/* This query compares the number of liquor stores with crimes by police district */
DROP TABLE IF EXISTS cps;
CREATE TABLE cps(
	district integer, num_incidents integer, num_stores integer
);

INSERT INTO cps(district, num_incidents, num_stores)
	(SELECT dist_id, n_i, n_s FROM
		(SELECT dist_id, count(*) as n_i FROM crime GROUP BY dist_id) as incidents,
		(SELECT police_dist, count(*) as n_s FROM liquor_locations GROUP BY police_dist) as stores
	WHERE dist_id=police_dist
	ORDER BY dist_id);

SELECT cps.district, num_incidents, num_stores, incidents_per_store FROM cps, (SELECT district, num_incidents / num_stores as incidents_per_store FROM cps) as ips WHERE cps.district=ips.district;