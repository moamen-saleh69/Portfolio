

 ALTER TABLE PortfolioProject.dbo.covidvac
ALTER COLUMN total_vaccinations float;
ALTER TABLE PortfolioProject.dbo.covidvac
ALTER COLUMN new_vaccinations float;
ALTER TABLE PortfolioProject.dbo.coviddeath
ALTER COLUMN date datetime;
ALTER TABLE PortfolioProject.dbo.covidvac
ALTER COLUMN date datetime;

--death percentage in egypt 
  Select location, date, total_cases, total_deaths, 
(total_deaths / NULLIF(total_cases, 0)) *100 as Death_percentage 
From PortfolioProject.dbo.coviddeath
where location = 'egypt'
order by date

--sickness rate in egypt
Select location, date, total_cases, total_deaths, population, (total_cases/population)*100 as infection_rate 
From PortfolioProject.dbo.coviddeath
where location = 'egypt'
order by 6 asc

--countries with highest infection rate 
Select location, population, 
MAX(total_cases / nullif(population,0)) * 100 as highest_infection_rate, max(total_cases) as highest_infection_num 
From PortfolioProject.dbo.coviddeath
Group by Location, population
order by  highest_infection_rate desc

--death rate around the world
Select location, population, max(total_deaths), max(total_deaths/nullif(population,0)) as death_rate
From PortfolioProject.dbo.coviddeath
Group by Location, population
order by death_rate desc

--the number of vaccination compared to population around the world 
SELECT dea.location,dea.population, max(vac.total_vaccinations) AS TOATL_VAC 
  FROM [PortfolioProject].[dbo].[coviddeath] dea 
join PortfolioProject.dbo.covidvac vac
on vac.location= dea.location
and vac.date= dea.date 
group by dea.location, dea.population, vac.total_vaccinations 
order by vac.total_vaccinations asc

--the number of vaccinations in egypt

SELECT dea.location, dea.date, dea.population, vac.total_vaccinations AS TOATL_VAC 
  FROM [PortfolioProject].[dbo].[coviddeath] dea 
join PortfolioProject.dbo.covidvac vac
on vac.location= dea.location
and vac.date= dea.date 
where dea.location like '%egypt%'
group by dea.location, dea.date, dea.population, vac.total_vaccinations 
order by vac.total_vaccinations asc


--Rolling_People_Vaccinated per country

Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as total_People_Vaccinated
From PortfolioProject.dbo.coviddeath dea
Join PortfolioProject..covidvac vac
	On dea.location = vac.location
	and dea.date = vac.date 
	where dea.continent <> ''
order by 2,3

--CTE to detect the percentage of rollingdown for the vaccinated people 

 with pop_vs_vac (continet, location, date, population, new_vaccinations,total_People_Vaccinated)
as (
Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as total_People_Vaccinated
From PortfolioProject.dbo.coviddeath dea
Join PortfolioProject..covidvac vac
	On dea.location = vac.location
	and dea.date = vac.date 
	where dea.continent <> ''
)
Select *, (Total_People_Vaccinated/nullif(population,0))*100 as total_vac_percent
From pop_vs_vac


--temp table 
DROP Table if exists #tempvac
Create Table #tempvac
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #tempvac
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject.dbo.Coviddeath dea
Join PortfolioProject..Covidvac vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent <> ''
Select *, (RollingPeopleVaccinated/nullif(Population,0)) *100
From #tempvac

