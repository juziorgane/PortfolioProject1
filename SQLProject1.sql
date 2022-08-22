--Select * 
--From Proflioproject..coviddeath
--Order by 3,4

--Select Data that we are going to be using

Select location,date,total_cases, new_cases, total_deaths,population
From Proflioproject..coviddeath
where continent is not null
order by 1,2
--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid in your country
Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From Proflioproject..coviddeath
Where location like '%states%'
order by 1,2

--Looking at Total Cases vs Population
--Shows what percentage of population got covid 
Select location,date,total_cases,population,(total_cases/population)*100 as CasePercentage
From Proflioproject..coviddeath
--Where location like '%states%'
order by 1,2


--Look at countries with high infection rate compared to population
Select location,population, MAX(total_cases) as HighestInfctionCount, Max((total_cases/population))*100 as PercentagepopulationInfected
From Proflioproject..coviddeath
Group by location,population
order by PercentagepopulationInfected desc

--Showing Countries with Highest Death Count per population

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From Proflioproject..coviddeath
Group by location
order by TotalDeathCount desc

--LET'S BEARK DOWN BY CONTINIENT
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From Proflioproject..coviddeath
Where continent is not NULL
Group by continent
order by TotalDeathCount desc

--GLOBAL NUMBERS

Select SUM(new_cases) as TotalCases,SUM(cast(new_deaths as int)) as TotalDeath,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From Proflioproject..coviddeath
--Where location like '%states%'
Where continent is not null
--Group BY date
order by 1,2


--Looking at the Total Population vs Vaccinations

--Use CTE
with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From Proflioproject..coviddeath dea
Join Proflioproject..covidvaccinations vac
    On dea.location = vac.location
	and dea.date= vac.date
Where dea.continent is not null
--Order by 2,3
)
Select *,(RollingPeopleVaccinated/population)*100
From PopvsVac


--TEMP table
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From Proflioproject..coviddeath dea
Join Proflioproject..covidvaccinations vac
    On dea.location = vac.location
	and dea.date= vac.date
--Where dea.continent is not null
--Order by 2,3

Select *, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated

--Creating View to store data for later visualizations
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From Proflioproject..coviddeath dea
Join Proflioproject..covidvaccinations vac
    On dea.location = vac.location
	and dea.date= vac.date
Where dea.continent is not null
--Order by 2,3

--Save this for later visualizations
Select *
From PercentPopulationVaccinated