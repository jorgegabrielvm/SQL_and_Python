SELECT * FROM Absenteeism_at_work
SELECT * FROM compensation
SELECT * FROM Reasons


-- create a join table
SELECT * FROM Absenteeism_at_work a
LEFT JOIN compensation b
ON a.ID = b.ID
LEFT JOIN Reasons r
ON a.Reason_for_absence = r.Number


-- find the healthiest
SELECT * FROM Absenteeism_at_work
WHERE Social_drinker = 0 AND Social_drinker = 0
AND Body_mass_index < 25
AND Absenteeism_time_in_hours < (SELECT AVG(Absenteeism_time_in_hours) FROM Absenteeism_at_work)


-- budget: $983,221 in compensations
-- calculate hourly increase: $0.74
-- calculate yearly increase: $1,443.26
-- compensation rate increase for non-smokers
SELECT COUNT(Social_smoker) as non_smokers FROM Absenteeism_at_work
WHERE Social_smoker = 0


-- optimize this query
SELECT
a.ID,
r.Reason,
Body_mass_index,
CASE WHEN Body_mass_index < 18 THEN 'Underweight'
	 WHEN Body_mass_index between 18 and 25 THEN 'Healthy'
	 WHEN Body_mass_index between 25 and 30 THEN 'Overweight'
	 WHEN Body_mass_index > 30 THEN 'Obese'
	 ELSE 'Unknow' END AS BMI_Category,
CASE WHEN Month_of_absence IN (12,1,2) THEN 'Winter'
	 WHEN Month_of_absence IN (3,4,5) THEN 'Spring'
	 WHEN Month_of_absence IN (6,7,8) THEN 'Summer'
	 WHEN Month_of_absence IN (9,10,11) THEN 'Fall'
	 ELSE 'Unknow' END AS Seasons_Name,
Month_of_absence,
Day_of_the_week,
Transportation_expense,
Education,
Son,
Social_drinker,
Social_smoker,
Pet,
Disciplinary_failure,
Age,
Work_load_Average_day,
Absenteeism_time_in_hours
FROM Absenteeism_at_work a
LEFT JOIN compensation b
ON a.ID = b.ID
LEFT JOIN Reasons r
ON a.Reason_for_absence = r.Number