#Queries used fot Tableau project
#Using MySQL and Tableau 
#Accessing the Tableau visualization's result on https://public.tableau.com/app/profile/nita.sari7480/viz/CovidDashboardProject_16492083889100/Dashboard1

#Global Numbers 
SELECT SUM(new_cases) AS Total_Cases, SUM(cast(new_deaths AS UNSIGNED INT)) AS Total_Deaths, 
SUM(cast(new_deaths AS SIGNED INT))/SUM(New_Cases)*100 AS DeathPercentage
FROM PortfolioProject.coviddata
#WHERE location like '%Indonesia%'
WHERE continent is not null and continent <>''
#GROUP BY date
ORDER BY 1,2;

#Total deaths per continent 
SELECT continent, SUM(cast(new_deaths AS UNSIGNED INT)) AS TotalDeathCount
FROM PortfolioProject.coviddata
#WHERE location like '%Indonesia%'
WHERE continent <>'' and location not in ('World', 'European Union', 'International')
GROUP by continent 
ORDER by TotalDeathCount desc;

#Percent population infected per country
SELECT location, population, MAX(total_cases) AS HighestInfectionCount,
MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProject.coviddata
#WHERE location like '%Indonesia%'
GROUP by location, population
ORDER by PercentPopulationInfected desc;

#Percent population infected 
SELECT location, population, date, MAX(Total_Cases) AS HighestInfectionCount, 
MAX((Total_Cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProject.coviddata
#WHERE location like '%Indonesia%'
where continent is not null and continent <>''
GROUP by location, population, date
ORDER by PercentPopulationInfected desc;












