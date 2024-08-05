/****** Object:  Procedure [dbo].[SaveCustomReportField]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveCustomReportField]
	 @IdCustomReport int
	,@IdField int
AS
BEGIN
	
	INSERT INTO CustomReportField ([IdCustomReport], [IdField])
	VALUES (@IdCustomReport, @IdField)

END
