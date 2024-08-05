/****** Object:  Procedure [dbo].[SaveCustomReportForm]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveCustomReportForm]
	 @IdCustomReport int
	,@IdForm int
AS
BEGIN
	
	INSERT INTO CustomReportForm([IdCustomReport], [IdForm])
	VALUES (@IdCustomReport, @IdForm)

END
