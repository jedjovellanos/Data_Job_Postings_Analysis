/*
Question: What are the most in-demand skills for data analysts?
- Join job postings to inner join table similar to query 2
- Identify the top 5 in-demand skills for DA
- Focus on ALL job postings
- Why? Retrieves the top 5 skills with the highest demand in the job market,
    providing insights into the most valuable skills for job seekers
*/

SELECT
    skills,
    COUNT(skills_job.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim AS skills_job ON job_postings_fact.job_id = skills_job.job_id
INNER JOIN skills_dim AS skills ON skills_job.skill_id = skills.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND
    job_work_from_home = 'True'
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5