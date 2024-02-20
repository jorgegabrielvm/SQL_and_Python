-- Jorge Gabriel Villasmil Mesa CA1

-- 1) Create the database with the tables requested taking into consideration the length allowed in each cell,
-- necessary constraints and linking words.

CREATE TABLE Users (
    Username VARCHAR(35),
    Name VARCHAR(35),
    Surname VARCHAR(35),
    Password VARCHAR(15),
    PRIMARY KEY (Username)
);

CREATE TABLE Movies (
    ID_Movie INT(6),
    Name VARCHAR(35),
    Genre VARCHAR(20),
    Duration VARCHAR(6),
    Qualification INT CHECK (Qualification >= 1 AND Qualification <= 5),
    Protagonist_Actor_Name VARCHAR(35),
    Protagonist_Actor_Surname VARCHAR(35),
    PRIMARY KEY (ID_Movie)
);

CREATE TABLE Series (
    ID_Series INT(6),
    Genre VARCHAR(20),
    Qualification INT CHECK (Qualification >= 1 AND Qualification <= 5),
    Protagonist_Actor_Name VARCHAR(35),
    Protagonist_Actor_Surname VARCHAR(35),
    Number_of_Seasons INT,
    PRIMARY KEY (ID_Series)
);

CREATE TABLE Actors (
    Name VARCHAR(35),
    Surname VARCHAR(35),
    Nationality VARCHAR(50),
    PRIMARY KEY (Surname)
);

CREATE TABLE Directors (
    Name VARCHAR(35),
    Surname VARCHAR(35),
    Nationality VARCHAR(50),
    PRIMARY KEY (Surname)
);

-- Using Foreign Key help us to fill these table only if the data come from the reference table

CREATE TABLE ActivityMovies (
    Username VARCHAR(35),
    ID_Movie INT,
    Genre VARCHAR(20),
    FOREIGN KEY (Username) REFERENCES Users(Username),
    FOREIGN KEY (ID_Movie) REFERENCES Movies(ID_Movie)
);

CREATE TABLE ActivitySeries (
    Username VARCHAR(35),
    ID_Series INT,
    Genre VARCHAR(20),
    FOREIGN KEY (Username) REFERENCES Users(Username),
    FOREIGN KEY (ID_Series) REFERENCES Series(ID_Series)
);


-- 2) Populate the tables with a minimum of 500 observations including the most popular movies/series of the
-- last 10 years and some classic films. 

-- I uploaded almost all them via CSV:
	-- I used ChatGPT to get the raw data
	-- Format them from .txt to csv using python code
    -- Running script for data engineering
    -- Importing data to Mysql

-- These are only the queries that I used for filling tables

INSERT INTO ActivityMovies (Username, ID_Movie, Genre)
SELECT DISTINCT u.Username, m.ID_Movie, m.Genre
FROM Users u, Movies m;

INSERT INTO activityseries (Username, ID_Series, Genre)
SELECT DISTINCT u.Username, s.ID_Series, s.Genre
FROM Users u, Series s;


-- 3) Create 2 possible relations within the tables to have related tables in the database. 

-- a. Creating Relationship with Series and Directors table
	-- EXAMPLE: We can study numbers of series a director has been part of

CREATE TABLE SeriesDirectors (
    ID_Series INT(6),
    Director_Surname VARCHAR(35),
    FOREIGN KEY (ID_Series) REFERENCES Series(ID_Series),
    FOREIGN KEY (Director_Surname) REFERENCES Directors(Surname),
    PRIMARY KEY (ID_Series, Director_Surname)
);

-- Filling the table

INSERT INTO SeriesDirectors (ID_Series, Director_Surname)
SELECT DISTINCT s.ID_Series, d.Surname
FROM Series s, Directors d;

-- b. Creating Directors and Movies Qualification relationship
	-- EXAMPLE: We can study the directors with the best ratings ever
    
CREATE TABLE MovieDirectorRatings (
    ID_Movie INT(6),
    Director_Surname VARCHAR(35),
    Movie_Qualification INT,
    FOREIGN KEY (ID_Movie) REFERENCES Movies(ID_Movie),
    FOREIGN KEY (Director_Surname) REFERENCES Directors(Surname),
    PRIMARY KEY (ID_Movie, Director_Surname)
);

-- Filling the table
	-- this time I use used limit 500 because in the example of "SeriesDirectors" Table, there
    -- were too many entries

INSERT INTO MovieDirectorRatings (ID_Movie, Director_Surname, Movie_Qualification)
SELECT DISTINCT m.ID_Movie, d.Surname, m.Qualification
FROM Series s, Directors d, Movies m
Limit 500;


-- 4) Once the database is created, the creators of the app want you to add the year of the series and movies
-- on the database. Execute the correct modification on the appropriate tables. 

--  Adding Year column to Movies and Series Table

ALTER TABLE Movies
ADD Year INT;

ALTER TABLE Series
ADD Year INT;


-- Creating "SeriesYears" and "MoviesYears" tables to join the year table to Series and Movies
-- Load csv 
-- Join connection to fill them
-- Dropping them

CREATE TABLE SeriesYears (
    ID_Series INT(6),
    Year INT,
    PRIMARY KEY (ID_Series)
);

CREATE TABLE MoviesYears (
    ID_Movie INT(6),
    Year INT,
    PRIMARY KEY (ID_Movie)
);

UPDATE Series s
JOIN SeriesYears sy ON s.ID_Series = sy.ID_Series
SET s.Year = sy.Year;

UPDATE Movies m
JOIN MoviesYears my ON m.ID_Movie = my.ID_Movie
SET m.Year = my.Year;

DROP TABLE SeriesYears
DROP TABLE MoviesYears


-- 5) Choose a famous actor that is a protagonist in several movies, and obtain the number of movies that s/he participated in

SELECT Actors.Name, COUNT(*) AS Num_Movies
FROM Actors
JOIN Movies ON Actors.Name = Movies.Protagonist_Actor_Name
GROUP BY Actors.Name
ORDER BY Num_Movies DESC;

-- in my dataset only one actor has participated in several movies
-- Liam participated in 60 different Movies


-- 6) Obtain the list of actors who were protagonist in movies but not in series.

SELECT DISTINCT Name, Surname
FROM Actors
WHERE (Name, Surname) IN (
    SELECT Protagonist_Actor_Name, Protagonist_Actor_Surname
    FROM Movies
) AND (Name, Surname) NOT IN (
    SELECT Protagonist_Actor_Name, Protagonist_Actor_Surname
    FROM Series
);

-- None


