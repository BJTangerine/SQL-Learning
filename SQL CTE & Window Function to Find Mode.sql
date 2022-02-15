-- using CTE with Window Function to calculate the mode 
WITH ModePrice (OrderPrice, UnitPriceFrequency)
AS
(
       SELECT OrderPrice,
       ROW_NUMBER() 
    OVER (PARTITION BY OrderPrice ORDER BY OrderPrice) AS UnitPriceFrequency
       FROM Orders
)

SELECT OrderPrice AS ModeOrderPrice
FROM ModePrice

-- uses CTE to return value of OrderPrice with highest row num
WHERE UnitPriceFrequency IN (SELECT MAX(UnitPriceFrequency) FROM ModePrice)
;