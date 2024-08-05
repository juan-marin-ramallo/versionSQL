/****** Object:  Procedure [dbo].[GetPointsOfInterestImageFilteredById]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetPointsOfInterestImageFilteredById]
	@Ids varchar(max) = null	 
AS 

    SET NOCOUNT ON;
    SELECT	[Id], [Image], [ImageUrl]
    FROM	[dbo].[PointOfInterest]
    WHERE ((@Ids is null) OR dbo.CheckVarcharInList ([Id], @Ids)=1)
	
