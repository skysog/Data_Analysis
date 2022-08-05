SELECT *
FROM Portfolio..CovidDeaths$
where continent is not null
ORDER BY 3,4


--SELECT *
--FROM Portfolio..CovidVaccinations$
--ORDER BY 3,4

-- SELECT DATA THAT WE ARE GOING TO USE
SELECT Location, date, total_cases, population, new_cases, (total_cases/population)*100 as death_percent
from Portfolio..CovidDeaths$
where continent is not null
--where location = 'india'
order by 1,2

--looking at countries which hightest rate of infection w.r.t. population
SELECT Location,MAX(total_cases) as highest_infection_count, population,  MAX((total_cases/population))*100 as percent_pop_infected
from Portfolio..CovidDeaths$
where continent is not null
group by population, location 
--where location = 'india'
order by percent_pop_infected  desc


-- showing countries with highest death count per population
SELECT Location,MAX(cast (total_deaths as int)) as total_death_count
from Portfolio..CovidDeaths$
where continent is not null
group by population, location 
--where location = 'india'
order by total_death_count desc

--showing death count by continents
SELECT  continent,MAX(cast (total_deaths as int)) as total_death_count
from Portfolio..CovidDeaths$
where continent is not null
group by continent
--where location = 'india'
order by total_death_count desc

--global numbers
create view Percentage_Death as
SELECT Location, date, total_cases,total_deaths,  (total_deaths/total_cases)*100 as death_percent
from Portfolio..CovidDeaths$
where continent is not null
--where location = 'india'
order by 1,2


-- looking at total population vs vaccination


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from Portfolio..CovidDeaths$ as dea
join Portfolio..CovidVaccinations$ as vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 1,2,3


