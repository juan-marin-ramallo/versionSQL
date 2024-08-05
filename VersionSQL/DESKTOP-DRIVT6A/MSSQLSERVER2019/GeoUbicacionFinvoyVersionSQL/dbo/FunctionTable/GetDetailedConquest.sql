/****** Object:  TableFunction [dbo].[GetDetailedConquest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 23/08/2016
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[GetDetailedConquest]
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
RETURNS @t TABLE (
	[IdCampaign] [int], [CampaignName] [varchar](150), [CampaignDescription] [varchar](max), [CampaignStartDate] [datetime], [CampaignEndDate] [DATETIME], [CampaignPrize] [sys].[VARCHAR](200)
	, ConquestTypeAmount [int], ConquestTypeWeight [INT], [ConquestTypeName] [sys].[VARCHAR](50), [ConquestTypeId] [sys].[int]
	, Id [sys].[int], [Date] [sys].[DATETIME], [Description] [sys].[VARCHAR](250), [Active] [sys].[BIT], [Amount] [sys].[DECIMAL](8,2)
	, [IdPersonOfInterest] [sys].[INT], [PersonName] [sys].[varchar](50), [PersonLastName] [sys].[varchar](50), [PersonIdentifier] [sys].[varchar](10)
	, [IdPointOfInterest] [sys].[int], [PointName] [sys].[varchar](100),[PointIdentifier] [sys].[varchar](50)
	--, [ImageId] [sys].[INT], [ImageName] [sys].[VARCHAR](256), [ImageUrl] [sys].[VARCHAR](512)
	, [IsVerified] [sys].[bit], [VerificationDate] [sys].[DATETIME], VerifierPersonId [sys].[int], [VerfierUserId] [sys].[int]
	, [VerfierPersonName] [sys].[varchar](50), [VerfierPersonLastName] [sys].[varchar](50), [VerfierPersonIdentifier] [sys].[varchar](10)
	, [VerfierUserName] [sys].[varchar](50), [VerfierUserLastName] [sys].[varchar](50), [VerfierUserUserName] [sys].[varchar](50)
	)
AS
BEGIN

	INSERT INTO @t 

	SELECT CA.[Id], CA.[Name] AS [CampaignName], CA.[Description] AS [CampaignDescription], CA.[StartDate] AS [CampaignStartDate], CA.[EndDate] AS [CampaignEndDate], CA.[Prize] AS [CampaignPrize]
		, CTC.[Amount] AS ConquestTypeAmount, CTC.[Weight] AS ConquestTypeWeight, CT.[Name] AS ConquestTypeName, C.[ConquestTypeId]
		, C.[Id], C.[Date], C.[Description], C.[Active], C.[Amount]
		, C.[IdPersonOfInterest], S.[Name] AS [PersonName], S.[LastName] AS [PersonLastName], S.Identifier AS [PersonIdentifier]
		, C.[IdPointOfInterest], POI.[Name] AS [PointName], POI.[Identifier] AS [PointIdentifier]
		--, CI.[Id] AS [ImageId], CI.[ImageName], CI.[ImageUrl]
		, CV.[IsVerified], CV.[Date] AS [VerificationDate], CV.[IdPersonOfInterest] AS VerifierPersonId, CV.[IdUser] AS [VerfierUserId]
		, SV.[Name] AS [VerfierPersonName], SV.[LastName] AS [VerfierPersonLastName], SV.[Identifier] AS [VerfierPersonIdentifier]
		, UV.[Name] AS [VerfierUserName], UV.[LastName] AS [VerfierUserLastName], UV.[UserName] AS [VerfierUserUserName]
	FROM [dbo].[Conquest] C WITH (NOLOCK)
		INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON C.[IdPersonOfInterest] = S.[Id]
		INNER JOIN [dbo].[PointOfInterest] POI WITH (NOLOCK) ON C.[IdPointOfInterest] = POI.[Id]
		--INNER JOIN [dbo].[conquestImage] CI WITH (NOLOCK) ON C.[Id] = CI.[IdConquest]
		INNER JOIN [dbo].[Parameter] CT WITH (NOLOCK) ON C.ConquestTypeId = CT.Id
		LEFT OUTER JOIN [dbo].[conquestCampaign] CC WITH (NOLOCK) ON C.Id = CC.[IdConquest]
		LEFT OUTER JOIN [dbo].[Campaign] CA WITH (NOLOCK) ON CC.IdCampaign = CA.[Id]
		LEFT OUTER JOIN [dbo].[CampaignConquestType] CTC WITH (NOLOCK) ON CC.IdCampaign = CTC.[IdCampaign] AND C.ConquestTypeId = CTC.IdConquestType
		LEFT OUTER JOIN [dbo].[ConquestVerification] CV WITH(NOLOCK) ON C.[Id] = CV.[IdConquest]
		LEFT OUTER JOIN [dbo].[Personofinterest] SV WITH(NOLOCK) ON CV.[IdPersonOfInterest] = SV.[Id]
		LEFT OUTER JOIN [dbo].[User] UV WITH(NOLOCK) ON CV.[IdUser] = UV.[Id]
    WHERE CA.[Deleted] = 0 
			AND ((CA.[StartDate] BETWEEN @DateFrom AND @DateTo) OR (CA.[EndDate] BETWEEN @DateFrom AND @DateTo))
			AND (@IdDepartments IS NULL OR S.[IdDepartment] IS NULL OR dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1) 
			AND	(@IdPersonsOfInterest IS NULL OR CA.AllPersonOfInterest = 1 OR dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1) 
			AND	(@IdPointsOfInterest IS NULL OR CA.AllPointOfInterest = 1 OR dbo.CheckValueInList(POI.[Id], @IdPointsOfInterest) = 1) 
			AND (@IdCampaign IS NULL OR dbo.CheckValueInList(CC.[IdCampaign], @IdCampaign) = 1)
			AND (@IdConquestType IS NULL OR dbo.CheckValueInList(C.[ConquestTypeId], @IdConquestType) = 1)
			AND (@IdUser IS NULL OR CA.AllPersonOfInterest = 1 OR dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)
			AND (@IdUser IS NULL OR CA.AllPersonOfInterest = 1 OR dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)
			AND (@IdUser IS NULL OR CA.AllPointOfInterest = 1 OR dbo.CheckUserInPointOfInterestZones(POI.[Id], @IdUser) = 1)
			AND (@IdUser IS NULL OR CA.AllPointOfInterest = 1 OR dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUser) = 1)
	GROUP BY CA.[Id], CA.[Name], CA.[Description], CA.[StartDate], CA.[EndDate], CA.[Prize]
		, CTC.[Amount], CTC.[Weight], CT.[Name], C.[ConquestTypeId]
		, C.[Id], C.[Date], C.[Description], C.[Active], C.[Amount]
		, C.[IdPersonOfInterest], S.[Name], S.[LastName], S.Identifier
		, C.[IdPointOfInterest], POI.[Name], POI.[Identifier]
		--, CI.[Id], CI.[ImageName], CI.[ImageUrl]
		, CV.[IsVerified], CV.[Date], CV.[IdPersonOfInterest], CV.[IdUser]
		, SV.[Name], SV.[LastName], SV.[Identifier]
		, UV.[Name], UV.[LastName], UV.[UserName]
	ORDER BY CA.[Id] DESC, C.[Id] DESC--, CI.[Id] DESC

	RETURN 
END
