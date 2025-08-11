/*
==============================================================
Create Database and Schemas
==============================================================

Script Purpose:
	This script creates a new database named 'BICompanyDataWarehouse' after checking if it already exists.
	If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas
	within the database: 'bronze', 'silver', and 'gold'.

WARNING:
	Running this script will drop the entire 'BICompanyDataWarehouse' database if it exists.
	All data in the database will permanently be deleted. Proceed with caution and ensure
	you have proper backups before running this script.
*/

------------------------------------------------------------------------------------------
-- Start of script

USE master;


-- Checks if the database already exists
-- Drop and recreate the 'BICompanyDataWarehouse' db
--'SET SINGLE_USER' >> Ensures only one connection (yours) is active before dropping
-- 'WITH ROLLBACK IMMEDIATE' >> Ends all other connections and rolls back any open transactions
IF EXISTS(SELECT 1 FROM sys.databases WHERE name = 'BICompanyDataWarehouse')
BEGIN
	ALTER DATABASE BICompanyDataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE BICompanyDataWarehouse;
END;
GO

-- Create the 'BICompanyDataWarehouse' db
CREATE DATABASE BICompanyDataWarehouse;
go

USE BICompanyDataWarehouse;

-- Create schema layers

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO