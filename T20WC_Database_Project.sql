/*
============================================================
ICC MEN'S T20 WORLD CUP 2026
MYSQL DATABASE & DATA ANALYSIS PROJECT
============================================================

Project sections:
1. Database & Table Creation
2. Data Insertion & CSV Import
3. Data Cleaning & Validation
4. Basic SQL Queries
5. Advanced SQL Analysis

IMPORTANT BEFORE RUNNING:
- Run Section 1 first, only once for a new database.
- Run Section 2 after updating CSV file paths to your own computer.
- Do not run multiple alternative imports for the same table, or you may
  import duplicate records.
- LOAD DATA INFILE reads files from the MySQL server's permitted folder.
  Check secure_file_priv on your MySQL server.
- This script is organized from the SQL file you supplied. Verify the
  accuracy/completeness of your source CSV data separately.
============================================================
*/


/* =========================================================
   1. DATABASE & TABLE CREATION
   ========================================================= */

CREATE DATABASE IF NOT EXISTS T20WC;
USE T20WC;

-- 1.1 Tournament table
CREATE TABLE tournament (
    tournament_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    host_country VARCHAR(100),
    start_date DATE,
    end_date DATE,
    UNIQUE KEY uq_tournament (name, year)
);

-- 1.2 Teams table
CREATE TABLE teams (
    team_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    short_name VARCHAR(10),
    country VARCHAR(100)
);

-- 1.3 Venues table
CREATE TABLE venues (
    venue_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    country VARCHAR(100),
    UNIQUE KEY uq_venue (name, city, country)
);

-- 1.4 Player table
CREATE TABLE player (
    player_id INT AUTO_INCREMENT PRIMARY KEY,
    team_id INT NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    role ENUM('Batter','Bowler','All-rounder','Wicket-keeper','Unknown')
        DEFAULT 'Unknown',
    batting_style VARCHAR(50),
    bowling_style VARCHAR(50),
    FOREIGN KEY (team_id) REFERENCES teams(team_id)
);

-- 1.5 Match information table
CREATE TABLE match_info (
    match_id INT AUTO_INCREMENT PRIMARY KEY,
    tournament_id INT NOT NULL,
    match_no VARCHAR(20),
    stage ENUM('Group','Super 8','Semi Final','Final','Qualifier','Other')
        DEFAULT 'Group',
    grp VARCHAR(20),
    match_date DATE NOT NULL,
    venue_id INT,
    team1_id INT NOT NULL,
    team2_id INT NOT NULL,
    toss_winner_id INT,
    toss_decision ENUM('bat','bowl'),
    result_type ENUM('normal','tie','no_result','abandoned')
        DEFAULT 'normal',
    winner_team_id INT,
    win_by_runs INT,
    win_by_wkts INT,
    player_of_match VARCHAR(150),
    umpire1 VARCHAR(150),
    umpire2 VARCHAR(150),
    tv_umpire VARCHAR(150),
    referee VARCHAR(150),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tournament_id) REFERENCES tournament(tournament_id),
    FOREIGN KEY (venue_id) REFERENCES venues(venue_id),
    FOREIGN KEY (team1_id) REFERENCES teams(team_id),
    FOREIGN KEY (team2_id) REFERENCES teams(team_id),
    FOREIGN KEY (toss_winner_id) REFERENCES teams(team_id),
    FOREIGN KEY (winner_team_id) REFERENCES teams(team_id)
);

-- 1.6 Innings table
CREATE TABLE innings (
    innings_id INT AUTO_INCREMENT PRIMARY KEY,
    match_id INT NOT NULL,
    innings_no TINYINT NOT NULL,
    batting_team_id INT NOT NULL,
    bowling_team_id INT NOT NULL,
    runs INT NOT NULL DEFAULT 0,
    wickets INT NOT NULL DEFAULT 0,
    overs DECIMAL(4,1) NOT NULL DEFAULT 0.0,
    extras INT NOT NULL DEFAULT 0,
    wides INT NOT NULL DEFAULT 0,
    no_balls INT NOT NULL DEFAULT 0,
    byes INT NOT NULL DEFAULT 0,
    leg_byes INT NOT NULL DEFAULT 0,
    powerplay_runs INT,
    powerplay_overs DECIMAL(4,1),
    FOREIGN KEY (match_id) REFERENCES match_info(match_id),
    FOREIGN KEY (batting_team_id) REFERENCES teams(team_id),
    FOREIGN KEY (bowling_team_id) REFERENCES teams(team_id),
    UNIQUE KEY uq_innings (match_id, innings_no)
);

-- 1.7 Player match statistics table
CREATE TABLE player_match_stats (
    pms_id INT AUTO_INCREMENT PRIMARY KEY,
    match_id INT NOT NULL,
    player_id INT NOT NULL,
    team_id INT NOT NULL,

    -- Batting statistics
    did_bat BOOLEAN DEFAULT FALSE,
    runs_scored INT DEFAULT 0,
    balls_faced INT DEFAULT 0,
    fours INT DEFAULT 0,
    sixes INT DEFAULT 0,
    dismissal VARCHAR(200),
    strike_rate DECIMAL(6,2),

    -- Bowling statistics
    did_bowl BOOLEAN DEFAULT FALSE,
    overs_bowled DECIMAL(4,1) DEFAULT 0.0,
    maidens INT DEFAULT 0,
    runs_conceded INT DEFAULT 0,
    wickets_taken INT DEFAULT 0,
    economy DECIMAL(6,2),

    -- Fielding statistics
    catches INT DEFAULT 0,
    runouts INT DEFAULT 0,
    stumpings INT DEFAULT 0,

    FOREIGN KEY (match_id) REFERENCES match_info(match_id),
    FOREIGN KEY (player_id) REFERENCES player(player_id),
    FOREIGN KEY (team_id) REFERENCES teams(team_id),
    UNIQUE KEY uq_player_match (match_id, player_id)
);


/* =========================================================
   2. DATA INSERTION & CSV IMPORT
   ========================================================= */

USE T20WC;

-- 2.1 Insert tournament information
-- tournament_id is AUTO_INCREMENT, so it is not included.
INSERT INTO tournament
    (name, year, host_country, start_date, end_date)
VALUES
    ('ICC Men''s T20 World Cup', 2026, 'India & Sri Lanka',
     '2026-02-07', '2026-03-08');

-- 2.2 Insert teams
INSERT IGNORE INTO teams (team_id, name, short_name, country)
VALUES
    (1, 'Netherlands', 'NED', 'NED'),
    (2, 'Pakistan', 'PAK', 'PAK'),
    (3, 'West Indies', 'WI', 'WI'),
    (4, 'Scotland', 'SCO', 'SCO'),
    (5, 'India', 'Ind', 'Ind'),
    (6, 'Australia', 'Aus', 'Aus'),
    (7, 'Namibia', 'Nam', 'Nam'),
    (8, 'Zimbabwe', 'Zim', 'Zim'),
    (9, 'Oman', 'Oman', 'Oman'),
    (10, 'England', 'Eng', 'Eng'),
    (11, 'Nepal', 'Nep', 'Nep'),
    (12, 'south-africa', 'sa', 'sa'),
    (13, 'new zealand', 'nz', 'nz'),
    (14, 'Afghanistan', 'afg', 'agf'),
    (15, 'Ireland', 'ire', 'ire'),
    (16, 'Italy', 'ita', 'ita'),
    (17, 'Canada', 'can', 'can'),
    (18, 'United States Of America', 'usa', 'usa'),
    (19, 'United Arab Emirates', 'uae', 'uae'),
    (20, 'Sri Lanka', 'sl', 'sl');

-- 2.3 Insert venues
INSERT IGNORE INTO venues (venue_id, name, city, country)
VALUES
    (1, 'Sinhalese Sports Club Ground', 'Colombo', 'Sri Lanka'),
    (2, 'Eden Gardens', 'Kolkata', 'India'),
    (3, 'Wankhede Stadium', 'Mumbai', 'India'),
    (4, 'M.A. Chidambaram Stadium', 'Chennai', 'India'),
    (5, 'R. Premadasa Stadium', 'Colombo', 'Sri Lanka'),
    (6, 'Narendra Modi Stadium', 'Ahmedabad', 'India'),
    (7, 'Arun Jaitley Stadium', 'Delhi', 'India'),
    (8, 'Pallekele International Cricket Stadium', 'Kandy', 'Sri Lanka');

-- 2.4 Import player data from CSV
-- Update the file path and column order to match your CSV.
-- Expected columns: player_id, team_id, full_name, role, batting_style, bowling_style
/*
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/player_id.csv'
INTO TABLE player
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(player_id, team_id, full_name, role, batting_style, bowling_style);
*/

