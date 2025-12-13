--As all of my data were "accidentaly" imported as 'varchar', i have to go through some unneccessary Altring on need


select *
from PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning ]

Alter table PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning]
Alter column uniqueid numeric 

--Fixing column to Date only

Alter table PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning]
Alter column saledate date

--Adding a column with a differnet value to keep the initial column 
 
 Alter table PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning ]
 Add Sale_price_converted decimal
UPDATE PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning ]
SET Sale_price_converted = CONVERT(decimal(18,2), REPLACE(REPLACE(SalePrice, ',', ''), '$', ''))

--Fixing Property_Address data


select PropertyAddress
from PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning ]
where PropertyAddress = '' 
or PropertyAddress is null

Select Nashville_A.[UniqueID ], Nashville_A.ParcelID, Nashville_A.PropertyAddress, Nashville_B.ParcelID, Nashville_B.PropertyAddress, ISNULL(NULLIF(Nashville_A.PropertyAddress,''),Nashville_B.PropertyAddress)
From PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning ] Nashville_A
join PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning ] Nashville_B
on Nashville_A.ParcelID = Nashville_B.ParcelID
and Nashville_A.[UniqueID ] <> Nashville_B.[UniqueID ]
where Nashville_A.PropertyAddress = '' 
or Nashville_A.PropertyAddress is null
--Here my sql was bugged because of long alias so i had to change it
UPDATE a
SET PropertyAddress = ISNULL(NULLIF(a.PropertyAddress, ''), b.PropertyAddress)
FROM PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning ] a
JOIN PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning ] b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress = '' 
OR a.PropertyAddress IS NULL


--Breaking data individually

select PropertyAddress
from PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning ]


Select 
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) as city

from PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning ]

Alter table PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning ]
 Add Address varchar(250)
 Update PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning ]
 set Address = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) 


 Alter table PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning ]
 Add Address_city varchar(250)
 Update PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning ]
 set Address_city = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) 

  --For owner address (another method)
  
  select OwnerAddress
  from PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning ]
  
  
  Select
  PARSENAME (Replace(owneraddress,',','.'),3), 
  PARSENAME (Replace(owneraddress,',','.'),2), 
  PARSENAME (Replace(owneraddress,',','.'),1)
   From PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning ]

   Alter table PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning ]
 Add Owner_Address_Street varchar(250)
 Update PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning ]
 set Owner_Address_Street = PARSENAME (Replace(owneraddress,',','.'),3)


 Alter table PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning ]
 Add Owner_Address_city varchar(250)
 Update PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning ]
 set Owner_Address_city = PARSENAME (Replace(owneraddress,',','.'),2)


 Alter table PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning ]
 Add Owner_Address_State varchar(250)
 Update PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning ]
 set Owner_Address_State = PARSENAME (Replace(owneraddress,',','.'),1)

 --Some more fixing 


 select SoldAsVacant, count(SoldAsVacant)
  From PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning ]
 Group by SoldAsVacant
  

select SoldAsVacant,
Case When SoldAsVacant = 'N' then 'No'
When SoldAsVacant = 'Y' then 'Yes'
Else SoldAsVacant
End
 From PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning ]

 Update PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning ]
 set SoldAsVacant =
 Case When SoldAsVacant = 'N' then 'No'
When SoldAsVacant = 'Y' then 'Yes'
Else SoldAsVacant
End




