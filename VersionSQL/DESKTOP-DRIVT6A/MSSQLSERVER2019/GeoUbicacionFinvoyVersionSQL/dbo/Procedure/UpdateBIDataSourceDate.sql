/****** Object:  Procedure [dbo].[UpdateBIDataSourceDate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateBIDataSourceDate]
	 @Id int
	,@Date datetime
AS
BEGIN
   
   UPDATE BIDataSource
   SET LastReportedDate = @Date
   WHERE Id = @Id

END
