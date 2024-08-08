
--------------------------------------------------------------------------------------------

SELECT * from top10_paying_jobs
ORDER BY salary_year_avg DESC

---------------------------------------------------------------
DROP VIEW top10_paying_jobs;
CREATE VIEW top10_paying_jobs AS 
SELECT	
	job_title,
    name AS company_name,
	job_location,
	salary_year_avg
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND 
    (job_location = 'Tampa, FL' OR
    job_location = 'Anywhere') AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
--------------------------------------------------------------------------------------------

SELECT * from top10_paying_skills;

---------------------------------------------------------------
DROP VIEW top10_paying_skills;
CREATE VIEW top10_paying_skills AS
WITH top10_paying_jobs AS (
    SELECT	
        job_id,
        job_title,
        name AS company_name,
        job_location,
        salary_year_avg
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND 
        (job_location = 'Tampa, FL' OR
        job_location = 'Anywhere') AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top10_paying_jobs.job_id,
    top10_paying_jobs.job_title,
    top10_paying_jobs.salary_year_avg,
    skills,
    COUNT(skills_dim.skills) OVER (PARTITION BY skills_dim.skills) AS skill_count
FROM top10_paying_jobs
INNER JOIN skills_job_dim ON top10_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY skill_count DESC;
---------------------------------------------------------------------------
SELECT 
    job_postings.job_id,
    job_postings.job_title,
    job_postings.salary_year_avg,
    skills_dim.skills
FROM job_postings_fact AS job_postings
INNER JOIN skills_job_dim ON job_postings.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND 
    (job_location = 'Tampa, FL' OR
    job_location = 'Anywhere') AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC;



--------------------------------------------------------------------------------------------

SELECT * from top5_demanded_skills;

---------------------------------------------------------------
CREATE VIEW top5_demanded_skills AS
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    (job_location = 'Tampa, FL' OR
    job_location = 'Anywhere')
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;

--------------------------------------------------------------------------------------------

SELECT * from top_skills_by_salary;

---------------------------------------------------------------
CREATE VIEW top_skills_by_salary AS
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    (job_location = 'Tampa, FL' OR
    job_location = 'Anywhere') AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 10;

--------------------------------------------------------------------------------------------

SELECT * from top_skills_by_demand_and_salary
ORDER BY    
    avg_salary DESC,
    demand_count DESC;

---------------------------------------------------------------
CREATE VIEW top_skills_by_demand_and_salary AS
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    (job_location = 'Tampa, FL' OR
    job_location = 'Anywhere') AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    --avg_salary DESC,
    demand_count DESC
LIMIT 25;


select job_title_short, COUNT(job_title_short) as count
FROM job_postings_fact
group by job_title_short
order by count