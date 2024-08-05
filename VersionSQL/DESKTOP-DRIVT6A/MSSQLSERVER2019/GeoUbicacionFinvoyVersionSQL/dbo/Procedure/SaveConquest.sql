/****** Object:  Procedure [dbo].[SaveConquest]    Committed by VersionSQL https://www.versionsql.com ******/

-- ==============================================================
-- Author:		Fede Sobri
-- Create date: 06/06/2019
-- Description:	SP guardar una nueva conquista 
-- ==============================================================
CREATE PROCEDURE [dbo].[SaveConquest]
(       
	 @Id [sys].[int] OUTPUT
	,@ConquestTypeId [sys].[int]  
	,@IdPersonOfInterest [sys].[int] 
	,@IdPointOfInterest [sys].[int] 
	,@Date [sys].[DATETIME]
	,@Amount [sys].[DECIMAL](8,2)  
	,@Description [sys].[varchar](250) = NULL
	,@Images [dbo].[ImageTableType] READONLY
)
AS
BEGIN

	INSERT INTO [dbo].[Conquest]
			   ([ConquestTypeId]
			   ,[IdPersonOfInterest]
			   ,[IdPointOfInterest]
			   ,[Date]
			   ,[Description]
			   ,[Amount])
	VALUES
		(@ConquestTypeId
		,@IdPersonOfInterest
		,@IdPointOfInterest
		,@Date
		,@Description
		,@Amount)

	SET @Id = SCOPE_IDENTITY()

	INSERT INTO [dbo].[ConquestCampaign](IdConquest, IdCampaign)
	SELECT @Id, C.[Id]
	FROM [dbo].[Campaign] C 
		LEFT OUTER JOIN [dbo].[CampaignPointOfInterest] P ON C.[Id] = P.IdCampaign
		LEFT OUTER JOIN [dbo].[CampaignPersonOfInterest] S ON C.[Id] = S.IdCampaign
	WHERE	C.Deleted = 0
		AND @Date BETWEEN C.[StartDate] AND C.[EndDate]
		AND (C.AllPersonOfInterest = 1 OR S.IdPersonOfInterest = @IdPersonOfInterest)
		AND (C.AllPointOfInterest = 1 OR P.[IdPointOfInterest] = @IdPointOfInterest)
	GROUP BY  C.[Id]			

	INSERT INTO [dbo].[ConquestImage] (IdConquest, ImageName)
	SELECT @Id, I.[ImageName]
	FROM @Images I

END 
