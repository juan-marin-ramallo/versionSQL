/****** Object:  Procedure [dbo].[GetPhotoReports]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetPhotoReports]
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
			IIF ( P.[ImageUrl1] IS NOT NULL, 1, IIF ( P.[ImageEncoded1] IS NOT NULL, 1, 0 ) ) AS HasImage1,
			IIF ( P.[ImageUrl2] IS NOT NULL, 1, IIF ( P.[ImageEncoded2] IS NOT NULL, 1, 0 ) ) AS HasImage2,
			IIF ( P.[ImageUrl1After] IS NOT NULL, 1, IIF ( P.[ImageEncoded1After] IS NOT NULL, 1, 0 ) ) AS HasImage1After,
			IIF ( P.[ImageUrl2After] IS NOT NULL, 1, IIF ( P.[ImageEncoded2After] IS NOT NULL, 1, 0 ) ) AS HasImage2After,
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

	ORDER BY P.[ReportDate] DESC
END
