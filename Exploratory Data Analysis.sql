-- Exploratory Data Analysis

select *
from layoffs_staging2;

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;

select distinct *
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;

select company, SUM(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select MIN(`date`), MIN(`date`)
from layoffs_staging2;

select industry, SUM(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

select country, SUM(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

select year(`date`), SUM(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 desc;

select stage, SUM(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;

with Rolling_total as 
(
select substring(`date`, 1, 7) as `month`, SUM(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`, 1, 7) is not null
group by `month`
order by 1 asc
)
select `month`, total_off,
SUM(total_laid_off) over (order by `month`) as rolling_total
from Rolling_total;

select company, `date`, SUM(total_laid_off)
from layoffs_staging2
group by company, `date`
order by 3 DESC;

with company_year (company, years,total_laid_off)  as
(
select company, `date`, SUM(total_laid_off)
from layoffs_staging2
group by company, `date`
), company_year_Rank as (
select* , dense_rank() over (partition by years order by total_laid_off desc) as rankings
from company_year
where years is not null
)
select *
from company_year_Rank;




