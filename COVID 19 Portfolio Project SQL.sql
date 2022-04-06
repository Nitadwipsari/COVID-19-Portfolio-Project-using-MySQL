#COVID 19 Data Exploration
#I am using MySQL
#Skills used: CTE's, Windows Functions, Aggregate Funtions, Creating Views, Converting Data Types

SELECT * 
FROM CovidCase.`sys-covidcase`
where continent is not null and continent <>''
order by 3,4;

#Select data that going to be starting with
Select location, date, total_cases, new_cases, total_deaths, population
From CovidCase. `sys-covidcase`
where continent is not null and continent <>''
Order by 1,2;

#Total Cases vs Total Deaths 
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidCase. `sys-covidcase`
where continent is not null and continent <>''
Order by 1,2;

#DeathPercentage in Indonesia 
#Shows likelihood of dying if you infected covid in Indonesia 
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidCase. `sys-covidcase`
Where location like '%Indonesia%'
Order by 1,2;

#Total Cases vs Population 
#shows what percentage of population infected with Covid
Select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From CovidCase. `sys-covidcase`
Where location like '%Indonesia%'
Order by 1,2;

#Countries with Highest Infection Rate compared to Population 
Select location, population, MAX(total_cases) as HighestInfectionCount, Max(total_cases/population)*100 as PercentPopulationInfected
From CovidCase. `sys-covidcase`
where continent is not null and continent <>''
Group by location, population
Order by 1,2;

#Countries with Highest Death Count per Population 
Select location, MAX(cast(total_deaths as unsigned INTEGER)) as TotalDeathCount
From CovidCase. `sys-covidcase`
where continent is not null and continent <>''
Group by location
order by TotalDeathCount desc;

#BREAKING THINGS DOWN BY CONTINENT
#showing the continents with the highest death count per population 
Select continent, MAX(cast(total_deaths as unsigned INTEGER)) as TotalDeathCount
From CovidCase. `sys-covidcase`
where continent is not null and continent <>''
Group by continent
order by TotalDeathCount desc;

#Global numbers 
Select date, SUM(new_cases) AS Total_Cases, SUM(new_deaths) AS Total_Deaths, SUM(new_deaths)/ SUM(new_cases)*100 as DeathPercentage
From CovidCase. `sys-covidcase`
where continent is not null and continent <>''
Group by date
Order by 1,2;

#Total CASES 
Select SUM(new_cases) AS Total_Cases, SUM(new_deaths) AS Total_Deaths, SUM(new_deaths)/ SUM(new_cases)*100 as DeathPercentage
From CovidCase. `sys-covidcase`
where continent is not null and continent <>''
Order by 1,2;

#Total Population vs Vaccinations
#Shows Percentage of Population that has received at least one Covid Vaccine
Select continent, location, date, population, new_vaccinations, 
SUM(cast(new_vaccinations as unsigned integer)) OVER(Partition by location order by location, date) as RollingPeopleVaccinated,
(RollingPeopleVaccinated/Population)*100
From CovidCase. `sys-covidcase`
where continent is not null and continent <>''
order by 2,3;

#Uing CTE to perform Calculation on Partition by Previous query
WITH 
PopvsVac (continent, location, date, population,new_vaccination, RollingPeopleVaccinated) 
AS
(
Select continent,location,date,population,new_vaccinations,
SUM(cast(new_vaccinations as unsigned integer)) OVER(Partition by location order by location, date) as RollingPeopleVaccinated
From CovidCase. `sys-covidcase`
where continent is not null and continent <>''
)
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac;

#Creating View to store data for later visualizations
Create View PopvsVac as
Select continent, location,date,population,new_vaccinations
, SUM(cast(new_vaccinations as unsigned int)) OVER (Partition by Location Order by location, Date) as RollingPeopleVaccinated
#, (RollingPeopleVaccinated/population)*100
FROM CovidCase. `sys-covidcase`
where continent is not null and continent <>'';





