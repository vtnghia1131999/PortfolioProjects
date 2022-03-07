/*

Cleaning Data in SQL Queries

*/


Select *
From PorfolioProject..NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

-- 1.
Select SaleDate, CONVERT(date,saledate)
From PorfolioProject..NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(date,saledate)

--2.
ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(date,saledate)

Select SaleDateConverted
From PorfolioProject..NashvilleHousing

 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From PorfolioProject..NashvilleHousing
Order By ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PorfolioProject..NashvilleHousing a
Join PorfolioProject..NashvilleHousing b
	On a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PorfolioProject..NashvilleHousing a
Join PorfolioProject..NashvilleHousing b
	On a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From PorfolioProject..NashvilleHousing
Order By ParcelID


Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress ) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress ) +1, LEN(PropertyAddress)) as City
From PorfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAdress nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAdress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress ) -1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress ) +1, LEN(PropertyAddress)) 

Select *
From PorfolioProject.. NashvilleHousing




Select OwnerAddress
From PorfolioProject.. NashvilleHousing 


Select
PARSENAME(REPLACE(OwnerAddress,',','.'), 3)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 2)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
From PorfolioProject..NashvilleHousing


ALTER TABLE NashvilleHousing
ADD OwnerSlitAddress nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSlitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

ALTER TABLE NashvilleHousing
ADD OwnerSlitCity nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSlitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

ALTER TABLE NashvilleHousing
ADD OwnerSlitState nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSlitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)


--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From PorfolioProject.. NashvilleHousing
Group By SoldAsVacant
Order By 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' then 'Yes'
	   When SoldAsVacant = 'N' then 'No'
	   ELSE SoldAsVacant
	   END
From PorfolioProject.. NashvilleHousing
	

Update PorfolioProject.. NashvilleHousing
SET SoldAsVacant =  CASE When SoldAsVacant = 'Y' then 'Yes'
	   When SoldAsVacant = 'N' then 'No'
	   ELSE SoldAsVacant
	   END



---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From PorfolioProject..NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate



























