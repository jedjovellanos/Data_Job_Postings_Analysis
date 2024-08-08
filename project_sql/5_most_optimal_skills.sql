/*
Question: What are the most optimal skills to learn (high demand and paying)
- Identify skills in high demand and associated with high salaries for DA roles
- Concentrate on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries)
    to offer strategic insights for future career development in DA
*/

-- more concise version of the query
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
GROUP BY skills_dim.skill_id
HAVING COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 10;


-- original query
/*
WITH skills_demand AS (
    SELECT
        skills.skill_id,
        skills.skills,
        COUNT(skills_job.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim AS skills_job ON job_postings_fact.job_id = skills_job.job_id
    INNER JOIN skills_dim AS skills ON skills_job.skill_id = skills.skill_id
    WHERE 
        job_title_short = 'Data Analyst' AND
        job_work_from_home = 'True' AND
        salary_year_avg IS NOT NULL
    GROUP BY skills.skill_id
), average_salary AS (
    SELECT
        skills_job.skill_id,
        ROUND(AVG(salary_year_avg), 0) AS average_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim AS skills_job ON job_postings_fact.job_id = skills_job.job_id
    INNER JOIN skills_dim AS skills ON skills_job.skill_id = skills.skill_id
    WHERE 
        job_title_short = 'Data Analyst' AND
        job_work_from_home = 'True' AND
        salary_year_avg IS NOT NULL
    GROUP BY skills_job.skill_id
)

SELECT 
    skills_demand.skills,
    demand_count,
    average_salary
FROM
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE
    demand_count > 10
ORDER BY 
    average_salary DESC
LIMIT 25
*/

