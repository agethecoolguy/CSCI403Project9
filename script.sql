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

CREATE TABLE crime (
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
	is_traffic boolean
);

\COPY codes FROM 'data/offense_codes.csv' WITH (format csv, header true);
\COPY crime FROM 'data/crime.csv' WITH (format csv, header true);
