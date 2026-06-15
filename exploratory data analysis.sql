-- =========================================================================
-- EXPLORATORY DATA ANALYSIS (EDA)
-- Goal: Find trends, patterns, and interesting facts in the layoff data.
-- =========================================================================

-- Just look at all the clean data first
SELECT * FROM world_layoffs.layoffs_staging2;


-- -------------------------------------------------------------------------
-- PART 1: SIMPLE EXTREMES (Finding the highest and lowest numbers)
-- -------------------------------------------------------------------------

-- 1. What was the highest number of people laid off in a single day?
SELECT MAX(total_laid_off)
FROM world_layoffs.layoffs_staging2;

-- 2. What were the maximum and minimum percentages laid off?
SELECT MAX(percentage_laid_off), MIN(percentage_laid_off)
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off IS NOT NULL;

-- 3. Which companies laid off 100% of their staff (percentage_laid_off = 1)?
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off = 1;

-- 4. See those 100% layoff companies, ordered by who raised the most money (biggest failures)
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;


-- -------------------------------------------------------------------------
-- PART 2: SUMMARY GROUPS (Using GROUP BY to add up total layoffs)
-- -------------------------------------------------------------------------

-- 5. Top 5 companies with the biggest single-day layoffs
SELECT company, total_laid_off
FROM world_layoffs.layoffs_staging2
ORDER BY total_laid_off DESC
LIMIT 5;

-- 6. Top 10 companies with the most total layoffs across the whole dataset
SELECT company, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY SUM(total_laid_off) DESC
LIMIT 10;

-- 7. Top 10 cities/locations with the most total layoffs
SELECT location, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY location
ORDER BY SUM(total_laid_off) DESC
LIMIT 10;

-- 8. Total layoffs by country
SELECT country, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY country
ORDER BY SUM(total_laid_off) DESC;

-- 9. Total layoffs globally by year
SELECT YEAR(date), SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
WHERE date IS NOT NULL
GROUP BY YEAR(date)
ORDER BY YEAR(date) ASC;

-- 10. Total layoffs by industry (Which sector got hit the hardest?)
SELECT industry, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY industry
ORDER BY SUM(total_laid_off) DESC;

-- 11. Total layoffs by company stage (e.g., Post-IPO, Series B, Seed)
SELECT stage, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY stage
ORDER BY SUM(total_laid_off) DESC;


-- -------------------------------------------------------------------------
-- PART 3: ADVANCED ANALYSIS (Using Rankings and Rolling Totals)
-- -------------------------------------------------------------------------

-- 12. Top 3 companies with the most layoffs for EACH individual year
WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM world_layoffs.layoffs_staging2
  WHERE date IS NOT NULL
  GROUP BY company, YEAR(date)
), 
Company_Year_Rank AS 
(
  SELECT company, years, total_laid_off, 
         DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
ORDER BY years ASC, total_laid_off DESC;


-- 13. See total layoffs broken down month-by-month
SELECT SUBSTRING(date,1,7) AS dates, SUM(total_laid_off) AS total_laid_off
FROM world_layoffs.layoffs_staging2
WHERE date IS NOT NULL
GROUP BY dates
ORDER BY dates ASC;


-- 14. Rolling total: See how layoffs accumulated month-over-month over time
WITH DATE_CTE AS 
(
  SELECT SUBSTRING(date,1,7) AS dates, SUM(total_laid_off) AS total_laid_off
  FROM world_layoffs.layoffs_staging2
  WHERE date IS NOT NULL
  GROUP BY dates
  ORDER BY dates ASC
)
SELECT dates, 
       SUM(total_laid_off) OVER (ORDER BY dates ASC) AS rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC;