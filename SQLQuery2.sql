--cleaning data in sql queries

select *
from Portfolio..Sheet7$

--standardize date format
select SaleDateconverted, convert(date, saledate)
from Portfolio..Sheet7$

update Portfolio..Sheet7$
set SaleDate = CONVERT(date, saledate)

alter table portfolio..sheet7$
add saledateconverted date;

update Portfolio..Sheet7$
set saledateconverted = CONVERT(date, saledate)

-- Property address
select PropertyAddress
from Portfolio..Sheet7$
where PropertyAddress is null


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyaddress, b.PropertyAddress)
from Portfolio..Sheet7$ as a
join Portfolio..Sheet7$ as b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


update a
set propertyaddress = ISNULL(a.propertyaddress, b.PropertyAddress)
from Portfolio..Sheet7$ as a
join Portfolio..Sheet7$ as b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--breaking out address

select PropertyAddress
from Portfolio..Sheet7$
select 
substring(propertyaddress, 1, charindex(',', propertyaddress)-1) as  address
, substring(propertyaddress, charindex(',', propertyaddress ) + 1, len(propertyaddress)) as  address
from Portfolio..Sheet7$

alter table portfolio..sheet7$
add propertysplitaddress nvarchar(255);

update Portfolio..Sheet7$
set propertysplitaddress = substring(propertyaddress, 1, charindex(',', propertyaddress)-1)

alter table portfolio..sheet7$
add propertysplitcity nvarchar(255);

update Portfolio..Sheet7$
set propertysplitcity = substring(propertyaddress, charindex(',', propertyaddress ) + 1, len(propertyaddress))

select OwnerAddress
from Portfolio..Sheet7$

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From Portfolio..Sheet7$


ALTER TABLE Portfolio..Sheet7$
Add OwnerSplitAddress Nvarchar(255);

Update Portfolio..Sheet7$
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE Portfolio..Sheet7$
Add OwnerSplitCity Nvarchar(255);

Update Portfolio..Sheet7$
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE Portfolio..Sheet7$
Add OwnerSplitState Nvarchar(255);

Update Portfolio..Sheet7$
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From Portfolio..Sheet7$





-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Portfolio..Sheet7$
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From Portfolio..Sheet7$


Update Portfolio..Sheet7$
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END







-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From Portfolio..Sheet7$
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From Portfolio..Sheet7$