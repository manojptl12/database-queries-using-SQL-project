CREATE DATABASE TrafficViolations;
USE TrafficViolations;

CREATE TABLE Violations (
    Violation_ID VARCHAR(20) PRIMARY KEY,
    Violation_Type VARCHAR(50),
    Fine_Amount INT,
    Location VARCHAR(50),
    Date DATE,
    Time TIME,
    Vehicle_Type VARCHAR(20),
    Vehicle_Color VARCHAR(20),
    Vehicle_Model_Year INT,
    Registration_State VARCHAR(30),
    Driver_Age INT,
    Driver_Gender VARCHAR(10),
    License_Type VARCHAR(20),
    Penalty_Points INT,
    Weather_Condition VARCHAR(30),
    Road_Condition VARCHAR(30),
    Officer_ID VARCHAR(20),
    Issuing_Agency VARCHAR(50),
    License_Validity VARCHAR(20),
    Number_of_Passengers INT,
    Helmet_Worn VARCHAR(5),
    Seatbelt_Worn VARCHAR(5),
    Traffic_Light_Status VARCHAR(20),
    Speed_Limit INT,
    Recorded_Speed INT,
    Alcohol_Level FLOAT,
    Breathalyzer_Result VARCHAR(20),
    Towed VARCHAR(5),
    Fine_Paid VARCHAR(10),
    Payment_Method VARCHAR(20),
    Court_Appearance_Required VARCHAR(5),
    Previous_Violations INT,
    Comments VARCHAR(255)
);

show variables like "secure_file_priv";


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Indian_Traffic_Violations.csv'
INTO TABLE Violations
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 1. Total Number of Violations
SELECT COUNT(*) AS Total_Violations 
FROM Violations;

-- 2.  Most Common Violation Types
SELECT Violation_Type, COUNT(*) AS Occurrences
FROM Violations
GROUP BY Violation_Type
ORDER BY Occurrences DESC;

-- 3. Top 5 Locations with Highest Fines Collected
SELECT Location, SUM(Fine_Amount) AS Total_Fines
FROM Violations
GROUP BY Location
ORDER BY Total_Fines DESC
LIMIT 5;

-- 4  Peak Violation Times (By Hour)
SELECT HOUR(Time) AS Violation_Hour, COUNT(*) AS Total_Violations
FROM Violations
GROUP BY Violation_Hour
ORDER BY Total_Violations DESC;

-- 5. Speeding Violations (Above Speed Limit)
SELECT Violation_ID, Speed_Limit, Recorded_Speed, 
       (Recorded_Speed - Speed_Limit) AS Speed_Excess
FROM Violations
WHERE Recorded_Speed > Speed_Limit
ORDER BY Speed_Excess DESC;

-- 6. Alcohol-Related Violations (Above Legal Limit) 
SELECT Violation_ID, Alcohol_Level, Driver_Age, Fine_Amount
FROM Violations
WHERE Alcohol_Level > 0.03
ORDER BY Alcohol_Level DESC;

-- 7. Percentage of Drivers Wearing Helmets/Seatbelts
-- Helmet Compliance
SELECT (COUNT(CASE WHEN Helmet_Worn = 'Yes' THEN 1 END) * 100.0) / COUNT(*) 
AS Helmet_Compliance_Percentage
FROM Violations;

-- Seatbelt Compliance
SELECT (COUNT(CASE WHEN Seatbelt_Worn = 'Yes' THEN 1 END) * 100.0) / COUNT(*) 
AS Seatbelt_Compliance_Percentage
FROM Violations;

-- 8. Violations by Vehicle Type
SELECT Vehicle_Type, COUNT(*) AS Total_Violations
FROM Violations
GROUP BY Vehicle_Type
ORDER BY Total_Violations DESC;

-- 9. Most Frequent Offenders (Repeat Violators)
SELECT Violation_ID, Driver_Age, Previous_Violations, Fine_Amount
FROM Violations
WHERE Previous_Violations > 1
ORDER BY Previous_Violations DESC;

-- 10. Percentage of Fines Paid vs. Unpaid
SELECT 
    (SELECT COUNT(*) FROM Violations WHERE Fine_Paid = 'Yes') * 100.0 / COUNT(*) 
    AS Fines_Paid_Percentage,
    (SELECT COUNT(*) FROM Violations WHERE Fine_Paid = 'No') * 100.0 / COUNT(*) 
    AS Fines_Unpaid_Percentage
FROM Violations;


-- INSIGHTS

-- 1. This query helps identify the overall scale of traffic violations recorded. A high number of violations may indicate poor traffic discipline or inadequate enforcement.
-- 2. Understanding which violations are most frequent can help target specific behaviors such as speeding, signal jumping, or helmet non-compliance.
-- 3. Identifying locations with the highest fine collection shows where violations are concentrated. This can guide resource allocation.
-- 4. This shows the time of day when most violations occur, helping schedule enforcement at peak times.
-- 5. Determining how frequently and by how much drivers exceed speed limits provides data for speed control policy adjustments.
-- 6. Tracking alcohol violations helps identify high-risk areas and times for DUI enforcement.
-- 7. Understanding helmet and seatbelt usage can indicate how well safety regulations are followed.
-- 8. Helps identify which type of vehicles (cars, bikes, trucks) are involved in most violations.
-- 9. Highlighting frequent violators helps target habitual offenders for stricter penalties
-- 10. Helps evaluate the efficiency of fine collection processes.







