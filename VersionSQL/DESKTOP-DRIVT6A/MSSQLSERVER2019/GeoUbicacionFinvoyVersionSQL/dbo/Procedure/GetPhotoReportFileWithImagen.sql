/****** Object:  Procedure [dbo].[GetPhotoReportFileWithImagen]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetPhotoReportFileWithImagen]
(    
	 @IdUser [sys].[int] = NULL
	,@StartDate [sys].DATETIME
	,@EndDate [sys].DATETIME 
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL

)    
AS 
BEGIN

    SET NOCOUNT ON;

    SELECT  P.[Id], P.[IdPersonOfInterest], P.[IdPointOfInterest], P.[ReportDate], 
			P.[ReceivedDate], P.[Comments],
			P.[ImageName1], P.[ImageEncoded1] AS ImageArray1, P.[ImageUrl1],
			P.[ImageName2], P.[ImageEncoded2] AS ImageArray2, P.[ImageUrl2],
			P.[ImageName1After], P.[ImageEncoded1After] AS ImageArray1After, P.[ImageUrl1After],
			P.[ImageName2After], P.[ImageEncoded2After] AS ImageArray2After, P.[ImageUrl2After],
			P.[CommentsAfter],POI.[Name] as PointOfInterestName, POI.[Id] as PointOfInterestId, POI.[Identifier] as PointOfInterestIdentifier, POI.[Address] as PointOfInterestAddress, 
			PEI.[Name] as PersonOfInterestName, PEI.[LastName] as PersonOfInterestLastName, PEI.[MobilePhoneNumber] as PersonOfInterestMobilePhoneNumber
    
	FROM	[dbo].[PhotoReport] P
			INNER JOIN  [dbo].[PersonOfInterest] PEI   ON P.[IdPersonOfInterest] = PEI.[Id]
			INNER JOIN   [dbo].[PointOfInterest] POI ON P.[IdPointOfInterest] = POI.[Id]
	WHERE
			 P.[ReportDate] >= @StartDate AND P.[ReportDate] <= @EndDate AND 
			((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[IdPersonOfInterest], @IdPersonsOfInterest) = 1)) AND
			((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[IdPointOfInterest], @IdPointsOfInterest) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(POI.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(PEI.[Id], @IdUser) = 1)) AND
            ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(PEI.[IdDepartment], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUser) = 1))

	ORDER BY P.[Id]
END
