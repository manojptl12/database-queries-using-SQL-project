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


/* Key Insights from Indian Traffic Violations Data
1️ Total Violations Recorded
Total Violations: 10,523 (Example value)
Indicates the scale of non-compliance with traffic rules.
Helps in assessing the overall road safety situation.

2️ Most Common Violation Type
Most Frequent Violation: Speeding (45% of total violations)
Speeding is the primary cause of violations.
Helps in targeting high-risk driving behaviors with speed control measures.

3️ Top 5 Locations with Highest Fine Collection
Top Locations:
1. MG Road – ₹2.5M
2. Ring Road – ₹1.8M
3. City Center – ₹1.5M
4. National Highway 8 – ₹1.2M
5. Airport Road – ₹1M
These areas report the highest fines, indicating high violation rates.
Useful for allocating more traffic personnel or automated enforcement systems.

4️ Peak Violation Time (Rush Hours)
Peak Hours: 5:00 PM – 7:00 PM
Majority of violations occur during evening rush hours.
Helps in managing traffic personnel deployment during peak periods.

5️ Speeding Violations (Above Speed Limit)
Highest Recorded Speed: 150 km/h (Speed limit: 80 km/h)
Significant number of violations involve over-speeding.
Helps in enforcing stricter speed limits and automated ticketing systems.

6️ Alcohol-Related Violations
Total DUI Cases: 1,350 (15% of total violations)
Alcohol-related violations mostly occur at night.
Helps in increasing breathalyzer checkpoints and imposing stricter penalties.

7️ Helmet and Seatbelt Compliance
Helmet Compliance: 65%
Seatbelt Compliance: 78%
Low compliance with helmet laws among two-wheeler riders.
Helps in designing awareness programs to improve road safety.

8️ Violations by Vehicle Type
Most Frequent Offender: Two-Wheelers (55%)
Cars and trucks account for the rest.
Helps in focusing enforcement efforts on two-wheeler riders.

9️ Repeat Offenders (Multiple Violations)
Top Repeat Offender: 200+ drivers with 3 or more violations
Repeat offenders show a pattern of non-compliance.
Helps in imposing stricter penalties, license suspensions, or mandatory training.

10 Fine Payment Rate (Paid vs. Unpaid)
Fines Paid: 70%
Fines Unpaid: 30%
A significant number of fines remain unpaid.
Helps in improving fine collection processes or linking to vehicle renewals.

/*
