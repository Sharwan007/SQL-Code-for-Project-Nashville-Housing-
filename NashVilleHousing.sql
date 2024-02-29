select *
from PortfolioProjects..NashvilleHousing

---Standarise Date format

select SaleDate CONVERT(Date,SaleDate)
from PortfolioProject..NashvilleHousing

UPDATE NashvilleHousing
Set SaleDate= CONVERT(Date,SaleDate)

 select *
 from PortfolioProjects..NashvilleHousing
 --where PropertyAddress is NULL
 order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
 from PortfolioProjects..NashvilleHousing a
 join PortfolioProjects..NashvilleHousing b
	on a.ParcelID=b.ParcelID
	And a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
 from PortfolioProjects..NashvilleHousing a
 join PortfolioProjects..NashvilleHousing b
	on a.ParcelID=b.ParcelID
	And a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

select PropertyAddress
from PortfolioProjects..NashvilleHousing

Select
SUBSTRING(PropertyAddress,1, charindex(',',PropertyAddress)-1) As address,
SUBSTRING(PropertyAddress,charindex(',',PropertyAddress)+1,Len(PropertyAddress)) As address
from PortfolioProjects..NashvilleHousing

alter table NashvilleHousing
Add PropertySplitCity nvarchar(255);

update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress,charindex(',',PropertyAddress)+1,Len(PropertyAddress)) 

alter table NashvilleHousing
Add PropertySplitAddress nvarchar(255);

UPDATE NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress,1, charindex(',',PropertyAddress)-1)

select *
from PortfolioProjects..NashvilleHousing




Select OwnerAddress
from PortfolioProjects..NashvilleHousing

select
PARSENAME(Replace(OwnerAddress,',',','),3),
PARSENAME(Replace(OwnerAddress,',',','),2),
PARSENAME(Replace(OwnerAddress,',',','),1)
from PortfolioProjects..NashvilleHousing

alter table NashvilleHousing
Add OwnerSplitAddress nvarchar(255);

UPDATE NashvilleHousing
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',',','),3)

alter table NashvilleHousing
Add OwnerSplitCity nvarchar(255);

UPDATE NashvilleHousing
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',',','),2)

alter table NashvilleHousing
Add OwnerSplitState nvarchar(255);

UPDATE NashvilleHousing
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress,',',','),1)

select distinct(SoldAsVacant),COUNT(SoldAsVacant)
From PortfolioProjects..NashvilleHousing
Group By SoldAsVacant
order by 2

select distinct(SoldAsVacant),
case when SoldAsVacant ='Y' then 'Yes'
	when SoldAsVacant ='N' then 'No'
	else SoldAsVacant
	end
From PortfolioProjects..NashvilleHousing

update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant ='Y' then 'Yes'
	when SoldAsVacant ='N' then 'No'
	else SoldAsVacant
	end
From PortfolioProjects..NashvilleHousing

--Delete Duplicate value

with RowNumCTE
As(
select *,
	ROW_NUMBER() Over(
	partition by ParcelID,
	PropertyAddress,
	Saleprice,
	SaleDate,
	LegalReference
	Order by
		UniqueID) row_num
from PortfolioProjects..NashvilleHousing
--order by ParcelID
)
Select *
from RowNumCTE
where row_num >1
order by PropertyAddress

--Delete unused Column

select *
from PortfolioProjects..NashvilleHousing

Alter table PortfolioProjects..NashvilleHousing
Drop column OwnerAddress,TaxDistrict,PropertyAddress

Alter Table PortfolioProjects.dbo.NashvilleHousing
Drop Column SaleDate


