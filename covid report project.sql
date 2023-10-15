--Q. Looking at total cases vs total deaths in India.
select location, date, total_cases,total_deaths,
 ((total_deaths*1.0)/(total_cases*1.0))*100.00 as deathpercentage
from covid_deaths
where location like 'India'
order by location, date

----------------------------------------------------------------------------
--Q. looking at total cases vs total population in india
select location, date, total_cases, population,
 ((total_cases*1.0)/(population*1.0))*100.00 as casepercentage
from covid_deaths
where location like 'India'
order by location, date


----------------------------------------------------------------------------
--Q. Looking at highest infection rate country wise
select location, population,
max(total_cases) as highestinfectioncount, 
max((total_cases*1.0)/(population*1.0))*100 as infectionrate
from covid_deaths
group by location, population
order by infectionrate desc


----------------------------------------------------------------------------
--Q. Showing countries with highest death count per population
select location, population,
max(cast(total_deaths as double precision)) as highestmortalitycount
from covid_deaths
where continent !='null'
group by location, population
order by highestmortalitycount desc


----------------------------------------------------------------------------
--Q. looking at death rate countrywise
select location, population,
max(total_deaths) as highestmortalitycount,
max((total_deaths*1.0)/(population*1.0))*100 as deathrate
from covid_deaths
group by location, population
order by deathrate desc


-----------------------------------------------------------------------------
--Q. showing covid infection continent wise to contain it within continents
select location,
max(cast(total_deaths as int)) as totaldeathcount
from covid_deaths
where continent is null
group by location
order by 2 desc


-----------------------------------------------------------------------------
--Q. Showing new mortality rate globally
select date,sum(new_cases) as new_cases,
sum(new_deaths) as new_deaths,
sum((new_deaths*1.0)/(population*1.0))*100 as newmortalityrate
from covid_deaths
where continent is not null 
group by date
order by 4 desc

-----------------------------------------------------------------------------
--Q. Showing progression of total vaccination percentage of each individual country 
with cte as 
(
select cd.continent, cd.location, cd.date, cd.population, 
cv.new_vaccinations,
sum(cv.new_vaccinations) over(partition by cd.location order by cd.location,cd.date) as vaccinationcount
from covid_deaths cd
join covid_vaccinations cv
on cd.location=cv.location
and cd.date =cv.date
where cd.continent is not null
)
select *,
((cte.vaccinationcount*1.0)/(cte.population*1.0))*100 as vaccpercentage
from cte
order by 2,3




