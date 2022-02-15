/*
Creates SP which calculates the average Fare per KM, ride count, and total ride minutes for each
NYC borough and weekday, omitting records where TripDistance = 0. Also formmatted for German culture.
*/


CREATE OR ALTER PROCEDURE dbo.cuspBoroughRideStats
AS
BEGIN
SELECT
	DATENAME(weekday, PickupDate) AS 'Weekday', -- Calculates the pickup weekday
	Zone.Borough AS 'PickupBorough',
	FORMAT(AVG(dbo.ConvertDollar(TotalAmount, .88)/dbo.ConvertMiletoKM(TripDistance)), 'c', 'de-de') AS 'AvgFarePerKM', -- Display AvgFarePerKM as German currency
	FORMAT(COUNT(ID), 'n', 'de-de') AS 'RideCount', -- Displays RideCount in the German format
	FORMAT(SUM(DATEDIFF(SECOND, PickupDate, DropOffDate))/60, 'n', 'de-de') AS 'TotalRideMin' -- Displays TotalRideMin in the German format

FROM YellowTripData
INNER JOIN TaxiZoneLookup AS Zone 
ON PULocationID = Zone.LocationID

WHERE 
    TripDistance > 0

-- Group by pickup weekday and Borough
GROUP BY 
    DATENAME(WEEKDAY, PickupDate), 
    Zone.Borough

ORDER BY 
    CASE 
        WHEN DATENAME(WEEKDAY, PickupDate) = 'Monday' THEN 1
 	    WHEN DATENAME(WEEKDAY, PickupDate) = 'Tuesday' THEN 2
        WHEN DATENAME(WEEKDAY, PickupDate) = 'Wednesday' THEN 3
        WHEN DATENAME(WEEKDAY, PickupDate) = 'Thursday' THEN 4
        WHEN DATENAME(WEEKDAY, PickupDate) = 'Friday' THEN 5
        WHEN DATENAME(WEEKDAY, PickupDate) = 'Saturday' THEN 6
        WHEN DATENAME(WEEKDAY, PickupDate) = 'Sunday' THEN 7 END,  
		SUM(DATEDIFF(SECOND, PickupDate, DropOffDate))/60
DESC
END
;



-- The following executes the SP and stores results in a 'results' table.
DECLARE @SPResults TABLE(
    Weekday nvarchar(30),
    Borough nvarchar(30),
    AvgFarePerKM nvarchar(30), -- Creates average fare per KM
    RideCount nvarchar(30),
    TotalRideMin nvarchar(30))


INSERT INTO @SPResults
EXEC dbo.cuspBoroughRideStats
;