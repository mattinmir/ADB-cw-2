-- Q1 returns (state_name)

SELECT feature.name AS state_name
FROM feature LEFT JOIN state USING(name)
WHERE code IS NOT NULL
;

--or


SELECT UPPER(state_name) AS state_name
FROM feature
EXCEPT
SELECT UPPER(name) AS state_name
FROM state
ORDER BY state_name
;
--could be done better as a join??

-- Q2 returns (state_name,county,no_ppl,no_stream)
-- List in alphabetical order as the scheme (state name,county,no ppl,no stream) the number of
-- populated places and the number of streams recorded in feature in each county. The list
-- should be limited to those states that have state code between 1 and 9.
SELECT 
	feature.state_name, 
	feature.county, 
	SUM(CASE feature.type WHEN 'ppl' THEN 1 ELSE 0 END) AS no_ppl, 
	SUM(CASE feature.type WHEN 'stream' THEN 1 ELSE 0 END) AS no_stream
FROM feature JOIN state
ON UPPER(feature.state_name) = UPPER(state.name)
AND state.code BETWEEN 1 AND 9 
AND feature.county IS NOT NULL
GROUP BY feature.state_name, feature.county
ORDER BY feature.state_name, feature.county

;

-- Q3 returns (state_abbr,name,latitude,longitude,elevation)
SELECT state.abbr AS abbr, populated_place.name, latitude,longitude,elevation
FROM populated_place JOIN state 
ON state.code = state_code
AND elevation > 10000

UNION 

SELECT state.abbr AS abbr, feature.name, latitude,longitude,elevation
FROM feature JOIN state 
ON UPPER(state.name) = UPPER(feature.state_name)
AND type = 'ppl'
AND elevation > 10000 
ORDER BY abbr, name;

-- Q4 returns (state_name,county)
-- List in alphabetical order the scheme (state_name,county) listing the names of states,
-- and counties of those states found in populated_place, for which all entries of the county 
-- have an unknown population.
SELECT state.name AS state_name, county
FROM populated_place JOIN state ON populated_place.state_code = state.code
GROUP BY county, state.name
HAVING SUM(CASE WHEN population IS NOT NULL THEN 1 ELSE 0 END) = 0
ORDER BY state.name, county
;

-- Q5 returns (state_name,county,cell_name,population,county_population,state_population)

--Write a query returning the scheme (state name,county,cell name,population,county population,
--state population), that lists each cell name found in populated place, the total population
--recorded for all records of that cell, together with the population of the county and the
--population of the state in which that cell is found.
--The query result must be ordered by the state name, county and cell name. The query result
--should also exclude listing cells for which there is no information about the population, and
--the list should be limited to those states that have state code between 1 and 9.
SELECT 
	state.name AS state_name,
	county, cell_name, 
	SUM(population) OVER (PARTITION BY cell_name)AS population,
	SUM(population) OVER (PARTITION BY county)AS county_population,
	SUM(population) OVER (PARTITION BY state)AS state_population
FROM populated_place JOIN state 
ON state.code = populated_place.state_code
AND populated_place.state_code BETWEEN 1 AND 9
AND population IS NOT NULL
ORDER BY state_name, county, cell_name
;

-- Q6 returns (populated_place_name,feature_name,distance,rank)

--Write a query returning the scheme (populated place name,feature name,distance,rank), that
--lists the features which are of type summit, that are 200 miles or less from entries in populated
--place with a population of at least one hundred thousand.
--The results must be returned in order of populated place name and rank, where rank orders
--the distances of the features from a given populated place name in ascending order. Your
--query should assume that the earth is a perfect sphere of radius 3959 miles, and round the
--distance figure to two decimal places

SELECT populated_place.name AS populated_place_name, feature.name AS feature_name, 
ROUND((3959 * ACOS(COS(RADIANS(feature.latitude)) * COS(RADIANS(populated_place.latitude)) * COS( RADIANS(populated_place.longitude) - RADIANS(feature.longitude)) + SIN( RADIANS(feature.latitude)) * SIN(RADIANS(populated_place.latitude))))::numeric, 2) AS distance,
DENSE_RANK() OVER (PARTITION BY populated_place.name ORDER BY ROUND(3959 * ACOS(COS(RADIANS(feature.latitude)) * COS(RADIANS(populated_place.latitude)) * COS( RADIANS(populated_place.longitude) - RADIANS(feature.longitude)) + SIN( RADIANS(feature.latitude)) * SIN(RADIANS(populated_place.latitude))))::numeric ASC) AS rank
FROM populated_place JOIN feature
ON feature.type = 'summit'
AND population >= 100000
AND 3959 * ACOS(COS(RADIANS(feature.latitude)) * COS(RADIANS(populated_place.latitude)) * COS( RADIANS(populated_place.longitude) - RADIANS(feature.longitude)) + SIN( RADIANS(feature.latitude)) * SIN(RADIANS(populated_place.latitude)))::numeric <= 200
ORDER BY  populated_place_name, rank
;

