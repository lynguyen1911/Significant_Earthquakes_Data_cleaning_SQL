-- EXPLORE DATASET
-- Sample of dataset
SELECT* FROM earthquakes_new
LIMIT 10;

-- Confirming the data types of the variables
SELECT DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE table_schema = 'Significant_Earthquakes' and table_name = 'earthquakes_new';

-- Deal with data incosistency in Date column
SELECT DISTINCT(length(Date)) AS length_date 
FROM earthquakes_new; -- return 2 values 10 & 24

SELECT Date  -- check for the date with length = 24
FROM earthquakes_new
WHERE length(Date) = 24;

-- Fix the Date with length =24, then update to the database
SELECT LEFT(Date, 10) 
FROM earthquakes_new
WHERE length(Date) = 24; -- return 3 values

UPDATE Significant_Earthquakes.earthquakes_new -- fix the date with length =24, update to database
SET Date = left(Date,10);

-- Convert Date to date datatype, create New_Date col. in database
ALTER TABLE Significant_Earthquakes.earthquakes_new
ADD column New_Date date after Date; 

SELECT * FROM earthquakes_new LIMIT 5;

UPDATE Significant_Earthquakes.earthquakes_new 
SET New_Date = str_to_date(Date, '%d/%m/%Y'); -- Error with incorrect datetime value

SELECT Date, str_to_date(Date, '%d/%m/%Y') -- Find out error
FROM earthquakes_new
WHERE str_to_date(Date, '%d/%m/%Y') is NULL; -- 3 errors 

-- Fix 3 errors
UPDATE earthquakes_new
SET Date = Replace(Date, '1975-02-23', '23/02/1975');
UPDATE earthquakes_new
SET Date = Replace(Date, '1985-04-28', '28/04/1985');
UPDATE earthquakes_new
SET Date = Replace(Date, '2011-03-13', '13/03/2011');

UPDATE Significant_Earthquakes.earthquakes_new
SET New_Date = str_to_date(Date, '%d/%m/%Y');

SELECT * FROM earthquakes_new LIMIT 5;

-- STANDARDIZE TIME COLUMN

SELECT cast(Time as time) 
FROM earthquakes_new;

ALTER TABLE earthquakes_new
ADD column New_Time time after Time;
UPDATE earthquakes_new
SET New_Time = cast(Time as time); -- error: incorrect time values

-- To find the cause of the error

SELECT DISTINCT(length(Time))
FROM earthquakes_new; -- return 8, 24 

SELECT Time 
FROM earthquakes_new
WHERE length(Time) =24; -- 3 values are in wrong format  

-- To replace the 3 rows with the correct Time length
UPDATE earthquakes_new
SET Time = replace(Time,'1975-02-23T02:58:41.000Z', substr(Time,12,8));

UPDATE earthquakes_new
SET Time = replace(Time,'1985-04-28T02:53:41.530Z', substr(Time,12,8))
WHERE Time = '1985-04-28T02:53:41.530Z';

UPDATE earthquakes_new 
SET Time = replace(Time,'2011-03-13T02:23:34.520Z', substr(Time,12,8))
WHERE Time = '2011-03-13T02:23:34.520Z';

-- To check if it has been effected correctly

SELECT min(length(Time)), Max(length(Time)) 
FROM earthquakes_new;-- min(8), Max(8)

-- Update col New_Time
UPDATE earthquakes_new
SET New_Time = cast(Time as time);


-- HANDLING NULL VALUES:
-- there are plenty of blank values in different columns.
-- Have a good understanding of each attribute are neccessary to handling null values
-- For the purpose of studying, I just replaced all blank values with 0
UPDATE earthquakes_new 
SET Depth_Error = CASE
WHEN Depth_Error = '' THEN 0.0
ELSE Depth_Error
END;

UPDATE earthquakes_new 
SET Depth_Seismic_Stations = CASE
WHEN Depth_Seismic_Stations = '' THEN 0.0
ELSE Depth_Seismic_Stations
END;

UPDATE earthquakes_new 
SET Magnitude_Error = CASE
WHEN Magnitude_Error = '' THEN 0.0
ELSE Magnitude_Error
END;

UPDATE earthquakes_new 
SET Magnitude_Seismic_Stations = CASE
WHEN Magnitude_Seismic_Stations = '' THEN 0.0
ELSE Magnitude_Seismic_Stations
END;

UPDATE earthquakes_new 
SET Azimuthal_Gap = CASE
WHEN Azimuthal_Gap = '' THEN 0.0
ELSE Azimuthal_Gap
END;

UPDATE earthquakes_new 
SET Horizontal_Distance = CASE
WHEN Horizontal_Distance = '' THEN 0.0
ELSE Horizontal_Distance
END;

UPDATE earthquakes_new 
SET Horizontal_Error = CASE
WHEN Horizontal_Error = '' THEN 0.0
ELSE Horizontal_Error
END;

UPDATE earthquakes_new 
SET Root_Mean_Square = CASE
WHEN Root_Mean_Square = '' THEN 0.0
ELSE Root_Mean_Square
END;

-- Converting the numerical attributes that were stored as text to double

ALTER TABLE earthquakes_new MODIFY COLUMN Depth_Error double;
ALTER TABLE earthquakes_new MODIFY COLUMN Depth_Seismic_Stations double;
ALTER TABLE earthquakes_new MODIFY COLUMN Magnitude_Error double;
ALTER TABLE earthquakes_new MODIFY COLUMN Magnitude_Seismic_Stations double;
ALTER TABLE earthquakes_new MODIFY COLUMN Azimuthal_Gap double;
ALTER TABLE earthquakes_new MODIFY COLUMN Horizontal_Distance double;
ALTER TABLE earthquakes_new MODIFY COLUMN Horizontal_Error double;
ALTER TABLE earthquakes_new MODIFY COLUMN Root_Mean_Square double; 

-- CREATING NEW COLUMNS (YEAR, MONTH) FROM THE NEW_DATE COLUMN FOR LATER ANALYSIS
-- Year 
SELECT EXTRACT(YEAR FROM New_Date) FROM earthquakes_new;

ALTER TABLE earthquakes_new
ADD COLUMN Year int AFTER New_Time;

UPDATE earthquakes_new
SET Year = EXTRACT(YEAR FROM New_Date);

-- Month
SELECT EXTRACT(MONTH FROM New_Date) FROM earthquakes_new;

ALTER TABLE earthquakes_new
ADD COLUMN Month int AFTER Year;

UPDATE earthquakes_new
SET Month = EXTRACT(MONTH FROM New_Date);

SELECT * FROM earthquakes_new LIMIT 10;

-- LOOKING FOR OUTLIERS (with the knowledge that the years data were collected were 1965-2016 
-- and magnitude is >= 5.5)

SELECT Year 
FROM earthquakes_new
WHERE Year < 1965 or Year > 2016; -- 0 returns --> no outliers

SELECT Magnitude
FROM earthquakes_new
WHERE Magnitude < 5.5; -- 0 returns --> no outliers

-- Deleting UNUSED COLUMN

ALTER TABLE earthquakes_new
DROP COLUMN Date,
DROP COLUMN Time;