-- 2.5 Import match information from CSV
-- Use ONE match CSV import only. Update the path and date format as needed.
-- This version expects dates in DD-MM-YYYY format.
/*
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/t20 wc.csv'
INTO TABLE match_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    match_id,
    tournament_id,
    match_no,
    stage,
    grp,
    @match_date,
    venue_id,
    team1_id,
    team2_id,
    @toss_winner_id,
    @toss_decision,
    result_type,
    @winner_team_id,
    @win_by_runs,
    @win_by_wkts,
    player_of_match,
    umpire1,
    umpire2,
    tv_umpire,
    referee,
    notes
)
SET
    match_date = STR_TO_DATE(@match_date, '%d-%m-%Y'),
    toss_winner_id = NULLIF(NULLIF(LOWER(TRIM(@toss_winner_id)), 'null'), ''),
    toss_decision = CASE
        WHEN LOWER(TRIM(@toss_decision)) IN ('bat', 'bowl')
        THEN LOWER(TRIM(@toss_decision))
        ELSE NULL
    END,
    winner_team_id = NULLIF(NULLIF(LOWER(TRIM(@winner_team_id)), 'null'), ''),
    win_by_runs = NULLIF(NULLIF(LOWER(TRIM(@win_by_runs)), 'null'), ''),
    win_by_wkts = NULLIF(NULLIF(LOWER(TRIM(@win_by_wkts)), 'null'), '');
*/

-- 2.6 Import innings data from CSV
-- Update the file path and confirm the CSV column order.
/*
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/innings.csv'
INTO TABLE innings
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    innings_id, match_id, innings_no, batting_team_id, bowling_team_id,
    runs, wickets, overs, extras, wides, no_balls, byes, leg_byes,
    powerplay_runs, powerplay_overs
);
*/

-- 2.7 Import player match statistics from CSV
-- Update the file path and confirm the CSV column order.
-- pms_id is omitted because it is AUTO_INCREMENT.
/*
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/player_match_stat.csv'
INTO TABLE player_match_stats
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    match_id, player_id, team_id, did_bat,
    runs_scored, balls_faced, fours, sixes, dismissal,
    strike_rate, did_bowl, overs_bowled, maidens,
    runs_conceded, wickets_taken, economy,
    catches, runouts, stumpings
);
*/


/* =========================================================
   3. DATA CLEANING & VALIDATION
   ========================================================= */

USE T20WC;

-- 3.1 Capitalize the first letter of each team name
UPDATE teams
SET name = CONCAT(
    UPPER(LEFT(name, 1)),
    LOWER(SUBSTRING(name, 2))
)
WHERE team_id > 0;

-- 3.2 Capitalize the first letter of each country value
UPDATE teams
SET country = CONCAT(
    UPPER(LEFT(country, 1)),
    LOWER(SUBSTRING(country, 2))
)
WHERE team_id > 0;

-- 3.3 Update tournament details
UPDATE tournament
SET
    host_country = 'India & Sri Lanka',
    start_date = '2026-02-07',
    end_date = '2026-03-08'
WHERE tournament_id = 1;

-- 3.4 Check for duplicate player-match records
-- The table has a UNIQUE key on (match_id, player_id).
SELECT
    match_id,
    player_id,
    COUNT(*) AS record_count
FROM player_match_stats
GROUP BY match_id, player_id
HAVING COUNT(*) > 1;

-- 3.5 Check missing player names
SELECT *
FROM player
WHERE full_name IS NULL OR TRIM(full_name) = '';

-- 3.6 Check missing match dates
SELECT *
FROM match_info
WHERE match_date IS NULL;

-- 3.7 Check team records
SELECT * FROM teams;

-- 3.8 Check player records
SELECT * FROM player;

-- 3.9 Check venue records
SELECT * FROM venues;

-- 3.10 Check tournament records
SELECT * FROM tournament;

-- 3.11 Check match records
SELECT * FROM match_info;

-- 3.12 Check innings records
SELECT * FROM innings;

-- 3.13 Check player match statistics
SELECT * FROM player_match_stats;

-- 3.14 Check MySQL server import directory
SHOW VARIABLES LIKE 'secure_file_priv';


/* =========================================================
   4. BASIC SQL QUERIES
   ========================================================= */

-- 4.1 Display all teams
SELECT *
FROM teams;

