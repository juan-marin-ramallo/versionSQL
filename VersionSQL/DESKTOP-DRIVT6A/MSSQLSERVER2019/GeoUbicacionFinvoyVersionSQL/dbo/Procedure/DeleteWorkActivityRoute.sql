/****** Object:  Procedure [dbo].[DeleteWorkActivityRoute]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		NR
-- Create date: 10/03/2017
-- Description:	SP para guardar un plan
-- =============================================
CREATE PROCEDURE [dbo].[DeleteWorkActivityRoute]
	 @RPOIId [sys].[int] 
AS
BEGIN

	BEGIN 
		
		Update dbo.RoutePointOfInterest
		set Deleted = 1
		where Id = @RPOIId

		update dbo.RouteDetail
		set [Disabled] = 1,
			[DisabledType] = 1
		where IdRoutePointOfInterest = @RPOIId

	

	END

END
