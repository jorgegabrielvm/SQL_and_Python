SELECT * FROM road_accident


-- FIRST KPI

-- Total casualties
SELECT SUM(Number_of_Casualties) AS casualties
FROM road_accident

-- Current year casualties
SELECT SUM(Number_of_Casualties) AS cy_casualties
FROM road_accident
WHERE Year = 2022


SELECT SUM(Number_of_Casualties)
FROM road_accident
WHERE Year = 2022 and Road_Surface_Conditions = 'Dry'


SELECT COUNT(DISTINCT Accident_Index) as cy_accidents
FROM road_accident
WHERE Year = 2022


SELECT SUM(Number_of_Casualties) as cy_fatal_accidents
FROM road_accident
WHERE Year = 2022 and Accident_Severity = 'Fatal'


SELECT SUM(Number_of_Casualties) as cy_serious_accidents
FROM road_accident
WHERE Year = 2022 and Accident_Severity = 'Serious'


SELECT SUM(Number_of_Casualties) as cy_slight_accidents
FROM road_accident
WHERE Year = 2022 and Accident_Severity = 'Slight'


SELECT SUM(Number_of_Casualties) as slight_accidents
FROM road_accident
WHERE Accident_Severity = 'Slight'


SELECT CAST(SUM(Number_of_Casualties) AS DECIMAL(10,2)) * 100 /
(SELECT CAST(SUM(Number_of_Casualties) AS DECIMAL(10,2)) FROM road_accident) AS percentage_total_slight
FROM road_accident
WHERE Accident_Severity = 'Slight'


SELECT CAST(SUM(Number_of_Casualties) AS DECIMAL(10,2)) * 100 /
(SELECT CAST(SUM(Number_of_Casualties) AS DECIMAL(10,2)) FROM road_accident) AS percentage_total_serious
FROM road_accident
WHERE Accident_Severity = 'Serious'


SELECT CAST(SUM(Number_of_Casualties) AS DECIMAL(10,2)) * 100 /
(SELECT CAST(SUM(Number_of_Casualties) AS DECIMAL(10,2)) FROM road_accident) AS percentage_total_fatal
FROM road_accident
WHERE Accident_Severity = 'Fatal'

-- Accidents by Car
SELECT
	CASE
		WHEN Vehicle_Type IN ('Car', 'Taxi/Private hire car') THEN 'Cars'
		ELSE 'Other'
	END AS cars,
	CAST(CAST(SUM(Number_of_Casualties) AS DECIMAL(10,2)) *100 / 
	(SELECT CAST(SUM(Number_of_Casualties) AS DECIMAL(10,2)) FROM road_accident WHERE Year = 2022) AS DECIMAL(10,2))
	as car_pertentage_casualties
FROM road_accident
WHERE Year = 2022
GROUP BY
	CASE
		WHEN Vehicle_Type IN ('Car', 'Taxi/Private hire car') THEN 'Cars'
		ELSE 'Other'
	END



-- SECOND KPI

SELECT
	CASE
		WHEN Vehicle_Type IN ('Agricultural vehicle') THEN 'Agricultural'
		WHEN Vehicle_Type IN ('Car', 'Taxi/Private hire car') THEN 'Cars'
		WHEN Vehicle_Type IN ('Motorcycle over 500cc', 'Motorcycle 125cc and under', 'Motorcycle 50cc and under', 'Motorcycle over 125cc and up to 500cc') THEN 'Bike'
		WHEN Vehicle_Type IN ('Bus or coach (17 or more pass seats)', 'Minibus (8 - 16 passenger seats)') THEN 'Bus'
		WHEN Vehicle_Type IN ('Goods 7.5 tonnes mgw and over', 'Goods over 3.5t. and under 7.5t', 'Van / Goods 3.5 tonnes mgw or under') THEN 'Van'
		ELSE 'Other'
	END AS vehicle_group,
	SUM(Number_of_Casualties) as cy_casualties
FROM road_accident
WHERE Year = 2022
GROUP BY
	CASE
		WHEN Vehicle_Type IN ('Agricultural vehicle') THEN 'Agricultural'
		WHEN Vehicle_Type IN ('Car', 'Taxi/Private hire car') THEN 'Cars'
		WHEN Vehicle_Type IN ('Motorcycle over 500cc', 'Motorcycle 125cc and under', 'Motorcycle 50cc and under', 'Motorcycle over 125cc and up to 500cc') THEN 'Bike'
		WHEN Vehicle_Type IN ('Bus or coach (17 or more pass seats)', 'Minibus (8 - 16 passenger seats)') THEN 'Bus'
		WHEN Vehicle_Type IN ('Goods 7.5 tonnes mgw and over', 'Goods over 3.5t. and under 7.5t', 'Van / Goods 3.5 tonnes mgw or under') THEN 'Van'
		ELSE 'Other'
	END

 

 -- Casualties by Year Monthly Trend:

 -- Current Year
 SELECT DATENAME(MONTH, Accident_Date) AS month_name, SUM(Number_of_Casualties) AS cy_casualties
 FROM road_accident
 WHERE YEAR(Accident_Date) = '2022'
 GROUP BY DATENAME(MONTH, Accident_Date)

 --2021
 SELECT DATENAME(MONTH, Accident_Date) AS month_name, SUM(Number_of_Casualties) AS py_casualties
 FROM road_accident
 WHERE YEAR(Accident_Date) = '2021'
 GROUP BY DATENAME(MONTH, Accident_Date)



 -- Casualties by road type

 SELECT Road_Type, SUM(Number_of_Casualties) AS cy_casualties
 FROM road_accident
 WHERE YEAR(Accident_Date) = '2022'
 GROUP BY Road_Type



 -- Casualties by Rural or Urban

 SELECT Urban_or_Rural_Area, SUM(Number_of_Casualties) AS cy_casualties
 FROM road_accident
 WHERE YEAR(Accident_Date) = '2022'
 GROUP BY Urban_or_Rural_Area

 --Percentage
 SELECT Urban_or_Rural_Area, SUM(Number_of_Casualties) * 100 /
 (SELECT SUM(Number_of_Casualties) FROM road_accident WHERE YEAR(Accident_Date) = '2022')
 AS percentage
 FROM road_accident
 WHERE YEAR(Accident_Date) = '2022'
 GROUP BY Urban_or_Rural_Area
  
  --CASTED
 SELECT Urban_or_Rural_Area, CAST(SUM(Number_of_Casualties) AS DECIMAL(10,2)) * 100 /
 (SELECT CAST(SUM(Number_of_Casualties) AS DECIMAL(10,2)) FROM road_accident WHERE YEAR(Accident_Date) = '2022')
 AS percentage
 FROM road_accident
 WHERE YEAR(Accident_Date) = '2022'
 GROUP BY Urban_or_Rural_Area



-- LIGHT OR DARK

SELECT
	CASE
		WHEN Light_Conditions IN ('Darkness - lighting unknown', 'Darkness - lights lit', 'Darkness - lights unlit', 'Darkness - no lighting') THEN 'Dark'
		ELSE 'Daylight'
	END AS light_conditions,
	SUM(Number_of_Casualties) AS cy_casualties
 FROM road_accident
 WHERE YEAR(Accident_Date) = '2022'
 GROUP BY
 	CASE
		WHEN Light_Conditions IN ('Darkness - lighting unknown', 'Darkness - lights lit', 'Darkness - lights unlit', 'Darkness - no lighting') THEN 'Dark'
		ELSE 'Daylight'
	END

-- percentage
SELECT
	CASE
		WHEN Light_Conditions IN ('Darkness - lighting unknown', 'Darkness - lights lit', 'Darkness - lights unlit', 'Darkness - no lighting') THEN 'Dark'
		ELSE 'Daylight'
	END AS light_conditions,
	CAST(CAST(SUM(Number_of_Casualties) AS DECIMAL(10,2)) * 100 /
 (SELECT CAST(SUM(Number_of_Casualties) AS DECIMAL(10,2)) FROM road_accident WHERE YEAR(Accident_Date) = '2022') AS DECIMAL(10,2))
 AS percentage_with_2_decimals
 FROM road_accident
 WHERE YEAR(Accident_Date) = '2022'
 GROUP BY
 	CASE
		WHEN Light_Conditions IN ('Darkness - lighting unknown', 'Darkness - lights lit', 'Darkness - lights unlit', 'Darkness - no lighting') THEN 'Dark'
		ELSE 'Daylight'
	END



-- TOP 10 CASUALTIES BY DISTRICT

SELECT TOP 10 Local_Authority_District, SUM(Number_of_Casualties) AS cy_casualties
 FROM road_accident
 WHERE YEAR(Accident_Date) = '2022' 
 GROUP BY Local_Authority_District
 ORDER BY cy_casualties DESC



-- Casualties by Road Surface

 SELECT
	CASE
		WHEN Road_Surface_Conditions IN ('Flood over 3cm. deep', 'Wet or damp') THEN 'Wet'
		WHEN Road_Surface_Conditions IN ('Frost or ice', 'Snow') THEN 'Snow/Ice'
		ELSE 'Dry'
	END AS Road_Surface_Conditions,
	SUM(Number_of_Casualties) AS total_casualties
 FROM road_accident
 GROUP BY
	CASE
		WHEN Road_Surface_Conditions IN ('Flood over 3cm. deep', 'Wet or damp') THEN 'Wet'
		WHEN Road_Surface_Conditions IN ('Frost or ice', 'Snow') THEN 'Snow/Ice'
		ELSE 'Dry'
	END

