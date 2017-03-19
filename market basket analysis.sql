-- Step 1: Identify viability, opportunity size and % of transactions with more than one product

/*Percentage of orders with > 1 item; basket = ItineraryID*/
SELECT * 
FROM   (SELECT Count(*) AS multi 
        FROM   (SELECT Count(DISTINCT [itinerary item id]) AS Freq 
                FROM   customer_extract 
                WHERE  [order date] >= '2016-01-01' 
                       AND email NOT LIKE '%company.com%' 
                       AND email NOT LIKE '%vacations%' 
                       AND email NOT LIKE '%tl3usa%' 
                       AND email NOT LIKE '%cruise%' 
                       AND email NOT LIKE '%travel%' 
                       AND email NOT LIKE '%holidays%' 
                       AND [order date] IS NOT NULL 
                       AND [customer id] <> 0 
                GROUP  BY [customer id], 
                          [order date]
                  ) AS a 
        WHERE  a.freq > 1
        ) AS b, 
        (
        SELECT Count(*) AS Total 
        FROM   (
                SELECT Count(*) AS Tot 
                FROM   customer_extract 
                WHERE  [order date] >= '2016-01-01' 
                       AND email NOT LIKE '%company.com%' --eliminating transactions by trave agents & employees
                       AND email NOT LIKE '%vacations%' 
                       AND email NOT LIKE '%tl3usa%' 
                       AND email NOT LIKE '%cruise%' 
                       AND email NOT LIKE '%travel%' 
                       AND email NOT LIKE '%holidays%' 
                       AND [order date] IS NOT NULL 
                       AND [customer id] <> 0 
                GROUP  BY [customer id], 
                          [order date]
                  ) AS d
           ) AS c 

-- Step 2: Pull Products in the same basket, where basket is equal to purchase made by same customer in the same day

SELECT a.[order date]                    AS [Order Date], 
       a.[customer id]                   AS [Customer ID], 
       a.[channel]                       AS [Channel], 
       a.[channel platform]              AS [Channel Platform], 
       a.[customer country]              AS [Customer Country], 
       a.[destination continent]         AS [Destination Continent], 
       a.[destination country]           AS [Destination Country], 
       a.[destination region]            AS [Destination Region], 
       a.[product code]                  AS [Product Code], 
       b.[product code]                  AS [Product Recommendation Code], 
       a.[product name]                  AS [Product Name], 
       b.[product name]                  AS [Product Recommendations], 
       a.[gross bookings]                AS [Gross Bookings], 
       a.[gross orders]                  AS [Gross Orders] 
FROM   [customer_extract] a 
       INNER JOIN [customer_extract] b 
               ON     a.[customer id] = b.[customer id] 
                  AND a.[order date] = b.[order date] 
                  AND a.[product code] <> b.[product code] 
WHERE  Year(a.[order date]) >= 2016 
       AND a.email NOT LIKE '%company.com%' --eliminating transactions by trave agents & employees
       AND a.email NOT LIKE '%vacations%' 
       AND a.email NOT LIKE '%tl3usa%' 
       AND a.email NOT LIKE '%cruise%' 
       AND a.email NOT LIKE '%travel%' 
       AND email NOT LIKE '%holidays%' 
       AND a.[order date] IS NOT NULL 
       AND a.[customer id] <> 0 
