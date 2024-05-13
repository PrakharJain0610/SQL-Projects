SELECT * FROM PortfolioProject..Housing

--------------------------------------------
--Standardize Date Format

ALTER TABLE Housing
Add  SaleDate2 Date;

Update Housing
SET SaleDate2 = CONVERT (DATE,SaleDate);

SELECT SaleDate2,CONVERT (DATE,SaleDate) AS SaleDate
FROM PortfolioProject..Housing;

----Populate Property Address Data

SELECT  a.ParcelID, b.ParcelID, a.PropertyAddress,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..Housing a
JOIN PortfolioProject..Housing b
ON a.ParcelID=b.ParcelID
AND a.[UniqueID ]<> b.[UniqueID ]
WHERE a.propertyAddress is null


Update a
SET PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..Housing a
JOIN PortfolioProject..Housing b
ON a.ParcelID=b.ParcelID
AND a.[UniqueID ]<> b.[UniqueID ]
WHERE a.propertyAddress is null
