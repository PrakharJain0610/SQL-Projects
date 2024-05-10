 select * 
 From PortfolioProject..CovidDeaths
 WHERE continent is not null;

SELECT location,date,total_cases,new_cases,total_deaths,population
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 1,2;

--Total Case vs Total Deaths
SELECT location,date,total_cases,total_deaths , (total_cases/total_deaths)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location ='India'
AND continent is not null
ORDER BY 1,2;

--Looking at countaries with highest infection rate compared to population
SELECT Location,Population,MAX(total_cases) AS HighestInfectionCount , MAX(total_cases/population)*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY location,population
ORDER BY PercentPopulationInfected desc;

--Showing Countries with highest death count
SELECT Location, MAX(cast(Total_Deaths as int )) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc;	

--Showing death count by continent
SELECT continent, MAX(cast(Total_Deaths as int )) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc;	

--Global Numbers
SELECT date,SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths , (SUM(cast(new_deaths as int)) /SUM(new_cases))*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY date
ORDER BY 1,2;

--CTE
WITH PopvsVac (Continent,Location,Date,Population,New_Vaccinations,RollingPeopleVaccinated)
as
(
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) over (Partition By dea.location ORDER BY dea.location,dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac 
ON dea.location=vac.location
and dea.date = vac.date
WHERE dea.continent is not null
)
SELECT *, (RollingPeopleVaccinated/Population)*100 As RollingPeopleVaccinatedPercentage
FROM PopvsVac

--TempTable
DROP Table	if exists #PercentPopulationVaccinated
CREATE Table #PercentPopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar(255),
Date datetime,
Population numeric ,	
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) over (Partition By dea.location ORDER BY dea.location,dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac 
ON dea.location=vac.location
and dea.date = vac.date

SELECT *, (RollingPeopleVaccinated/Population)*100 As RollingPeopleVaccinatedPercentage
FROM #PercentPopulationVaccinated

--Create View
DROP VIEW if exists PercentPopulationVaccinated
Create View PercentPopulationVaccinated as 
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) over (Partition By dea.location ORDER BY dea.location,dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac 
ON dea.location=vac.location
and dea.date = vac.date
Where dea.continent is not null


