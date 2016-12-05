/*Get the data from http://data.opencolorado.org/dataset/city-and-county-of-denver-liquor-licenses */

DROP TABLE IF EXISTS liquor_locations_complete;
DROP TABLE IF EXISTS liquor_locations;

CREATE TABLE liquor_locations_complete (
	bfn text,
	store_name text,
	address text,
	license_type text,
	license_status text,
	issue_date timestamp with time zone,
	end_date timestamp with time zone,
	address_id double precision,
	address_line1 text,
	address_line2 text, 
	city text, 
	state text, 
	zip text,
	council_dist integer,
	police_dist integer,
	census_tract integer, 
	x_coord double precision,
	y_coord double precision,
	global_id text
);

\COPY liquor_locations_complete FROM 'data/liquor_licenses.csv' WITH (format csv, header true);

CREATE TABLE liquor_locations (
	bfn text,
	store_name text,
	address text,
	license_type text,
	issue_date timestamp with time zone,
	end_date timestamp with time zone,
	census_tract integer, 
	x_coord double precision,
	y_coord double precision
);

INSERT INTO liquor_locations (bfn, store_name, address, license_type,
		issue_date, end_date, census_tract, x_coord, y_coord)
	SELECT DISTINCT bfn, store_name, address, license_type,
		issue_date, end_date, census_tract, x_coord, y_coord
	FROM liquor_locations_complete;