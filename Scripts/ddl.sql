-- 1. Crear la base de datos para Adidas
CREATE DATABASE AdidasProject;
GO

-- 2. Decirle a SQL Server que use esta base de datos
USE AdidasProject;
GO

-- 3. Crear la tabla principal de ventas
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