-- 4.2 Display all players
SELECT *
FROM player;

-- 4.3 Display player ID, name and team ID
SELECT
    player_id,
    full_name,
    team_id
FROM player;

-- Display all venues in serial order
SELECT *
FROM venues
ORDER BY venue_id ASC;

-- 4.4 Display all venues
SELECT *
FROM venues;

-- 4.5 Display all tournament information
SELECT *
FROM tournament;

-- 4.6 Display all matches
SELECT *
FROM match_info;

-- 4.7 Display all innings
SELECT *
FROM innings;

-- 4.8 Display all player match statistics
SELECT *
FROM player_match_stats;

-- 4.9 Find players whose names start with S
SELECT *
FROM player
WHERE full_name LIKE 's%';

-- 4.10 Find all bowlers
SELECT
    full_name,
    team_id,
    role
FROM player
WHERE role = 'Bowler';

-- 4.11 Find all batters
SELECT
    full_name,
    team_id,
    role
FROM player
WHERE role = 'Batter';

-- 4.12 Display player table foreign-key relationship information
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE REFERENCED_TABLE_SCHEMA = 'T20WC'
  AND REFERENCED_TABLE_NAME = 'player';


/* =========================================================
   5. ADVANCED SQL ANALYSIS
   ========================================================= */

-- 5.1 Top 10 run scorers
SELECT
    player.player_id,
    player.full_name,
    SUM(player_match_stats.runs_scored) AS total_runs
FROM player
JOIN player_match_stats
    ON player.player_id = player_match_stats.player_id
GROUP BY player.player_id, player.full_name
ORDER BY total_runs DESC
LIMIT 10;

-- 5.2 Top 10 wicket takers
SELECT
    player.player_id,
    player.full_name,
    SUM(player_match_stats.wickets_taken) AS total_wickets
FROM player
JOIN player_match_stats
    ON player.player_id = player_match_stats.player_id
GROUP BY player.player_id, player.full_name
ORDER BY total_wickets DESC
LIMIT 10;

-- 5.3 Players who scored more than 100 runs in total
SELECT
    player.player_id,
    player.full_name,
    SUM(player_match_stats.runs_scored) AS total_runs
FROM player
JOIN player_match_stats
    ON player.player_id = player_match_stats.player_id
GROUP BY player.player_id, player.full_name
HAVING SUM(player_match_stats.runs_scored) > 100
ORDER BY total_runs DESC;

-- 5.4 Player(s) with the highest total runs
SELECT
    player.player_id,
    player.full_name,
    SUM(player_match_stats.runs_scored) AS total_runs
FROM player
JOIN player_match_stats
    ON player.player_id = player_match_stats.player_id
GROUP BY player.player_id, player.full_name
HAVING SUM(player_match_stats.runs_scored) = (
    SELECT MAX(player_runs)
    FROM (
        SELECT SUM(runs_scored) AS player_runs
        FROM player_match_stats
        GROUP BY player_id
    ) AS highest_player_score
);

-- 5.5 Top 10 batting strike rates (minimum 10 balls faced)
SELECT
    player.player_id,
    player.full_name,
    SUM(player_match_stats.runs_scored) AS total_runs,
    SUM(player_match_stats.balls_faced) AS total_balls,
    ROUND(
        SUM(player_match_stats.runs_scored) * 100.0 /
        NULLIF(SUM(player_match_stats.balls_faced), 0),
        2
    ) AS batting_strike_rate
FROM player_match_stats
JOIN player
    ON player_match_stats.player_id = player.player_id
WHERE player_match_stats.did_bat = 1
GROUP BY player.player_id, player.full_name
HAVING SUM(player_match_stats.balls_faced) >= 10
ORDER BY batting_strike_rate DESC
LIMIT 10;

-- 5.6 Top 10 players by total sixes
SELECT
    player.player_id,
    player.full_name,
    teams.name AS team_name,
    SUM(player_match_stats.runs_scored) AS total_runs,
    SUM(player_match_stats.sixes) AS total_sixes
FROM player_match_stats
JOIN player
    ON player_match_stats.player_id = player.player_id
JOIN teams
    ON player_match_stats.team_id = teams.team_id
GROUP BY player.player_id, player.full_name, teams.name
ORDER BY total_sixes DESC
LIMIT 10;

