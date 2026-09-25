/*
=============================================================
Crear base de datos y esquemas
=============================================================
Propósito del script:
    Este script crea una nueva base de datos llamada 'DataWarehouse' después de verificar si ya existe.
    Si la base de datos existe, se elimina y se vuelve a crear. Adicionalmente, el script configura tres
    esquemas dentro de la base de datos: 'bronze', 'silver' y 'gold'.

ADVERTENCIA:
    Ejecutar este script eliminará por completo la base de datos 'DataWarehouse' si ya existe.
    Todos los datos de la base se borrarán de forma permanente. Procedé con precaución
    y asegurate de tener respaldos antes de ejecutar este script.
*/

USE master;
GO

-- Eliminar y volver a crear la base de datos 'DataWarehouse'  
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

-- Crear base de datos 'DataWarehouse'
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Crear Esquemas 
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
