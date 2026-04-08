

SELECT 
crd.Brand,crd.MakeModel,crd.Year,crd.EngineCapacity,crd.FuelType,crd.Transmission,crd.CarType,crd.ManufactureType, 
dcarf.SafetyScore,dcarf.ComfortScore,dcarf.TechScore,dcarf.feature_hash,
ddat.PostLastUpdatedat,ddat.PostYear,ddat.PostMonth,ddat.PostDayOfWeek,
dloc.City,dloc.CityGroup,dloc.CarAddress,
fl.DemandPKR,fl.DemandInLacs,fl.Mileage,fl.MileagePerYear,fl.CarAge,fl.ListingAgeDays,fl.PriceCategory,fl.MileageBucket,fl.MissingCriticalInfo
from fact_listings fl 
LEFT JOIN dim_car crd ON
fl.car_dim_id = crd.car_id
LEFT JOIN dim_date ddat ON
fl.date_dim_id = ddat.date_id
LEFT JOIN dim_car_features dcarf ON
fl.car_features_dim_id = dcarf.car_features_id
LEFT JOIN dim_location dloc ON
fl.location_dim_id = dloc.location_id;