/****** Object:  Procedure [dbo].[GetConquestReportByPerson]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 06/06/2019
-- Description:	SP para obtener las conquistas.
-- =============================================
CREATE PROCEDURE [dbo].[GetConquestReportByPerson]
(
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@IdDepartments [sys].[varchar](max) = NULL
	,@IdPersonsOfInterest [sys].[VARCHAR](MAX) = NULL
	,@IdPointsOfInterest [sys].[VARCHAR](MAX) = NULL
	,@IdCampaign [sys].[VARCHAR](MAX) = NULL
	,@IdConquestType [sys].[VARCHAR](MAX) = NULL
	,@IdUser [sys].INT = NULL
)
AS
BEGIN
    SELECT C.[IdCampaign], C.[IdPersonOfInterest], C.[PersonName], C.[PersonLastName], C.[PersonIdentifier]
		, SUM(C.[Amount]) AS [Total], SUM(IIF(C.[IsVerified] IS NOT NULL AND C.[IsVerified] = 1, C.[Amount], 0)) AS TotalVerified, SUM(IIF(C.[IsVerified] IS NOT NULL AND C.[IsVerified] = 0, C.[Amount], 0)) AS TotalRejected
		, SUM(C.[Amount] * C.[ConquestTypeWeight]) AS [TotalPoints], SUM(IIF(C.[IsVerified] IS NOT NULL AND C.[IsVerified] = 1, C.[Amount] * C.[ConquestTypeWeight], 0)) AS [TotalPointsVerified], SUM(IIF(C.[IsVerified] IS NOT NULL AND C.[IsVerified] = 0, C.[Amount] * C.[ConquestTypeWeight], 0)) AS [TotalPointsRejected]
	FROM [dbo].[GetDetailedConquest] (@DateFrom, @DateTo, @IdDepartments, @IdPersonsOfInterest, @IdPointsOfInterest, @IdCampaign , @IdConquestType, @IdUser) AS C
	GROUP BY C.[IdCampaign], C.[IdPersonOfInterest], C.[PersonName], C.[PersonLastName], C.[PersonIdentifier]
	ORDER BY C.[IdCampaign] DESC, SUM(C.[Amount] * C.[ConquestTypeWeight]) DESC, C.[PersonName] ASC, C.[PersonLastName] ASC
END
