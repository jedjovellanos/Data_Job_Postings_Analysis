/*
Question: What are the top skills based on salary?
- Look at average salary associated with each skill for DA positions
- Focus on roles with specified salaries
- Why? It reveals how different skills impact salary levels for DA and
    helps identify the most financially rewarding skills to acquire/improve
*/

SELECT
    skills,
    ROUND(AVG(salary_year_avg), 0) AS average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim AS skills_job ON job_postings_fact.job_id = skills_job.job_id
INNER JOIN skills_dim AS skills ON skills_job.skill_id = skills.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND
    job_work_from_home = 'True' AND
    salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY average_salary DESC
LIMIT 25