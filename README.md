# ICC Men's T20 World Cup 2026 — MySQL Database Project

## Project Overview

This project is a MySQL database designed to store and analyse information for the ICC Men's T20 World Cup 2026. It organizes tournament details, teams, players, venues, match information, innings, and player-wise match statistics.

The project also contains SQL queries for basic data retrieval, data validation, and cricket-statistics analysis.

## Technologies Used

- **Database:** MySQL
- **Database Tool:** MySQL Workbench
- **Data Preparation / Import:** Microsoft Excel and CSV files
- **Query Language:** SQL

## Database Tables

The database name is `T20WC`. It contains the following seven tables:

| Table | Purpose |
|---|---|
| `tournament` | Stores tournament name, year, host country, and dates |
| `teams` | Stores team names, short names, and country values |
| `venues` | Stores stadium/venue names, cities, and countries |
| `player` | Stores player details, team IDs, roles, and playing styles |
| `match_info` | Stores match number, stage, date, teams, toss, result, and officials |
| `innings` | Stores innings-level scores, wickets, overs, extras, and powerplay details |
| `player_match_stats` | Stores each player's batting, bowling, and fielding statistics for a match |

## Project Structure

The organized SQL script is divided into five sections:

1. **Database & Table Creation** — creates the `T20WC` database and its seven tables.
2. **Data Insertion & CSV Import** — inserts tournament, team, and venue records and provides CSV import templates.
3. **Data Cleaning & Validation** — includes queries to standardize values and check records.
4. **Basic SQL Queries** — displays teams, players, venues, matches, innings, and player statistics.
5. **Advanced SQL Analysis** — analyses run scorers, wicket takers, strike rates, sixes, 100+ scores, player-of-the-match records, averages, and team/bowling/innings summaries.

## Key Analysis

The SQL script includes queries to:

- Find the top 10 run scorers.
- Find the top 10 wicket takers.
- Identify players with the highest total runs.
- Find top batting strike rates (with a minimum balls-faced condition).
- Find players with the most sixes.
- Count each player's 100+ scores.
- Display the Player of the Match for each match.
- Calculate average runs per batting innings.
- Prepare player-wise batting and bowling summaries.
- Prepare team-wise batting summaries.
- Analyse match innings.

## How to Run the Project

1. Install MySQL Server and open MySQL Workbench.
2. Open `T20WC_Database_Project_Organized.sql`.
3. Run **Section 1** first to create the database and tables.
4. Run the required statements in **Section 2** to insert the initial records.
5. For CSV imports, place the CSV files in the folder permitted by MySQL's `secure_file_priv` setting, or configure an appropriate import method.
6. Open the commented `LOAD DATA INFILE` examples in Section 2, update the file paths and column order to match your own CSV files, and run only the relevant import statement for each table.
7. Run Sections 3, 4, and 5 to validate the data and perform analysis.

> **Important:** The CSV import statements in the organized SQL script are kept inside comments intentionally. Update the file paths and verify the CSV column order before uncommenting and running them. Do not import the same data more than once, as this may create duplicate records.

## Repository Files

Suggested GitHub repository structure:

```text
T20-World-Cup-2026-SQL-Project/
│
├── T20WC_Database_Project_Organized.sql
├── README.md
└── data/
    ├── teams.csv
    ├── players.csv
    ├── venues.csv
    ├── match_info.csv
    ├── innings.csv
    └── player_match_stats.csv
```

Add the `data/` folder and CSV files only if you intend to share those files in the repository.

## Learning Outcomes

Through this project, I practised:

- Creating relational database tables.
- Defining primary keys, foreign keys, unique constraints, and data types.
- Importing data from CSV files into MySQL.
- Cleaning and validating database records.
- Writing SQL queries using `SELECT`, `WHERE`, `ORDER BY`, `GROUP BY`, aggregate functions, and joins.
- Analysing cricket batting, bowling, and fielding statistics.

## Notes

- The SQL script is organized for learning and project demonstration.
- Before running it on an existing database, check whether the tables already exist. The table creation statements are intended for a fresh project setup and are not designed to be run repeatedly without preparation.
- The accuracy of the analysis depends on the completeness and correctness of the CSV data imported into the database.
