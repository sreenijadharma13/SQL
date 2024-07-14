/*
Covid 19 Data Exploration 
*/
Select *
From portfolioproject.coviddeaths
Where continent is not null 
order by 3,4;

Select Location, date, total_cases, new_cases, total_deaths, population
From portfolioproject.coviddeaths
Where continent is not null 
order by 1,2;

Select Location, date,
 total_cases,total_deaths, (CAST(total_deaths as FLOAT)/CAST(total_cases AS FLOAT))*100 as DeathPercentage
From portfolioproject.coviddeaths
order by 1,2;

-- Total Cases vs Population
Select Location, date, Population, total_cases, (CAST(total_deaths as FLOAT)/CAST(total_cases AS FLOAT))*100 as PercentPopulationInfected
From portfolioproject.coviddeaths
order by 1,2;

-- Countries with Highest Infection Rate compared to Population
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From portfolioproject.coviddeaths
Group by Location, Population
order by PercentPopulationInfected desc;

-- Countries with Highest Death Count per Population
Select Location, MAX((Total_deaths)) as TotalDeathCount
From portfolioproject.coviddeaths
Group by Location
order by TotalDeathCount desc;

-- BREAKING THINGS DOWN BY CONTINENT
Select continent, MAX(Total_deaths) as TotalDeathCount
From portfolioproject.coviddeaths
-- Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc;

-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths )/SUM(New_Cases)*100 as DeathPercentage
From portfolioproject.coviddeaths
-- Where location like '%states%'
where continent is not null 
-- Group By date
order by 1,2;

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
From portfolioproject.coviddeaths dea
Join portfolioproject.vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3;

-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
From portfolioproject.coviddeaths dea
Join portfolioproject.vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
-- order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac;

DROP TABLE PercentPopulationVaccinated;
CREATE TABLE PercentPopulationVaccinated 
(
  Continent nvarchar(255),
  Location nvarchar(255),
  Date date,  -- Consider using a specific date data type
  Population numeric,
  New_vaccinations numeric,
  RollingPeopleVaccinated numeric
);

Insert into PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
From  portfolioproject.coviddeaths dea
Join portfolioproject.vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date;
-- where dea.continent is not null 
-- order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated;

-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From  portfolioproject.coviddeaths dea
Join portfolioproject.vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 



