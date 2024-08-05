/****** Object:  Procedure [dbo].[GetFormNamesByPersonOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 22/01/2014
-- Description:	SP para obtener los nombres de los formularios y su id
-- =============================================

CREATE PROCEDURE [dbo].[GetFormNamesByPersonOfInterest]
	@IdPersonOfInterest [sys].[int] = NULL,
	@OnlyCompleted [sys].[bit] = NULL
AS
BEGIN
	DECLARE @Now [sys].[datetime]
    SET @Now = GETUTCDATE()

	SELECT	distinct(F.[Name]), F.[Id], F.[NonPointOfInterest],
			CASE WHEN Tzdb.IsGreaterOrSameSystemDate(F.[EndDate], @Now) = 1 AND F.[Deleted] = 0 then 1 else 0 end as ActiveForm
	
	FROM	[dbo].[AssignedForm] AF WITH(NOLOCK)
			INNER JOIN [dbo].[Form] F WITH(NOLOCK) ON F.[Id] = AF.[IdForm]
	
	WHERE	AF.[IdPersonOfInterest] = @IdPersonOfInterest AND			
			F.[Deleted] = 0 AND AF.[Deleted] = 0 AND
			Tzdb.IsLowerOrSameSystemDate(F.[StartDate], @Now) = 1 AND Tzdb.IsGreaterOrSameSystemDate(F.[EndDate], @Now) = 1
			AND F.[AllowWebComplete] = 1

	order by ActiveForm desc, F.[Name]	
END
