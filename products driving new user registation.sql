-- This SQL finds the first purchase date for a customer as well as the products they bought during their initial purchase
-- the output can be visualized to illustrate which products are responsible for new user registration

SELECT	 [Customer ID]
	,[Order Date]
        ,[Platform]
        ,[Channel]
        ,[Product Code]
        ,[Product Name]
        ,[Product Subcategory]
        ,[Product Category]
        ,[Destination Name]
        ,[Marketing Campaign]
	,sum([Gross Bookings])	as [Gross Bookings]
	,sum([Gross Revenue])	as [Gross Revenue]	
	,sum([Gross Orders])	as [Gross Orders]
	,sum([Gross Pax])	as [Gross Pax]
	,sum([Net Bookings])	as [Net Bookings]
	,sum([Net Revenue])	as [Net Revenue]
	,sum([Net Orders])	as [Net Orders]
	,sum([Net Pax])		as [Net Pax]
FROM	CUSTOMER c
WHERE	c.[Order Date] = 
		(
		SELECT 		TOP (1) ([Order Date])
		FROM		CUSTOMER c2
		WHERE		c2.[Customer ID] = c.[Customer ID]
		ORDER BY	[Order Date]
		) 
GROUP BY	 [Customer ID]
          ,[Order Date]
          ,[Travel Date]
          ,[Platform]
          ,[Channel]
          ,[Product Code]
          ,[Product Name]
          ,[Product Subcategory]
          ,[Product Category]
          ,[Destination Name]
          ,[Marketing Campaign]
      
