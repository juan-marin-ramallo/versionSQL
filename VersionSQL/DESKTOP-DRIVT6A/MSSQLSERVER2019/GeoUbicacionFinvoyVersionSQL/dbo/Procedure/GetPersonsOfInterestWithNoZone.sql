/****** Object:  Procedure [dbo].[GetPersonsOfInterestWithNoZone]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 17/07/2015
-- Description:	Rtorna todos las personas de interes sin zona asociada
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonsOfInterestWithNoZone]	
	@IncludeDeleted [sys].[BIT] = NULL 
AS
BEGIN
	
	SELECT		P.[Id], P.[Name],P.[LastName], P.[Type], P.[IdDepartment],P.[Identifier] 
	FROM		[dbo].[PersonOfInterest] P WITH (NOLOCK)
				LEFT OUTER JOIN [dbo].[PersonOfInterestZone] PZ WITH (NOLOCK) ON PZ.[IdPersonOfInterest] = P.[Id]
	WHERE		(@IncludeDeleted = 1 OR P.[Deleted] = 0) AND				
				PZ.[IdPersonOfInterest] IS NULL
	GROUP BY	P.[Id], P.[Name],P.[LastName], P.[Type], P.[IdDepartment],P.[Identifier] 
END
