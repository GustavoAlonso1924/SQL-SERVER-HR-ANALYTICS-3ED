USE AdidasProject;
GO

-- 1. Borrar la tabla final si ya existía para empezar desde cero
IF OBJECT_ID('AdidasSales', 'U') IS NOT NULL 
    DROP TABLE AdidasSales;
GO

-- 2. Crear la tabla definitiva con la estructura limpia
CREATE TABLE AdidasSales (
    Retailer NVARCHAR(100),
    Retailer_ID INT,
    Invoice_Date DATE,
    Region NVARCHAR(100),
    State NVARCHAR(100),
    City NVARCHAR(100),
    Product NVARCHAR(100),
    Price_Per_Unit FLOAT,
    Units_Sold INT,
    Total_Sales FLOAT,
    Operating_Profit FLOAT,
    Operating_Margin FLOAT,
    Sales_Method NVARCHAR(50)
);
GO

-- 3. Crear la tabla temporal de transición (Staging)
CREATE TABLE #AdidasStaging (
    Retailer NVARCHAR(250), Retailer_ID NVARCHAR(250), Invoice_Date NVARCHAR(250),
    Region NVARCHAR(250), State NVARCHAR(250), City NVARCHAR(250), Product NVARCHAR(250),
    Price_Per_Unit NVARCHAR(250), Units_Sold NVARCHAR(250), Total_Sales NVARCHAR(250),
    Operating_Profit NVARCHAR(250), Operating_Margin NVARCHAR(250), Sales_Method NVARCHAR(250)
);
GO

-- 4. Cargar el CSV usando BULK INSERT nombres exactos
BULK INSERT #AdidasStaging
FROM 'C:\Proyecto_data\adidas_sales.csv'  -- <--- Ruta con los nombres exactos
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';', -- Delimitador para Excel en español
    ROWTERMINATOR = '\n',
    TABLOCK
);
GO

-- 5. Limpiar los datos e insertarlos en la tabla definitiva
INSERT INTO AdidasSales (
    Retailer, Retailer_ID, Invoice_Date, Region, State, City, 
    Product, Price_Per_Unit, Units_Sold, Total_Sales, Operating_Profit, Operating_Margin, Sales_Method
)
SELECT 
    Retailer,
    TRY_CAST(Retailer_ID AS INT),
    TRY_CAST(Invoice_Date AS DATE),
    Region, State, City, Product,
    TRY_CAST(REPLACE(REPLACE(Price_Per_Unit, '$', ''), ',', '') AS FLOAT),
    TRY_CAST(REPLACE(Units_Sold, ',', '') AS INT),
    TRY_CAST(REPLACE(REPLACE(Total_Sales, '$', ''), ',', '') AS FLOAT),
    TRY_CAST(REPLACE(REPLACE(Operating_Profit, '$', ''), ',', '') AS FLOAT),
    TRY_CAST(REPLACE(Operating_Margin, '%', '') AS FLOAT) / 100.0,
    Sales_Method
FROM #AdidasStaging;
GO

-- 6. Borrar la tabla temporal
DROP TABLE #AdidasStaging;
GO

-- 7. Ver si se cargaron los datos correctamente
SELECT TOP 10 * FROM AdidasSales;