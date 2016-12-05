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
	FOREIGN KEY (off_code, off_code_ext) REFERENCES codes (off_code, off_code_ext),
	PRIMARY KEY (inc_id, off_id, off_code, off_code_ext)
);

INSERT INTO crime (inc_id, off_id, off_code, off_code_ext, first_occ_date, last_occ_date, reported_date, geo_x, geo_y, dist_id, prec_id, nbhd_id)
	SELECT DISTINCT inc_id, off_id, off_code, off_code_ext, first_occ_date, last_occ_date, reported_date, geo_x, geo_y, dist_id, prec_id, nbhd_id
	FROM crime_init;

DROP TABLE IF EXISTS crime_init;
