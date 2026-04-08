-- 1.1 Total Listings, Average Price, Avg Listing Age

SELECT
    COUNT(fl.listing_id)              AS total_listings,
    AVG(CAST(fl.DemandPKR AS BIGINT)) AS avg_price_pkr,
    AVG(CAST(fl.ListingAgeDays AS INT)) AS avg_listing_age_days
FROM fact_listings fl;

-- 2.1 Average Price by Brand (Top Brands)

SELECT
    crd.Brand,
    COUNT(fl.listing_id) AS total_listings,
    AVG(CAST(fl.DemandPKR AS BIGINT)) AS avg_price_pkr
FROM fact_listings fl
JOIN dim_car crd ON fl.car_dim_id = crd.car_id
GROUP BY crd.Brand
ORDER BY avg_price_pkr DESC;

-- 2.2 Price Distribution by City

SELECT
    dloc.City,
    COUNT(fl.listing_id) AS total_listings,
    AVG(CAST(fl.DemandPKR AS BIGINT)) AS avg_price_pkr
FROM fact_listings fl
JOIN dim_location dloc ON fl.location_dim_id = dloc.location_id
GROUP BY dloc.City
ORDER BY avg_price_pkr DESC;

-- Supply & Inventory Mix
-- 3.1 Listings by Car Type : “Are SUVs, Sedans, or Hatchbacks dominating?”

SELECT
    crd.CarType,
    COUNT(*) AS total_listings
FROM fact_listings fl
JOIN dim_car crd ON fl.car_dim_id = crd.car_id
GROUP BY crd.CarType
ORDER BY total_listings

-- 3.2 Fuel Type Distribution -- Helps with future demand forecasting.

SELECT
    crd.FuelType,
    COUNT(*) AS total_listings,
    AVG(CAST(fl.DemandPKR AS BIGINT)) AS avg_price
FROM fact_listings fl
JOIN dim_car crd ON fl.car_dim_id = crd.car_id
GROUP BY crd.FuelType
ORDER BY total_listings DESC;

-- 4. Time‑Based Executive Trends
-- 4.1 Monthly Listing Volume Trend

-- “Is our supply growing month‑over‑month?”

SELECT
    ddat.PostYear,
    ddat.PostMonth,
    COUNT(fl.listing_id) AS total_listings
FROM fact_listings fl
JOIN dim_date ddat ON fl.date_dim_id = ddat.date_id
GROUP BY ddat.PostYear, ddat.PostMonth
ORDER BY ddat.PostYear, ddat.PostMonth;

-- 4.2 Price Trend Over Time
SELECT
    ddat.PostYear,
    ddat.PostMonth,
    AVG(CAST(fl.DemandPKR AS BIGINT)) AS avg_price
FROM fact_listings fl
JOIN dim_date ddat ON fl.date_dim_id = ddat.date_id
GROUP BY ddat.PostYear, ddat.PostMonth
ORDER BY ddat.PostYear, ddat.PostMonth;

-- 5 Listing Quality & Data Health
-- 5.1 % of Listings with Missing Critical Info


SELECT
    COUNT(*) AS total_listings,
    SUM(CASE WHEN fl.MissingCriticalInfo = 'Y' THEN 1 ELSE 0 END) AS bad_listings,
    100.0 * SUM(CASE WHEN fl.MissingCriticalInfo = 'Y' THEN 1 ELSE 0 END) / COUNT(*) 
        AS bad_listing_percentage
FROM fact_listings fl;

-- 5.2 Listing Age vs Data Quality

SELECT
    fl.MissingCriticalInfo,
    AVG(CAST(fl.ListingAgeDays AS INT)) AS avg_listing_age
FROM fact_listings fl
GROUP BY fl.MissingCriticalInfo;

-- 6.2 High‑Feature vs Low‑Feature Pricing
SELECT
    CASE 
        WHEN dcarf.SafetyScore >= 7 THEN 'High Safety'
        ELSE 'Low Safety'
    END AS safety_group,
    COUNT(*) AS listings,
    AVG(CAST(fl.DemandPKR AS BIGINT)) AS avg_price
FROM fact_listings fl
JOIN dim_car_features dcarf 
  ON fl.car_features_dim_id = dcarf.car_features_id
GROUP BY 
    CASE 
        WHEN dcarf.SafetyScore >= 7 THEN 'High Safety'
        ELSE 'Low Safety'
    END;

-- Performance & Operational KPIs
--  7.1 Fast‑Moving vs Slow‑Moving Listings
SELECT
    fl.PriceCategory,
    AVG(CAST(fl.ListingAgeDays AS INT)) AS avg_days_on_platform
FROM fact_listings fl
GROUP BY fl.PriceCategory
ORDER BY avg_days_on_platform;

-- 7.2 Mileage Bucket vs Price

SELECT
    fl.MileageBucket,
    COUNT(*) AS total_listings,
    AVG(CAST(fl.DemandPKR AS BIGINT)) AS avg_price
FROM fact_listings fl
GROUP BY fl.MileageBucket
ORDER BY avg_price DESC;


