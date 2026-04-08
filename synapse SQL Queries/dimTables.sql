
CREATE EXTERNAL DATA SOURCE adls_pakwheels
WITH (
    LOCATION = 'abfss://gold@staccpakwheels.dfs.core.windows.net'
);


CREATE EXTERNAL FILE FORMAT delta_format
WITH (
    FORMAT_TYPE = DELTA
);


DROP EXTERNAL TABLE dbo.dim_car;
CREATE EXTERNAL TABLE dbo.dim_car (
    car_id BIGINT,
    car_hash NVARCHAR(100),
    Brand NVARCHAR(100),
    MakeModel NVARCHAR(200),
    [Year] INT,
    EngineCapacity INT,
    FuelType NVARCHAR(50),
    Transmission NVARCHAR(50),
    CarType NVARCHAR(50),
    ManufactureType NVARCHAR(50)
)
WITH (
    LOCATION = 'goodDataFolder/dimenstions/dim_car',
    DATA_SOURCE = adls_pakwheels,
    FILE_FORMAT = delta_format
);


DROP EXTERNAL TABLE dbo.dim_location;
CREATE EXTERNAL TABLE dbo.dim_location (
    location_hash NVARCHAR(100),
    location_id BIGINT,
    City NVARCHAR(100),
    CityGroup NVARCHAR(100),
    CarAddress NVARCHAR(300)
)
WITH (
    LOCATION = 'goodDataFolder/dimenstions/dim_location',
    DATA_SOURCE = adls_pakwheels,
    FILE_FORMAT = delta_format
);


DROP EXTERNAL TABLE dbo.dim_date;
CREATE EXTERNAL TABLE dbo.dim_date (
    date_hash NVARCHAR(100),
    PostLastUpdatedat DATE,
    PostYear NVARCHAR(10),
    PostMonth NVARCHAR(10),
    PostDayOfWeek NVARCHAR(20),
    date_id BIGINT
)
WITH (
    LOCATION = 'goodDataFolder/dimenstions/dim_date',
    DATA_SOURCE = adls_pakwheels,
    FILE_FORMAT = delta_format
);


drop EXTERNAL TABLE dbo.dim_car_features ;
CREATE EXTERNAL TABLE dbo.dim_car_features (
    AlloyWheels TINYINT,
    FrontFogLights TINYINT,
    DRLs TINYINT,
    SunRoof NVARCHAR(20),
    ABS TINYINT,
    AirBags TINYINT,
    AirConditioning TINYINT,
    AlloyRims TINYINT,
    InfotainmentSystem TINYINT,
    FrontSpeakers TINYINT,
    RearSpeakers TINYINT,
    SteeringSwitches TINYINT,
    PaddleShifters TINYINT,
    TractionControl TINYINT,
    FrontCamera TINYINT,
    RearCamera TINYINT,
    ImmobilizerKey TINYINT,
    PowerLocks TINYINT,
    PowerSteering TINYINT,
    CoolBox TINYINT,
    CruiseControl TINYINT,
    SafetyScore FLOAT,
    ComfortScore FLOAT,
    TechScore FLOAT,
    car_features_id BIGINT,
    feature_hash NVARCHAR(64)
)
WITH (
    LOCATION = 'goodDataFolder/dimenstions/dim_car_features',
    DATA_SOURCE = adls_pakwheels,
    FILE_FORMAT = delta_format
);


DROP EXTERNAL TABLE dbo.fact_listings;
CREATE EXTERNAL TABLE dbo.fact_listings (
    listing_id NVARCHAR(100),

    car_dim_id BIGINT,
    location_dim_id BIGINT,
    date_dim_id BIGINT,
    car_features_dim_id BIGINT,

    DemandPKR NVARCHAR(50),
    DemandInLacs NVARCHAR(50),
    Mileage INT,
    MileagePerYear NVARCHAR(50),
    CarAge NVARCHAR(50),
    ListingAgeDays NVARCHAR(50),

    PriceCategory NVARCHAR(50),
    MileageBucket NVARCHAR(50),
    MissingCriticalInfo NVARCHAR(20)
)
WITH (
    LOCATION = 'goodDataFolder/facts/facts_car_listing',
    DATA_SOURCE = adls_pakwheels,
    FILE_FORMAT = delta_format
);



