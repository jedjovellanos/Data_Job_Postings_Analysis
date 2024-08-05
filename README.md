# Introduction
SQL queries here [project_sql folder](/project_sql/)
# Background

# Tools I Used
- **SQL**
- **PostgreSQL**: Chosen database managemnet system
- **Visual Studio Code**
- **Git & Github**

# The Analysis
### 1. Top Paying Data Analyst Jobs
```sql
SELECT 
    job_id,
    job_title,
    name AS company_name,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM
    job_postings_fact
LEFT JOIN
    company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND 
    --job_location = 'Anywhere' AND
    job_location = 'Tampa, FL' AND    
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10
```
# What I Learned


# Conclusions
### Insights
### Closing Thoughts
