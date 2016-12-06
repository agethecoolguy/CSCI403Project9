/* \i csci403/Project9/CSCI403Project9/script.sql */
DROP TABLE IF EXISTS crime;
DROP TABLE IF EXISTS codes;
CREATE TABLE codes (
	off_code integer,
	off_code_ext integer,
	off_type_id text,
	off_type_name text,
	off_cat_id text,
	off_cat_name text,
	is_crime boolean,
	is_traffic boolean,
	PRIMARY KEY (off_code, off_code_ext)
);
CREATE TABLE crime_init (
	inc_id float,
	off_id float,
	off_code integer,
	off_code_ext integer,
	off_type_id text,
	off_cat_id text,
	first_occ_date timestamp,
	last_occ_date timestamp,
	reported_date timestamp,
	inc_addr text,
	geo_x float,
	geo_y float,
	lon float,
	lat float,
	dist_id integer,
	prec_id integer,
	nbhd_id text,
	is_crime boolean,
	is_traffic boolean,
	FOREIGN KEY (off_code, off_code_ext) REFERENCES codes (off_code, off_code_ext),
	PRIMARY KEY (inc_id, off_id, off_code, off_code_ext)
);

\COPY codes FROM 'data/offense_codes.csv' WITH (format csv, header true);
\COPY crime_init FROM 'data/crime.csv' WITH (format csv, header true);
CREATE TABLE crime (
	inc_id float,
	off_id float,
	off_code integer,
	off_code_ext integer,
	first_occ_date timestamp,
	last_occ_date timestamp,
	reported_date timestamp,
	geo_x float,
	geo_y float,
	dist_id integer,
	prec_id integer,
	nbhd_id text,
	is_crime boolean,
	is_traffic boolean
	FOREIGN KEY (off_code, off_code_ext) REFERENCES codes (off_code, off_code_ext),
	PRIMARY KEY (inc_id, off_id, off_code, off_code_ext)
);

INSERT INTO crime (inc_id, off_id, off_code, off_code_ext, first_occ_date, last_occ_date, reported_date, geo_x, geo_y, dist_id, prec_id, nbhd_id, is_crime, is_traffic)
	SELECT DISTINCT inc_id, off_id, off_code, off_code_ext, first_occ_date, last_occ_date, reported_date, geo_x, geo_y, dist_id, prec_id, nbhd_id, is_crime, is_traffic
	FROM crime_init
	WHERE dist_id IS NOT NULL;
DROP TABLE IF EXISTS crime_init;

/*Get the data from http://data.opencolorado.org/dataset/city-and-county-of-denver-liquor-licenses */

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
	council_dist integer,
	police_dist integer,
	census_tract integer, 
	x_coord double precision,
	y_coord double precision
);

INSERT INTO liquor_locations (bfn, store_name, address, license_type,
		issue_date, end_date, council_dist, police_dist, census_tract, x_coord, y_coord)
	SELECT DISTINCT bfn, store_name, address, license_type,
		issue_date, end_date, council_dist, police_dist, census_tract, x_coord, y_coord
	FROM liquor_locations_complete;
DROP TABLE IF EXISTS liquor_locations_complete;


