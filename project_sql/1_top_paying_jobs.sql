/*
Question: What are the top-paying data analyst jobs?
- Identify the top 10 highest-paying DA roles that are available in Tampa or are remote
- Focus on job postings with specific salaries (remove nulls)
- Why? Highlight the top-paying opportunities for data analysts, offering insights into employee
*/

SELECT	
	job_title,
    name AS company_name,
	job_location,
	salary_year_avg
FROM job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND 
    (job_location = 'Tampa, FL' OR
    job_location = 'Anywhere') AND
    salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;