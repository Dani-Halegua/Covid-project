ALTER TABLE DBcovidDeaths 
RENAME TO deaths;

ALTER TABLE DBcovidVaccinations 
RENAME TO vax;

--Visualise la database

Select * From deaths
order by 2,3

-- Montre la probabilité de déces si on attrape le covid en France
-- On voit sur la dernière ligne qu'à l'heure actuelle, le taux de létalité du covid en France est de 0.4 soit 1/250

Select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From deaths
Where location = 'France'
order by 1,2

-- Pays avec le + de cas covid

Select location, MAX(total_cases) as nb_cases ,total_deaths
From deaths
where continent is not null
Group by location
order by 2 desc

-- Pays avec le + de décès

Select location, total_cases,MAX(total_deaths) as nb_deaths
From deaths
where continent is not null
Group by location
order by 3 desc


--Pays avec le + fort taux de létalité (case fatality rate= nb de décès/nb de cas); France = 0.4%

Select location, MAX(total_cases) as nb_cases ,MAX(total_deaths) as nb_deaths, (MAX(total_deaths)/MAX(total_cases))*100 as CaseFatalityRate
From deaths
where continent is not null
Group by location
order by 4 desc


-- Pays avec le + fort taux de mortalité (nb de décès / population); France = 0.24%
-- On join les 2 tables por récup la population qui se trouve dans la 2e table

Select deaths.location, deaths.date, vax.population, MAX(deaths.total_deaths) as nb_deaths, MAX(deaths.total_deaths/vax.population)*100 as MortalityRate
from deaths
join vax
On deaths.location = vax.location
and deaths.date = vax.date
where deaths.continent is not null
Group by deaths.location
order by 5 desc

-- Pays avec le % d'infection le + élevé
--On JOIN les 2 databases car on veut récup la population qui se trouve dans la table vax
-- % d'infection de la France = 57%

Select deaths.location, deaths.date, vax.population, MAX(deaths.total_cases) as nb_cases, MAX(deaths.total_cases/vax.population)*100 as infectionRate
from deaths
join vax
On deaths.location = vax.location
and deaths.date = vax.date
where deaths.continent is not null
Group by deaths.location
order by 5 desc

-- visualise la table des vaccinations

select * from vax
where location = 'France'
order by 3

-- pourcentage de gens vaccinés par pays; France = 78%

Select location, date, population,  MAX(people_fully_vaccinated) as NbPeopleVaccinated, MAX(people_fully_vaccinated)/population * 100 as VaxPercentage
from vax
where continent is not null
group by location
order by 5 desc



