/*
Covid 19 DATA EXPLORATION
 
Skills used: Joins, CTE's, Windows Functions, Aggregate Functions, joining 2 tables ,Creating Views, 
*/



CREATE DATABASE PortfolioProject;


SELECT * FROM Portfolioproject.coviddeaths
order by 3,4;

SELECT * FROM portfolioproject.covidvaccination
order by 3,4;


SELECT
 Location , date , total_cases, new_cases, total_deaths , population
FROM portfolioproject.coviddeaths
ORDER BY 1,4 ASC;


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject.CovidDeaths
Where location like '%Nigeria%'
and continent is not null 
order by 1,2;


-- Total Cases vs Population
-- Shows what percentage of population was infected with Covid;

SELECT 
location , date , population, total_cases,
(total_cases/population) * 100 AS DeathPercentage
FROM portfolioproject.coviddeaths
WHERE Location LIKE '%Nigeria%'
ORDER BY 1,3 ;


-- Countries with Highest Infection Rate compared to Population

SELECT 
location , population, 
max(total_cases) AS HighestInfectionCount,
max(total_cases/population) * 100 AS PercentagepopulationInfected
FROM portfolioproject.coviddeaths
GROUP BY Location, Population
ORDER BY PercentagepopulationInfected DESC;


-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

select Continent, sum(total_deaths)
as total_death_count
from portfolioproject.coviddeaths
where continent is not null
group by continent
order by total_death_count ASC;


SELECT 
location , date , total_cases, total_deaths,
(total_deaths/total_cases)*100 AS DeathPercentage
FROM portfolioproject.coviddeaths
WHERE Location LIKE '%Africa%'
ORDER BY 1,3 ;

-- GLOBAL NUMBERS
-- DEATH PERCENTAGE WORLDWIDE
 SELECT SUM(new_cases), sum(new_deaths), 
 sum(new_deaths)/sum(new_cases)*100 AS death_percentage
 from portfolioproject.coviddeaths
 WHERE continent IS NOT NULL;
 
 
-- Total Population vs Vaccinations

---- vaccination table

SELECT * FROM portfolioproject.covidvaccination;

-- Shows Percentage of Population that has recieved at least one Covid Vaccine;


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject.Coviddeaths AS dea
Join PortfolioProject.CovidVaccination AS vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by dea.continent,dea.location;

-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject.CovidDeaths dea
Join PortfolioProject.CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac;



-- Using Temp Table to perform Calculation on Partition By in previous query

-- joining the two tables

SELECT *
FROM portfolioproject.coviddeaths dea
JOIN portfolioproject.coviddeaths vac
    ON dea.location = vac.location
    and dea.date = vac.date;
    
    select * from portfolioproject.covidvaccination;


-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations)OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject.CovidDeaths dea
Join PortfolioProject.CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 



