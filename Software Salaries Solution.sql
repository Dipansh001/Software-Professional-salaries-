select* from salary_extra_feat

--1: Missing values
/*To get know about missing values*/

select
count(*) as total_rows,
sum(case when  rating  is null  then 1 else 0  end ) as missing_rating,
sum(case when company_name is null then 1 else 0 end) as missing_comp_name,
sum( case when job_title  is null then 1 else 0 end)  as missing_job_t,
sum(case when salary is null then	1 else 0 end ) as missing_salary,
sum(case when salaries_reported is null then 1 else 0 end) as missing_sal_rep,
sum(case when [location] is  null then 1 else 0 end ) missing_location,
sum(case when  employment_status is null then 1 else 0 end) missing_emp_status,
sum(case  when job_roles is null then 1 else 0 end ) missing_job_roles

from salary_extra_feat

--if null values are present then remove it--
delete from software_prof_salaries
where salary  is null or company_name  is null;

--2: Handling Duplicates--
select company_name,job_title,salary,count(*) as counts
from software_prof_salaries 
group by  company_name, job_title,salary
having count(*) > 1;

--above func will not give any value cause i removed all duplicates already--

--Remove Duplicates--
--CTE CMD--
	with cte as(
	select*,
	row_number() 
	over (partition by  company_name,job_title,salary
	order by (select null)) as rn
	from software_prof_salaries
)
delete  from  cte  where rn > 1;

--3. Check Outliers 
select * 
from software_prof_salaries
where salary < 1000 or salary >1000000;

select * from software_prof_salaries
select* from salary_extra_feat

--limit decimal places at 2--
update software_prof_salaries,salary_extra_feat
set rating = round(rating,2)

update salary_extra_feat
set rating = round(rating,2)

--Making salary column int to float to get better understanding--

Alter table  software_prof_salaries
alter column  salary float 

update Software_Prof_Salaries
set salary  = round(salary,2);

------------------------------------------------------------

--1-What is the average salary of employees in the Software_Prof_Salaries table?--
 select round(avg(salary),2) as Avg_emp_Salaries
 from Software_Prof_Salaries;	

--2-  How many employees are there in the salary_extra_feat table?--
select count(*) as  Employees_count
from Salary_extra_feat
 
--3-  What are the minimum and maximum salaries in the Software_Prof_Salaries table?--
select max(salary) as  Max_salary,
MIN(salary) as Min_salary
from Software_Prof_Salaries

--4- How many employees fall into different salary ranges (e.g., 0-50k, 51k-100k, etc.) in the salary_extra_feat table?--
	select 
		case
			when salary between 0 and 50000 then '0-50k'
				when salary between 50001 and 100000 then '50k-1L'
					when salary between 100001 and 500000 then '1L-5L'
					when salary between 500001 and 1000000 then '5L-10L'
					when salary between 1000001 and 5000000 then '10-50L'
					when salary between 5000001 and 10000000 then '50L- 1Cr'
					else 'Above 1Cr'
											
											end as Salary_Range,
										    count(*) as Emp_count
											from salary_extra_feat
											group by 
										    case 
		
	when salary between 0 and 50000 then '0-50k'
	when salary between 50001 and 100000 then '50k-1L'
	when salary between 100001 and 500000 then '1L-5L'
	when salary between 500001 and 1000000 then '5L-10L'
	when salary between 1000001 and 5000000 then '10-50L'
	when salary between 5000001 and 10000000 then '50L- 1Cr'	
	else 'Above 1Cr'
	end
	order by Emp_count;


--5-  What is the count of employees in each job title category in the Software_Prof_Salaries table?--
select job_title as Job_Title, count(*) as emp_count
from Software_Prof_Salaries 
group by Job_Title
order by emp_count desc;

	-- Moderate Questions
	--6- What is the average salary by job title in the Software_Prof_Salaries table?--
		select job_title as Job_Title, round(avg(salary),2) as Avg_Salary
		from Software_Prof_Salaries
		group by Job_Title 
		order by avg_salary desc;

--Top 10--
		select Top 10
			job_title as Job_Title, round(avg(salary),2) as Avg_Salary
				from Software_Prof_Salaries
					group by Job_Title 
						order by avg_salary desc;




--7 -Which job title has the highest reported salary, and what is the salary difference compared to the job title with the lowest reported salary?--
		select  job_title as Job_Title,
				max(salary) Highest_salary,
					min(salary) Lowest_salary,
						max(salary) - min(salary) as Salary_Difference
						 
							from 
								 (select  job_title, salary from Software_Prof_Salaries
								 union all 
								 select job_title,salary from Salary_extra_feat) as combined_salary
									group by Job_Title
									order by Highest_salary desc;
	

--8-  How does years of experience affect salaries in the Software_Prof_Salaries table?--
		
		select  
			rating As Rating,
				round(avg(salary),2) as Avg_Salary,
				round(max(salary),2) as Max_Salary,
				round(min(salary),2) as Min_Salary
		from 
			software_prof_salaries
		group by rating
		order by Rating desc; 
				
--9-  What is the average number of salary reports per employee in the Salary_extra_feat table, and how does it vary by job role?--			 
		select job_roles, avg(salaries_reported) as Avg_salaries_reported
		from  Salary_extra_feat
		group by Job_Roles
		order  by Avg_salaries_reported desc;


--10- What is the distribution of employees across companies with different rating categories (Excellent, Good, Bad, Poor), and how do salaries compare in each category?--
      SELECT 
    CASE 
        WHEN Rating >= 4.5 THEN 'Excellent'
        WHEN Rating >= 3.5 AND Rating < 4.5 THEN 'Good'
        WHEN Rating >= 2.5 AND Rating < 3.5 THEN 'Bad'
        ELSE 'Poor'
    END AS Rating_Category,
    COUNT(*) AS Emp_Count,
    round(AVG(Salary),2) AS Avg_Salary
		FROM  
		    Software_Prof_Salaries
		GROUP BY 
		    CASE 
		        WHEN Rating >= 4.5 THEN 'Excellent'
		        WHEN Rating >= 3.5 AND Rating < 4.5 THEN 'Good'
		        WHEN Rating >= 2.5 AND Rating < 3.5 THEN 'Bad'
		        ELSE 'Poor'
		     end
			 ORDER BY 
			  Rating_Category;


--11-- Which 5 job title has the highest average salary in the Software_Prof_Salaries table?--
		select top 5 job_title as Job_Title, avg(salary) as  Avg_salary
		from Software_Prof_Salaries
		group by Job_Title
		order by  Avg_salary desc 

--------------------------------THANK YOU--------------------------------------------------------------------------
------------------------------Dipanshu Rawat-----------------------------------------------------------------------
-------------------------------DATA ANALYST---------------------------------------------------------------------

     

 



