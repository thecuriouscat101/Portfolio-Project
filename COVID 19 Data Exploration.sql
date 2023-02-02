/*
Covid 19 Data Exploration 
Skills used: Joins, Windows Functions, Aggregate Functions, Converting Data Types
*/



SELECT *
FROM Portfolio_Project_1..Covid_Deaths
WHERE continent is not null 
ORDER BY 3,4



-- Select Data that we are going to be starting with


SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM Portfolio_Project_1..Covid_Deaths
WHERE continent is not null 
ORDER BY 1,2



-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country


SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM Portfolio_Project_1..Covid_Deaths
WHERE location like '%India%'
AND continent is not null 
ORDER BY 1,2



-- Total Cases vs Population
-- Shows what percentage of population infected with Covid


SELECT Location, date, Population, total_cases,  (total_cases/population)*100 AS PercentPopulationInfected
FROM Portfolio_Project_1..Covid_Deaths
--WHERE location like '%India%'
ORDER BY 1,2



-- Countries with Highest Infection Rate compared to Population


SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount,  Max((total_cases/population))*100 AS PercentPopulationInfected
FROM Portfolio_Project_1..Covid_Deaths
--WHERE location like '%India%'
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC



-- Countries with Highest Death Count per Population


SELECT Location, MAX(cast(Total_deaths AS int)) AS TotalDeathCount
FROM Portfolio_Project_1..Covid_Deaths
--WHERE location like '%India%'
WHERE continent is not null 
GROUP BY Location
ORDER BY TotalDeathCount DESC



-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population


SELECT continent, MAX(cast(Total_deaths AS int)) AS TotalDeathCount
FROM Portfolio_Project_1..Covid_Deaths
--WHERE location like '%India%'
WHERE continent is not null 
GROUP BY continent
ORDER BY TotalDeathCount DESC



-- GLOBAL NUMBERS


SELECT SUM(new_cases) AS total_cases, SUM(cast(new_deaths AS int)) AS total_deaths, SUM(cast(new_deaths AS int))/SUM(New_Cases)*100 AS DeathPercentage
FROM Portfolio_Project_1..Covid_Deaths
--WHERE location like '%India%'
WHERE continent is not null 
--GROUP BY date
ORDER BY 1,2



-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine


SELECT death.continent, death.location, death.date, death.population, vacc.new_vaccinations
, SUM(CONVERT(bigint, vacc.new_vaccinations)) OVER (Partition by death.Location Order by death.location, death.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM Portfolio_Project_1..Covid_Deaths death
Join Portfolio_Project_1..Covid_Vaccinations vacc
	On death.location = vacc.location
	and death.date = vacc.date
WHERE death.continent is not null 
ORDER BY 2,3

