-- Q1 returns (state_name)
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
FROM feature JOIN populated_place ON feature.county = populated_place.county 
	AND populated_place.state_code >= 1 AND populated_place.state_code <= 9
GROUP BY feature.state_name, feature.county
ORDER BY feature.state_name, feature.county
;

-- Q3 returns (state_abbr,name,latitude,longitude,elevation)

; 

-- Q4 returns (state_name,county)

;

-- Q5 returns (state_name,county,cell_name,population,county_population,state_population)

;

-- Q6 returns (populated_place_name,feature_name,distance,rank)

;

