/****** Object:  Procedure [dbo].[GetBIDataSources]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetBIDataSources]
AS
BEGIN
	
	SELECT [Id], [Name], [StoredProcedure], [LastReportedDate], [LocalBasePath]
	FROM BIDataSource 

END
