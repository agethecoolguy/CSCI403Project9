/* \i csci403/Project9/CSCI403Project9/script.sql */
DROP TABLE IF EXISTS trips;
DROP TABLE IF EXISTS stations;

CREATE TABLE stations(
	id integer PRIMARY KEY,
	terminal text,
	station text,
	municipal text,
	lat float,
	lng float,
	status text
	)
;
	
CREATE TABLE trips(
	id serial PRIMARY KEY,
	hubway_id bigint,
	status text,
	duration integer,
	start_date timestamp,
	start_station integer REFERENCES stations(id),
	end_date timestamp,
	end_station integer REFERENCES stations(id),
	bike_number text,
	subsc_type text,
	zip_code text,
	birth_date integer,
	gender text	
);

\COPY stations FROM 'data/hubway_stations.csv' WITH (format csv, header true);
\COPY trips FROM 'data/hubway_trips.csv' WITH (format csv, header true);