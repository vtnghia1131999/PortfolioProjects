
SELECT *
FROM PorfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 3,4

--SELECT *
--FROM PorfolioProject..CovidVaccinations
--ORDER BY 3,4


-- Select Data that we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PorfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 1,2


-- Looking at total cases vs total deaths
-- Showing likelihood of dying if you contract covid in your country

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PorfolioProject..CovidDeaths
Where location like 'vietnam'
and continent is not null
ORDER BY 1,2


-- Looking at Total cases vs population

SELECT location, date, total_cases, population, (total_cases/population)*100 as PercentPopulationInfected
FROM PorfolioProject..CovidDeaths
Where location like 'vietnam'
ORDER BY 1,2


-- Looking at countries with highest infection rate compared to Population

SELECT location, MAX(total_cases) as HighestInfectionCount, population, MAX( (total_cases/population) )*100 as PercentPopulationInfected
FROM PorfolioProject..CovidDeaths
--Where location like 'vietnam'
WHERE continent is not null
GROUP BY location, population
ORDER BY PercentPopulationInfected desc


--  BREAK THINGS DOWN BY CONTINENT

-- Showing continents with the highest death count per population

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PorfolioProject..CovidDeaths
--Where location like 'vietnam'
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc 


-- Global numbers

SELECT   Sum(new_cases) as Total_cases, Sum(cast(new_deaths as int)) as Total_deaths , Sum(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercent
FROM PorfolioProject..CovidDeaths
--Where location like 'vietnam'
WHERE continent is not null
--GROUP By date
ORDER BY 1,2


--LOOKING AT TOTAL POPULATION VS VACCINATIONS
-- Hien so luong nguoi duoc tiem tung ngay, tung noi (cong don qua tung ngay)

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) 
OVER (Partition by dea.location ORDER BY dea.location, dea.Date) as RollingPeopleVaccinated
-- ,(RollingPeopleVaccinated/population)*100
FROM PorfolioProject..CovidDeaths dea
JOIN PorfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3


-- Use CTE 
-- if I use  SUM(convert(int,vac.new_vaccinations) will lead to arithmetic overflow => solution: replace int = bigint

With PopvsVac (continent, Location, Date, Population, new_vaccination, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) 
OVER (Partition by dea.location ORDER BY dea.location, dea.Date) as RollingPeopleVaccinated
-- ,(RollingPeopleVaccinated/population)*100
FROM PorfolioProject..CovidDeaths dea
JOIN PorfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
--Order by 2,3
)

Select *, (RollingPeopleVaccinated/population)*100
FROM PopvsVac


-- USE TEMP TABLE


-- DROP Table if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population int,
New_vaccinations int,
RollingPeopleVaccinated int
)
-- if I use SUM(convert(int,vac.new_vaccinations) will lead to arithmetic overflow => sol: replace int = bigint
INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) 
OVER (Partition by dea.location ORDER BY dea.location, dea.Date) as RollingPeopleVaccinated
-- ,(RollingPeopleVaccinated/population)*100
FROM PorfolioProject..CovidDeaths dea
JOIN PorfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
--WHERE dea.continent is not null
--Order by 2,3

SELECT *,  (RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated


-- CREATE VIEW to store data for visualization

--DROP View if exists PercentPopulationVaccinated
CREATE VIEW PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) 
OVER (Partition by dea.location ORDER BY dea.location, dea.Date) as RollingPeopleVaccinated
FROM PorfolioProject..CovidDeaths dea
JOIN PorfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
--Order by 2,3

SELECT *
FROM PercentPopulationVaccinated