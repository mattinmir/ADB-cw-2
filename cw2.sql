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
SELECT 
	feature.state_name, 
	feature.county, 
	SUM(CASE feature.type WHEN 'ppl' THEN 1 ELSE 0 END) AS no_ppl, 
	SUM(CASE feature.type WHEN 'stream' THEN 1 ELSE 0 END) AS no_stream
FROM feature JOIN populated_place
ON feature.county = populated_place.county 
AND populated_place.state_code >= 1
AND populated_place.state_code <= 9
GROUP BY feature.state_name, feature.county
ORDER BY feature.state_name, feature.county
-- not correct, something to do with the join
;

-- Q3 returns (state_abbr,name,latitude,longitude,elevation)
SELECT name, county, latitude,longitude,elevation
FROM populated_place 
WHERE elevation > 10000
UNION
SELECT name, county, latitude,longitude,elevation
FROM feature
WHERE type = 'ppl'
AND elevation > 10000
ORDER BY name, county, latitude,longitude,elevation
;

SELECT * FROM (SELECT name, county, latitude,longitude,elevation
FROM populated_place
WHERE name = 'Alma') as p
FULL OUTER JOIN
(SELECT name, county, latitude,longitude,elevation
FROM feature
WHERE name = 'Alma')as f
ON p.name = f.name AND p.county=f.county;
--See how to select correct rows from this

-- Q4 returns (state_name,county)

;

-- Q5 returns (state_name,county,cell_name,population,county_population,state_population)

;

-- Q6 returns (populated_place_name,feature_name,distance,rank)

;

