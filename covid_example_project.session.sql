-- Total deaths vs cases
-- Likelihood of death if contracted (US only)
SELECT
    location,
    date,
    total_cases,
    total_deaths,
    CAST(total_deaths AS FLOAT)/total_cases*100 AS death_percentage
FROM covid_deaths
WHERE 
    location = 'United States' 

-------------------------------------------------------------------------------------------------------------------------------

--Total Cases vs Population
-- shows percentage of population that got covid
SELECT
    location,
    date,
    total_cases,
    population,
    CAST(total_cases AS FLOAT)/population*100 AS percentage_infected
FROM covid_deaths
WHERE 
    location = 'United States' 
ORDER BY
    location, 
    date

-------------------------------------------------------------------------------------------------------------------------------

-- Shows countries with the largest percentage of population infected
SELECT
    location,
    population,    
    MAX(total_cases) AS highest_infection_count, 
    CAST(MAX(total_cases) AS FLOAT)/population*100 AS percentage_population_infected
FROM covid_deaths
GROUP BY
    location, population
ORDER BY
    --CAST(MAX(total_cases) AS FLOAT)/population*100 DESC
    MAX(total_cases) DESC

-------------------------------------------------------------------------------------------------------------------------------

-- Shows continents with highest death count per population
SELECT
    location, 
    --population,
    MAX(total_deaths) AS total_death_count,
    CAST(MAX(total_deaths) AS FLOAT)/population*100 AS percentage_population_deaths
FROM covid_deaths
WHERE 
    continent IS NOT NULL AND
    total_deaths IS NOT NULL 
GROUP BY
    location,
    population
ORDER BY 
    MAX(total_deaths) DESC
    --CAST(MAX(total_deaths) AS FLOAT)/population*100 DESC

-------------------------------------------------------------------------------------------------------------------------------

-- Shows continents with highest death count 
SELECT
    location, 
    MAX(total_deaths) AS total_death_count
FROM covid_deaths
WHERE 
    continent IS NULL AND
    total_deaths IS NOT NULL 
GROUP BY location
ORDER BY MAX(total_deaths) DESC

-------------------------------------------------------------------------------------------------------------------------------

/*
Mortality Rate Analysis 
    - find how mortality rate varies by continent and country
*/

-- by continent
SELECT
    location AS continent,
    SUM(CAST(total_deaths AS FLOAT)) / SUM(total_cases) * 100 AS mortality_rate
FROM covid_deaths
WHERE
    continent IS NULL AND
    total_cases IS NOT NULL AND
    total_deaths IS NOT NULL
GROUP BY location
ORDER BY mortality_rate DESC;

-- by country
SELECT
    location AS country,
    SUM(CAST(total_deaths AS FLOAT)) / SUM(total_cases) * 100 AS mortality_rate
FROM covid_deaths
WHERE
    continent IS NOT NULL AND
    total_cases IS NOT NULL AND
    total_deaths IS NOT NULL
GROUP BY location
ORDER BY mortality_rate DESC;

-------------------------------------------------------------------------------------------------------------------------------

/*
Hospitalization Analysis
    -What are the trends in weekly hospital admissions and 
    weekly ICU admissions per million over time for countries 
    with the highest total cases?
*/

SELECT
    date, 
    location AS country,
    weekly_hosp_admissions_per_million,
    weekly_icu_admissions_per_million
FROM covid_deaths
WHERE 
    continent IS NOT NULL 
    weekly_hosp_admissions_per_million IS NOT NULL AND
    weekly_icu_admissions_per_million IS NOT NULL 
    --AND location = 'Canada' 
        -- uncomment above code to search for specific country
ORDER BY date

-------------------------------------------------------------------------------------------------------------------------------

-- Show total cases and death per day for the entire world
SELECT
    date,
    SUM(new_cases) AS total_cases,
    SUM(new_deaths) AS total_deaths,
    SUM(CAST(new_deaths AS FLOAT))/SUM(new_cases) *100 AS mortality_rate
FROM covid_deaths
WHERE new_cases > 0 AND
    continent IS NOT NULL 
GROUP BY date
ORDER BY 
    date;

-------------------------------------------------------------------------------------------------------------------------------

-- Show total cases and death overall for the entire world
SELECT
    SUM(new_cases) AS total_cases,
    SUM(new_deaths) AS total_deaths,
    SUM(CAST(new_deaths AS FLOAT))/SUM(new_cases) *100 AS mortality_rate
FROM covid_deaths
WHERE new_cases > 0 AND
    continent IS NOT NULL;
    --location = 'World';

-------------------------------------------------------------------------------------------------------------------------------

-- view location and continent info
SELECT
    location,
    continent
FROM covid_deaths
--WHERE continent IS NOT NULL
GROUP BY continent, location
ORDER BY continent, location;

-------------------------------------------------------------------------------------------------------------------------------

-- Find percentage of a country's population that is vaccinated using CTE and TEMP TABLE
-------------------------------------------------------------------------------------------------------------------------------

-- CTE for new variable: rolling_people_vaccinated
WITH population_v_vaccination (continent, country, date, population, new_vaccinations, rolling_people_vaccinated) AS (
    SELECT 
        dea.continent,
        dea.location AS country,
        dea.date,
        dea.population AS total_population,
        vac.new_vaccinations,
        SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location 
            ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
    FROM covid_deaths dea
    JOIN covid_vaccinations vac 
        ON dea.location = vac.location AND
        dea.date = vac.date
    WHERE dea.continent IS NOT NULL
        AND vac.new_vaccinations IS NOT NULL
)
SELECT 
    *,
    (CAST(rolling_people_vaccinated AS FLOAT)/population)*100 AS percentage_vaxxed
FROM population_v_vaccination;

-------------------------------------------------------------------------------------------------------------------------------

-- Find percentage of a country's population that is vaccinated using TEMP TABLE
DROP TABLE IF EXISTS percent_pop_vaxxed;

CREATE TEMPORARY TABLE percent_pop_vaxxed (
    continent VARCHAR(255),
    country VARCHAR(255),
    date TIMESTAMP,
    population INT,
    new_vaccinations INT,
    rolling_people_vaccinations FLOAT
);

INSERT INTO percent_pop_vaxxed
SELECT 
    dea.continent,
    dea.location AS country,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (
        PARTITION BY dea.location 
        ORDER BY dea.location, dea.date)
FROM covid_deaths dea
JOIN covid_vaccinations vac 
    ON dea.location = vac.location AND
    dea.date = vac.date
WHERE dea.continent IS NOT NULL
    AND vac.new_vaccinations IS NOT NULL;

SELECT 
    *,
    (rolling_people_vaccinations/population) * 100 AS percent_vaxxed
FROM percent_pop_vaxxed;


--CREATE A VIEW for later visualizations
CREATE VIEW 

