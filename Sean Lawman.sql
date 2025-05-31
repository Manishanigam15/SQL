CREATE DATABASE Seanlawman;
use Seanlawman;

-- In each decade, how many schools were there that produced MLB players?
SELECT (YEAR(debut) / 10) * 10 AS decade, COUNT(DISTINCT s.schoolID) AS school_count
FROM People p
JOIN CollegePlaying cp ON p.playerID = cp.playerID
JOIN Schools s ON cp.schoolID = s.schoolID
WHERE debut IS NOT NULL
GROUP BY decade
ORDER BY decade;


-- What are the names of the top 5 schools that produced the most players?
SELECT s.name_full AS school_name, COUNT(cp.playerID) AS player_count
FROM CollegePlaying cp
JOIN Schools s ON cp.schoolID = s.schoolID
GROUP BY school_name
ORDER BY player_count DESC
LIMIT 5;

--  For each decade, what were the names of the top 3 schools that produced the most players?
SELECT decade, school_name, player_count 
FROM (     
    SELECT 
        FLOOR(SUBSTRING(p.debut, 1, 4) / 10) * 10 AS decade,             
        s.name_full AS school_name,             
        COUNT(cp.playerID) AS player_count,            
        RANK() OVER (                
            PARTITION BY FLOOR(SUBSTRING(p.debut, 1, 4) / 10) * 10                 
            ORDER BY COUNT(cp.playerID) DESC
        ) AS ranking     
    FROM People p     
    JOIN CollegePlaying cp ON p.playerID = cp.playerID     
    JOIN Schools s ON cp.schoolID = s.schoolID     
    WHERE p.debut IS NOT NULL     
    GROUP BY decade, school_name 
) ranked_schools 
ORDER BY decade, player_count DESC
LIMIT 3;

-- Return the top 20% of teams in terms of average annual spending.
SELECT ROUND(COUNT(DISTINCT teamID) * 0.2) AS top_20
FROM salaries;
SELECT teamID, AVG(salary) AS avg_annual_spending
FROM Salaries
GROUP BY teamID
ORDER BY avg_annual_spending DESC
LIMIT 20;

-- For each team, show the cumulative sum of spending over the years.
SELECT teamID, yearID, salary,
       SUM(salary) OVER (PARTITION BY teamID ORDER BY yearID ASC) AS cumulative_spending
FROM Salaries
ORDER BY teamID, yearID;

-- Return the first year that each team's cumulative spending surpassed 1 billion.
SELECT teamID, MIN(yearID) AS first_year
FROM (
    SELECT teamID, yearID,
           SUM(salary) OVER (PARTITION BY teamID ORDER BY yearID ASC) AS cumulative_spending
    FROM Salaries
) AS cumulative_sums
WHERE cumulative_spending >= 1000000000
GROUP BY teamID;