--create database cause_death
--use cause_death

--select * from [Causes_Death_Us new]

--select COUNT(*) as jami from [Causes_Death_Us new]

--select top 10 * from [Causes_Death_Us new]

-- 1. Nullarni hisoblaymiz barcha ustunlarda

--select Year from [Causes_Death_Us new]
--where YEAR is null

--select _113_Cause_Name from [Causes_Death_Us new]
--where _113_Cause_Name is null

--select Cause_Name from [Causes_Death_Us new]
--where Cause_Name is null

--select State from [Causes_Death_Us new]
--where State is null

--select Deaths from [Causes_Death_Us new]
--where Deaths is null


--select Age_adjusted_Death_Rate from [Causes_Death_Us new]
--where Age_adjusted_Death_Rate is null

-- Barcha ustunlarni nvarchardan o`z typelariga o`tkazamiz

--select * from [Causes_Death_Us new]

--alter table [Causes_Death_Us new]
--alter column year int;

--alter table [Causes_Death_Us new]
--alter column Age_adjusted_Death_Rate float;

--alter table [Causes_Death_Us new]
--alter column Deaths int;


-- 1-vazifa: Eng ko'p o'lim keltirib chiqargan sabab qaysi? (Cause Name bo'yicha)

--select 
--	Cause_Name, 
--	SUM(Deaths) as jami 
--from [Causes_Death_Us new]
--group by Cause_Name
--order by jami desc

-- 2-vazifa: Yillar bo'yicha jami o'limlar qanday o'zgargan?

--select Year, sum(Deaths) from [Causes_Death_Us new]
--group by Year
--order by Year desc


--3-vazifa: Eng ko'p o'lim bo'lgan Top 5 shtat!

--select top 5 
--	State, 
--	sum(Deaths) as jami 
--from [Causes_Death_Us new]
--where State != 'United States'
--group by State
--order by jami desc

-- 4-vazifa: Har yili eng ko'p o'lim keltirib chiqargan sabab qaysi?
-- Hint: Avval CTE da yillar va sabab bo'yicha o'limlarni hisoblang
-- Keyin ROW_NUMBER() OVER (PARTITION BY Year ORDER BY Deaths DESC) ishlatib har yilda 1-o'rindagini chiqaring

--;with cte as(
--select
--	Year,
--	Cause_Name,
--	SUM(Deaths) as total_deaths
--from [Causes_Death_Us new]
--group by Year, Cause_Name
--)

--select 
--	Year,
--	Cause_Name,
--	ROW_NUMBER() OVER(PARTITION BY year ORDER BY total_deaths desc) as row_num
--from cte


 --faqat har yilda 1-o'rindagini chiqaring
-- ;with cte as (
--	select 
--		Year,
--		Cause_Name,
--		sum(Deaths) as total_deaths
--	from [Causes_Death_Us new]
--	where Cause_Name != 'All Causes'
--	group by Year, Cause_Name
--	),
--	cte2 as (
--	select 
--		Cause_Name,
--		Year,
--		total_deaths,
--		ROW_NUMBER() OVER(PARTITION BY year ORDER BY total_deaths desc) as rn
--	from cte
--	)

--select * from cte2
--where rn = 1


--5-vazifa: Har bir shtat da eng ko'p o'lim keltirib chiqargan sabab qaysi?

--;with cte as(
--	select 
--		Year,
--		Cause_Name,
--		State,
--		SUM(Deaths) as total_deaths
--	from [Causes_Death_Us new]
--	where State != 'United States' and Cause_Name != 'All causes'
--	group by Year, Cause_Name,State
--	)
--	, cte2 as (select 
--		Year,
--		Cause_Name,
--		State,
--		ROW_NUMBER() OVER(PARTITION BY state ORDER BY total_deaths desc) as rn
--	from cte)

--select *
--from cte2
--where rn = 1


--6-vazifa: O'lim darajasi (Age_adjusted_Death_Rate) eng yuqori va eng past 5 ta shtat!

-- Eng yuqori 5 ta shtat


--select 
--	top 5 State,
--	AVG(Age_adjusted_Death_Rate) as avg_rate
--from [Causes_Death_Us new]
--where State != 'United States'
--group by State
--order by avg_rate DESC;

-- Eng past 5 ta shtat

--select
--	top 5 State,
--	AVG(Age_adjusted_Death_Rate) as avg_rate
--from [Causes_Death_Us new]
--where State != 'United States'
--group by State
--order by avg_rate ASC;

-- 7-vazifa: Suitsid (Suicide) o'limlari yillar bo'yicha qanday o'zgargan?

--select
--	Year,
--	Cause_Name,
--	SUM(Deaths) as total_deaths
--from [Causes_Death_Us new]
--where Cause_Name = 'Suicide'
--group by Year, Cause_Name
--order by total_deaths,year asc

-- 8-vazifa: Alzheimer's disease o'limlari yillar bo'yicha o'zgarishi — suitsid bilan solishtiring!

--select
--	Year,
--	Cause_Name,
--	SUM(Deaths) as total_deaths
--from [Causes_Death_Us new]
--WHERE Cause_Name IN ('Suicide', 'Alzheimer''s disease')
--group by Year, Cause_Name
--order by total_deaths,year asc

--9-vazifa: Har bir sabab bo'yicha o'limlarning yillik o'sish foizini hisoblang — LAG funksiyasidan foydalaning!

--;with cte as(
--	select
--		Year,
--		Cause_Name,
--		SUM(Deaths) as total_deaths
--	from [Causes_Death_Us new]
--	where Cause_Name != 'All causes'
--	group by Year, Cause_Name
--	), cte2 as (
--		select 
--			YEAR,
--			cause_name,
--			total_deaths,
--			LAG(total_deaths) OVER(PARTITION BY cause_name ORDER BY year) as prev_year_deaths
--		from cte
--	)

--	select 
--		Year,
--		Cause_Name,
--		total_deaths,
--		prev_year_deaths,
--		ROUND(
--				(total_deaths - prev_year_deaths) * 100.0 / prev_year_deaths,2
--			) as growth_percent
--	from cte2
--	where prev_year_deaths is not null
--	order by Cause_Name, Year;

--10-vazifa — oxirgi!
--LEAD funksiyasini ishlatib — har bir sabab uchun keyingi yilgi o'limlarni ham chiqaring!


--;with cte as (
--	select 
--		Year,
--		Cause_Name,
--		SUM(Deaths) as total_deaths
--	from [Causes_Death_Us new]
--	where Cause_Name != 'All causes'
--	group by Year, Cause_Name
--	), cte2 as
--	(
--	select 
--		YEAR,
--		Cause_Name,
--		total_deaths,
--		LEAD(total_deaths) OVER(PARTITION BY Cause_Name ORDER BY year) as next_year_deaths
--	from cte
--	)

--	select 
--		Year,
--		Cause_Name,
--		total_deaths,
--		next_year_deaths,
--		ROUND((next_year_deaths-total_deaths) * 100.0 / next_year_deaths,2			) as growth_percent
--	from cte2
--	where total_deaths is not null
--	order by Cause_Name, Year

--alter table [Causes_Death_Us new]
--add year_text nvarchar(10);

--update [Causes_Death_Us new]
--set year_text = CAST(Year AS nvarchar(10))