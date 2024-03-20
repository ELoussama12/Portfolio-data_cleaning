select * 
from nashvillehousing

--Standardize date format 

select SaleDateConv , convert(Date , SaleDate)
from nashvillehousing

update nashvillehousing 
set SaleDate = convert(Date , SaleDate)

ALTER TABLE nashvillehousing
ADD SaleDateConv  Date 

update nashvillehousing 
set SaleDateConv = convert(Date , SaleDate)

--Property Address

select PropertyAddress
from nashvillehousing
order by ParcelID

select a.PropertyAddress , a.ParcelID , b.ParcelID , b.PropertyAddress , ISNULL(a.PropertyAddress,b.PropertyAddress)
from nashvillehousing a
join nashvillehousing b 
on a.ParcelID = b.ParcelID 
and a.[UniqueID]<> b.[UniqueID ]
where a.PropertyAddress is null

update a 
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from nashvillehousing a
join nashvillehousing b 
on a.ParcelID = b.ParcelID 
and a.[UniqueID]<> b.[UniqueID ]
where a.PropertyAddress is null

--Breaking out address into individuals columns


select PropertyAddress
from nashvillehousing

SELECT  
Substring (PropertyAddress , 1 , charindex(',' , PropertyAddress) -1 )as address
,SUBSTRING(PropertyAddress , charindex(',' , PropertyAddress) +1, len(PropertyAddress)) as Address 
from nashvillehousing


ALTER TABLE nashvillehousing
ADD PropertySplitAddress  nvarchar(255) 

update nashvillehousing 
set PropertySplitAddress =SUBSTRING(PropertyAddress , 1 , charindex(',' , PropertyAddress) -1 )

ALTER TABLE nashvillehousing
ADD PropertySplitCity nvarchar(255) 

update nashvillehousing 
set PropertySplitCity = SUBSTRING(PropertyAddress , charindex(',' , PropertyAddress) +1, len(PropertyAddress))

----------------------------------------------------------------------------------------------

select * 
from nashvillehousing

SELECT OwnerAddress 
from nashvillehousing

SELECT
parsename(replace( OwnerAddress ,',' , '.') ,3)
,parsename(replace( OwnerAddress ,',' , '.') ,2)
,parsename(replace( OwnerAddress ,',' , '.') ,1)
from nashvillehousing


ALTER TABLE nashvillehousing
ADD OwnerSplitAddress  nvarchar(255) ;

update nashvillehousing 
set OwnerSplitAddress =parsename(replace( OwnerAddress ,',' , '.') ,3)

ALTER TABLE nashvillehousing
ADD PropertySplitCity nvarchar(255) ;

update nashvillehousing 
set PropertySplitCity = parsename(replace( OwnerAddress ,',' , '.') ,2)


ALTER TABLE nashvillehousing
ADD OwnerSplitState nvarchar(255) ;

update nashvillehousing 
set OwnerSplitState = parsename(replace( OwnerAddress ,',' , '.') ,1)

select * 
from nashvillehousing

-------------------------------------------------------------------
--change Y to YES and N to No 

select distinct (SoldAsVacant) , count(SoldAsVacant)
FROM nashvillehousing
group by SoldAsVacant
order by SoldAsVacant

SELECT SoldAsVacant ,
case 
    when SoldAsVacant =' Y ' then 'Yes' 
	WHEN SoldAsVacant = 'N' then 'No' 
	ELSE SoldAsVacant
end 
from nashvillehousing


UPDATE nashvillehousing
SET SoldAsVacant = case 
    when SoldAsVacant ='Y' then 'Yes' 
	WHEN SoldAsVacant = 'N' then 'No' 
	ELSE SoldAsVacant
end  

-----------------------------------------------------------------------------------------------------------------
                     ---Remove duplicate


with RownumCTE as (
select * ,
row_number() over(
partition by ParcelId,
             PropertyAddress,
			 SalePrice,
			 SaleDate ,
			 LegalReference 
			 order by 
			 UniqueID
			) row_num
from nashvillehousing
--order by ParcelID
)
select * 
from RownumCTE
WHERE row_num > 1
--order by PropertyAddress

----------------------------------------------
----delete unused column 

select *
from nashvillehousing

ALTER TABLE nashvillehousing
DROP COLUMN PropertyAddress , OwnerAddress , LandUse