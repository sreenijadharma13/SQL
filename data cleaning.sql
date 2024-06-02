-- Data Cleaning


select *
from layoffs ;

-- Remove Duplicates
-- Standatize  Data
-- Null Values
-- Remove Any Columns


create table layoffs_staging
like layoffs;

select *
from layoffs_staging;

insert layoffs_staging
select *
from layoffs;

SELECT *
FROM layoffs_staging;

SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

with duplicate_cte AS
(
SELECT *,
		ROW_NUMBER() OVER (
			PARTITION BY company,location, industry, 
            total_laid_off, percentage_laid_off, `date`,
            stage, country, funds_raised_millions) AS row_num
	FROM 
		world_layoffs.layoffs_staging
)
delete 
FROM duplicate_cte
WHERE row_num > 1;


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

	
select *
from layoffs_staging2;

 
insert into layoffs_staging2
select*,
ROW_NUMBER() OVER (
			PARTITION BY company,location, industry, 
            total_laid_off, percentage_laid_off, `date`,
            stage, country, funds_raised_millions) AS row_num
	FROM layoffs_staging;

DELETE
from layoffs_staging2
where row_num > 1;

select *
from layoffs_staging2;


-- STANDADIZING DATA

SELECT company, trim(company)
from layoffs_staging2;

update layoffs_staging2
set company = trim(company);

select *
from layoffs_staging2
where industry like 'crypto%';

update layoffs_staging2
set industry = 'crypto'
where industry like 'crypto%';

select distinct industry 
from layoffs_staging2
order by 1;

select *
from layoffs_staging2;

select distinct location 
from layoffs_staging2
order by 1;

select distinct country
from layoffs_staging2
order by 1;

select distinct country, trim( trailing '.' from country)
from layoffs_staging2
order by 1;

update layoffs_staging2
set country = trim( trailing '.' from country)
where country like 'United States%';

select `date`
from layoffs_staging2;

select `date`,
STR_TO_DATE(`date`, '%m/%d/%y')
from layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE STR_TO_DATE(`date`, '%m/%d/%y') IS NULL;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%y');

alter table layoffs_staging2
modify column `date` date;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off is null;

update layoffs_staging2
set industry = null
where industry = '';


select *
from layoffs_staging2
where industry is null
or industry = '';

select * 
from layoffs_staging2
where company like 'bally%';

select * 
from layoffs_staging2 t1
join layoffs_staging2 t2
   on t1.company = t2.company
where (t1.industry is null or t1.industry ='')
and t2.industry is not null;

update layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company = t2.company
set t1.industry = t2.industry
where (t1.industry is null or t1.industry = '')
and t2.industry is not null

select *
from layoffs_staging2;

delete
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off is null;

select *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off is null;

alter table layoffs_staging2
drop column row_num;

select *
from layoffs_staging2;



