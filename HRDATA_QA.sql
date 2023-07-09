-- KPIs AND CHARTS QA


-- EMPLOYEE COUNT


SELECT SUM(employee_count) FROM HRDATA


SELECT SUM(employee_count) as employee_count FROM HRDATA
WHERE education = 'High School'


SELECT SUM(employee_count) as employee_count FROM HRDATA
WHERE department = 'Sales'


SELECT SUM(employee_count) as employee_count FROM HRDATA
WHERE department = 'R&D'


SELECT SUM(employee_count) as employee_count FROM HRDATA
WHERE education_field = 'Medical'


-- ATRITION COUNT


SELECT COUNT(attrition) FROM HRDATA
WHERE attrition = 1


SELECT COUNT(attrition) FROM HRDATA
WHERE attrition = 1 and education = 'Doctoral Degree'


SELECT COUNT(attrition) FROM HRDATA
WHERE attrition = 1 and department = 'R&D'


SELECT COUNT(attrition) FROM HRDATA
WHERE attrition = 1 and department = 'R&D' and education_field = 'Medical'


SELECT COUNT(attrition) FROM HRDATA
WHERE attrition = 1 and department = 'R&D' and education_field = 'Medical'
and education = 'High School'


-- ATTRITION RATE


SELECT (CAST((SELECT COUNT(attrition) FROM HRDATA WHERE attrition = 1) AS DECIMAL) /
       CAST(SUM(employee_count) AS DECIMAL)) * 100
as attrition_rate FROM HRDATA


SELECT (CAST((SELECT COUNT(attrition) FROM HRDATA WHERE attrition = 1 and department = 'Sales') AS DECIMAL) /
       CAST(SUM(employee_count) AS DECIMAL)) * 100
	   as attrition_rate FROM HRDATA
WHERE department = 'Sales'


-- ACTIVE EMPLOYEE


SELECT SUM(employee_count) - (SELECT COUNT(attrition) FROM HRDATA WHERE attrition = 1)
FROM HRDATA


SELECT SUM(employee_count) - (SELECT COUNT(attrition) FROM HRDATA WHERE attrition = 1 and gender = 'Male')
FROM HRDATA WHERE gender = 'Male'


SELECT AVG(age) AS avg_age FROM HRDATA


-- ATTRITION BY GENDER


SELECT gender, COUNT(attrition) FROM HRDATA
WHERE attrition = 1
GROUP BY gender


SELECT gender, COUNT(attrition) FROM HRDATA
WHERE attrition = 1 and education = 'High School'
GROUP BY gender
ORDER BY COUNT(attrition) DESC


-- DEPARMENT WISE ATTRITION


SELECT department, COUNT(attrition) FROM HRDATA
WHERE attrition = 1
GROUP BY department


SELECT department, COUNT(attrition) FROM HRDATA
WHERE attrition = 1
GROUP BY department
ORDER BY COUNT(attrition) DESC


SELECT department, COUNT(attrition) FROM HRDATA
WHERE attrition = 1
GROUP BY department
ORDER BY COUNT(attrition) DESC


SELECT department, COUNT(attrition),
(CAST(COUNT(attrition) as NUMERIC) / (SELECT COUNT(attrition) FROM HRDATA WHERE attrition = 1))*100
as percentage_attrition
FROM HRDATA
WHERE attrition = 1
GROUP BY department
ORDER BY COUNT(attrition) DESC


SELECT department, COUNT(attrition) as attrition,
(CAST(COUNT(attrition) as NUMERIC) / (SELECT COUNT(attrition) FROM HRDATA WHERE attrition = 1
and gender = 'Female'))*100
as percentage_attrition
FROM HRDATA
WHERE attrition = 1 and gender = 'Female'
GROUP BY department
ORDER BY COUNT(attrition) DESC


-- NO OF EMPLOYEE BY AGE GROUP


SELECT age_band, gender, SUM(employee_count) FROM HRDATA
GROUP BY age_band, gender
ORDER BY age_band, gender


-- JOB SATISFACTION RATING


SELECT job_role,
       SUM(CASE WHEN job_satisfaction = 1 THEN employee_count ELSE 0 END) AS one,
       SUM(CASE WHEN job_satisfaction = 2 THEN employee_count ELSE 0 END) AS two,
       SUM(CASE WHEN job_satisfaction = 3 THEN employee_count ELSE 0 END) AS three,
       SUM(CASE WHEN job_satisfaction = 4 THEN employee_count ELSE 0 END) AS four
FROM HRDATA
GROUP BY job_role
ORDER BY job_role;


-- EDUCATION FIELD WISE ATTRITION


SELECT education_field, COUNT(attrition)
FROM HRDATA
WHERE attrition = 1 
GROUP BY education_field
ORDER BY COUNT(attrition) DESC


SELECT education_field, COUNT(attrition)
FROM HRDATA
WHERE attrition = 1 and gender = 'Male' and age_band = '25 - 34'
GROUP BY education_field
ORDER BY COUNT(attrition) DESC


-- ATTRITION RATE BY GENDER FOR DIFFERENT AGE GROUP


SELECT age_band, gender, COUNT(attrition) FROM HRDATA
WHERE attrition = 1
GROUP BY age_band, gender
ORDER BY age_band, gender


SELECT age_band, gender, COUNT(attrition) FROM HRDATA
WHERE attrition = 1 and education_field = 'Marketing'
GROUP BY age_band, gender
ORDER BY age_band, gender


SELECT age_band, gender, COUNT(attrition),
(CAST(COUNT(attrition) as NUMERIC) / (SELECT COUNT(attrition) FROM HRDATA WHERE attrition = 1))*100
FROM HRDATA
WHERE attrition = 1
GROUP BY age_band, gender
ORDER BY age_band, gender