-- 5.7 Count of 100+ scores by player
-- This counts innings in which a player scored at least 100 runs.
SELECT
    player.player_id,
    player.full_name,
    teams.name AS team_name,
    COUNT(*) AS total_100_plus_scores
FROM player_match_stats
JOIN player
    ON player_match_stats.player_id = player.player_id
JOIN teams
    ON player_match_stats.team_id = teams.team_id
WHERE player_match_stats.runs_scored >= 100
GROUP BY player.player_id, player.full_name, teams.name
ORDER BY total_100_plus_scores DESC;

-- 5.8 Player of the Match for each match
-- match_info.player_of_match stores the player's name in this schema.
SELECT
    match_info.match_id,
    match_info.match_no,
    player.player_id,
    player.full_name AS player_of_match
FROM match_info
JOIN player
    ON match_info.player_of_match = player.full_name
ORDER BY match_info.match_id;

-- 5.9 Average runs per batting innings for each player
SELECT
    player.player_id,
    player.full_name AS player_name,
    SUM(player_match_stats.runs_scored) AS total_runs,
    COUNT(
        CASE WHEN player_match_stats.did_bat = 1 THEN 1 END
    ) AS innings_played,
    ROUND(
        SUM(
            CASE
                WHEN player_match_stats.did_bat = 1
                THEN player_match_stats.runs_scored
                ELSE 0
            END
        ) /
        NULLIF(
            COUNT(CASE WHEN player_match_stats.did_bat = 1 THEN 1 END),
            0
        ),
        2
    ) AS average_runs
FROM player_match_stats
JOIN player
    ON player_match_stats.player_id = player.player_id
GROUP BY player.player_id, player.full_name
ORDER BY average_runs DESC;

-- 5.10 Player-wise batting summary
-- AVG below is average runs per player-match record, including zero scores.
-- For average per batting innings, use query 5.9.
SELECT
    player.player_id,
    player.full_name,
    SUM(player_match_stats.runs_scored) AS total_runs,
    AVG(player_match_stats.runs_scored) AS avg_runs_per_record,
    MAX(player_match_stats.runs_scored) AS maximum_runs_in_a_match,
    MIN(player_match_stats.runs_scored) AS minimum_runs_in_a_match,
    COUNT(player_match_stats.match_id) AS total_records
FROM player_match_stats
JOIN player
    ON player_match_stats.player_id = player.player_id
GROUP BY player.player_id, player.full_name;

-- 5.11 Team-wise batting summary
-- Average is calculated as total team runs divided by distinct players
-- represented in player_match_stats for that team.
SELECT
    teams.name AS team_name,
    SUM(player_match_stats.runs_scored) AS total_runs,
    COUNT(DISTINCT player_match_stats.player_id) AS total_players,
    ROUND(
        SUM(player_match_stats.runs_scored) /
        NULLIF(COUNT(DISTINCT player_match_stats.player_id), 0),
        2
    ) AS avg_runs_per_player,
    MAX(player_match_stats.runs_scored) AS highest_individual_score,
    MIN(player_match_stats.runs_scored) AS lowest_recorded_score
FROM player_match_stats
JOIN teams
    ON player_match_stats.team_id = teams.team_id
GROUP BY teams.team_id, teams.name;

-- 5.12 Player-wise bowling summary
SELECT
    player.player_id,
    player.full_name,
    SUM(player_match_stats.wickets_taken) AS total_wickets,
    AVG(player_match_stats.wickets_taken) AS avg_wickets_per_bowling_appearance,
    MAX(player_match_stats.wickets_taken) AS maximum_wickets_in_a_match,
    MIN(player_match_stats.wickets_taken) AS minimum_wickets_in_a_match,
    COUNT(player_match_stats.match_id) AS bowling_appearances
FROM player_match_stats
JOIN player
    ON player_match_stats.player_id = player.player_id
WHERE player_match_stats.did_bowl = 1
GROUP BY player.player_id, player.full_name;

-- 5.13 Match-wise innings analysis
SELECT
    innings.match_id,
    SUM(innings.runs) AS total_runs,
    AVG(innings.runs) AS avg_runs_per_innings,
    MAX(innings.runs) AS highest_innings_score,
    MIN(innings.runs) AS lowest_innings_score,
    SUM(innings.wickets) AS total_wickets,
    COUNT(innings.innings_id) AS total_innings
FROM innings
GROUP BY innings.match_id;


/* =========================================================
   END OF PROJECT SQL SCRIPT
   ========================================================= */
