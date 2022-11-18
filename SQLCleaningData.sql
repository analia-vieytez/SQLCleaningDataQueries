/*
Cleaning Data in SQL Queries
*/


Select *
From PortfolioProject.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------
--Change Date Format

--Visualize change
Select SaleDate, CONVERT(Date,SaleDate)
from  PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

select top 1 * from PortfolioProject.dbo.NashvilleHousing

--Populate Property Address data

select *
from PortfolioProject.dbo.NashvilleHousing
where PropertyAddress is null


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID]
where  a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID]

select  * from PortfolioProject.dbo.NashvilleHousing
where PropertyAddress is not null


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address, 
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as City
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


select top 1 * from PortfolioProject.dbo.NashvilleHousing


--Split OwnerAddress into Individual Columns (Address, City, State)


Select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing


select
PARSENAME(REPLACE(OwnerAddress, ',', '.'),1),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
from PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerAddressState Nvarchar(255);

Update NashvilleHousing
SET OwnerAddressState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)

ALTER TABLE NashvilleHousing
Add OwnerAddressCity Nvarchar(255);

Update NashvilleHousing
SET OwnerAddressCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

ALTER TABLE NashvilleHousing
Add OwnerAddressStreet Nvarchar(255)

Update NashvilleHousing
SET OwnerAddressStreet = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)


select top 1 * from NashvilleHousing
--------------------------------------------------------------------------------------------------------------


--Fill OwnerAddress null

select a.ParcelID, a.OwnerAddress, b.ParcelID, b.OwnerAddress, ISNULL(a.OwnerAddress, b.OwnerAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID]
where  a.OwnerAddress is null

Update a
SET OwnerAddress = ISNULL(a.OwnerAddress, b.OwnerAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID]



select distinct(SoldAsVacant), count(SoldAsVacant) from NashvilleHousing
Group by SoldAsVacant
Order by count(SoldAsVacant)


select SoldAsVacant,
Case When SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	ELSE SoldAsVacant
	END
from PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = Case When SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	ELSE SoldAsVacant
	END

-------------------------------------------------------------------------------------------------------------------------------
--Remove duplicates (for practice not considered standard practice)

WITH RowNumCTE AS(
select *,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
			 PropertyAddress,
			 SalePrice,
			 LegalReference
			 ORDER BY UniqueID
			 ) row_num
from PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
DELETE 
FROM  RowNumCTE
Where row_num > 1;


SELECT * 
FROM  PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate