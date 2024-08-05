/****** Object:  Procedure [dbo].[GetPointsOfInterestCount]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetPointsOfInterestCount] 
AS
BEGIN

    SELECT COUNT(1) FROM PointOfInterest WHERE Deleted = 0

END
