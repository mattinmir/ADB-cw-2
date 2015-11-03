-- Q1 returns (state_name)
SELECT feature.name AS state_name
FROM feature LEFT JOIN state USING(name)
WHERE code IS NOT NULL
;

-- Q2 returns (state_name,county,no_ppl,no_stream)

;

-- Q3 returns (state_abbr,name,latitude,longitude,elevation)

; 

-- Q4 returns (state_name,county)

;

-- Q5 returns (state_name,county,cell_name,population,county_population,state_population)

;

-- Q6 returns (populated_place_name,feature_name,distance,rank)

;

