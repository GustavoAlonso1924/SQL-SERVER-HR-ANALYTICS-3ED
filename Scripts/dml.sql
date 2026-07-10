--- EXPLORATORY DATA & ANALYSIS AND INSIGHTS
Use AdidasProject

--- 1. ¿Cuál es el total de ingresos por ventas y el beneficio operativo histórico generado por la marca?
SELECT 
    FORMAT(SUM(Total_Sales), 'C0') AS Ingresos_Totales_Historicos, 
    FORMAT(SUM(Operating_Profit), 'C0') AS Beneficio_Operativo_Total
FROM AdidasSales;

--- 2. ¿Cuáles son las categorías de producto que acumulan el mayor volumen de unidades vendidas?
SELECT 
    Product, 
    SUM(Units_Sold) AS Total_Unidades_Vendidas
FROM AdidasSales
WHERE Units_Sold IS NOT NULL 
GROUP BY Product
ORDER BY Total_Unidades_Vendidas DESC;

--- 3. ¿Cómo se compara el margen operativo promedio entre los diferentes métodos de venta (Online, In-store, Outlet)?
SELECT 
    Sales_Method, 
    FORMAT(AVG(Operating_Margin), 'P2') AS Margen_Operativo_Promedio
FROM AdidasSales
WHERE Operating_Margin IS NOT NULL 
GROUP BY Sales_Method
ORDER BY AVG(Operating_Margin) DESC;

--- 4. ¿Qué regiones y estados concentran la mayor participación de ingresos de la compañía?
SELECT TOP 5 
    Region, 
    State, 
    SUM(Total_Sales) AS Ventas_Totales,
    FORMAT(SUM(Total_Sales) / (SELECT SUM(Total_Sales) FROM AdidasSales WHERE Total_Sales IS NOT NULL), 'P2') AS Porcentaje_Participacion
FROM AdidasSales
WHERE Total_Sales IS NOT NULL
GROUP BY Region, State
ORDER BY SUM(Total_Sales) DESC;

--- 5. Clasificar a los principales minoristas (Retailers) según el total de ventas y beneficio generado.
SELECT 
    Retailer, 
    SUM(Total_Sales) AS Ventas_Totales,
    SUM(Operating_Profit) AS Beneficio_Total
FROM AdidasSales
WHERE Total_Sales IS NOT NULL AND Operating_Profit IS NOT NULL
GROUP BY Retailer
ORDER BY Ventas_Totales DESC;

--- 6. 
SELECT 
    YEAR(Invoice_Date) AS Anio,
    MONTH(Invoice_Date) AS Mes,
    SUM(Total_Sales) AS Ventas_Totales
FROM AdidasSales
WHERE Invoice_Date IS NOT NULL AND Total_Sales IS NOT NULL
GROUP BY YEAR(Invoice_Date), MONTH(Invoice_Date)
ORDER BY Anio ASC, Mes ASC;

--- 7. Identificar las ciudades con mayor contribución de ingresos dentro de cada región analizada.
WITH RankingCiudades AS (
    SELECT 
        Region, 
        City, 
        SUM(Total_Sales) AS Ventas_Totales,
        DENSE_RANK() OVER (PARTITION BY Region ORDER BY SUM(Total_Sales) DESC) AS Posicion
    FROM AdidasSales
    WHERE Region IS NOT NULL AND City IS NOT NULL AND Total_Sales IS NOT NULL
    GROUP BY Region, City
)
SELECT 
    Region, 
    City, 
    Ventas_Totales
FROM RankingCiudades
WHERE Posicion <= 3
ORDER BY Region ASC, Ventas_Totales DESC;

--- 8. Categorizar las transacciones según el volumen de ventas e identificar el promedio de margen operativo en cada categoría.
SELECT 
    CASE 
        WHEN Total_Sales >= 500000 THEN 'Venta Alta (>= 500K)'
        WHEN Total_Sales BETWEEN 150000 AND 499999 THEN 'Venta Media (150K - 500K)'
        ELSE 'Venta Baja (< 150K)'
    END AS Categoria_Venta,
    COUNT(*) AS Total_Transacciones,
    FORMAT(AVG(Operating_Margin), 'P2') AS Promedio_Margen_Operativo
FROM AdidasSales
WHERE Total_Sales IS NOT NULL AND Operating_Margin IS NOT NULL
GROUP BY 
    CASE 
        WHEN Total_Sales >= 500000 THEN 'Venta Alta (>= 500K)'
        WHEN Total_Sales BETWEEN 150000 AND 499999 THEN 'Venta Media (150K - 500K)'
        ELSE 'Venta Baja (< 150K)'
    END
ORDER BY MIN(Total_Sales) DESC;

--- 9. ¿Existe una relación directa entre el precio por unidad establecido y el volumen total de unidades vendidas por producto?
SELECT 
    Product,
    AVG(Price_Per_Unit) AS Precio_Promedio_Unitario,
    SUM(Units_Sold) AS Total_Unidades_Vendidas
FROM AdidasSales
WHERE Product IS NOT NULL 
  AND Price_Per_Unit IS NOT NULL
GROUP BY Product
ORDER BY Precio_Promedio_Unitario DESC;

--- 10. Identificar qué combinaciones de producto y ciudad operan con un margen de ganancia crítico (inferior al promedio global).
SELECT TOP 5
    City AS Ciudad,
    Product AS Producto,
    AVG(Operating_Margin) AS Margen_Promedio_Local
FROM AdidasSales
WHERE Product IS NOT NULL 
  AND City IS NOT NULL
GROUP BY City, Product
HAVING AVG(Operating_Margin) < (SELECT AVG(Operating_Margin) FROM AdidasSales)    
ORDER BY Margen_Promedio_Local ASC;
