/****** Object:  Procedure [dbo].[SaveBIDataSourceDate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveBIDataSourceDate]
	 @Id int
	,@Name varchar(50)
    ,@LocalBasePath varchar(260)
	,@StoredProcedure varchar(50)
AS
BEGIN
	INSERT INTO BIDataSource ([Id], [Name], [LocalBasePath], [StoredProcedure], [LastReportedDate])
	VALUES (@Id, @Name, @LocalBasePath, @StoredProcedure, '2000-01-01') 
END
