/****** Object:  Procedure [dbo].[GetIndispensableProducts]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 21/05/2020
-- Description:	SP para obtener los productos infaltables
-- =============================================
CREATE PROCEDURE [dbo].[GetIndispensableProducts]
(
	 @ReturnOnlyAssignedToPointsOfInterest [sys].[bit] = 0
	,@PointOfInterestIds [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	IF @ReturnOnlyAssignedToPointsOfInterest = 1
	BEGIN
		IF EXISTS (SELECT	TOP (1) 1
					FROM	[dbo].[PointOfInterest] P WITH (NOLOCK)
							LEFT JOIN [dbo].[ProductPointOfInterest] PPOI WITH (NOLOCK) ON PPOI.[IdPointOfInterest] = P.[Id]
					WHERE	P.[Deleted] = 0
							AND PPOI.[Id] IS NULL
							AND (CASE WHEN @PointOfInterestIds IS NULL THEN 1 ELSE [dbo].[CheckValueInList](P.[Id], @PointOfInterestIds) END) > 0)
		BEGIN
			SELECT		P.[Id], P.[Name], P.[Identifier]
			FROM		[dbo].[Product] P WITH (NOLOCK)
			WHERE		P.[Deleted] = 0 AND P.[Indispensable] = 1
			ORDER BY	P.[Id]
		END

		ELSE
		BEGIN
			SELECT		P.[Id], P.[Name], P.[Identifier]
			FROM		[dbo].[Product] P WITH (NOLOCK)
						INNER JOIN [dbo].[ProductPointOfInterest] PPOI WITH (NOLOCK) ON PPOI.[IdProduct] = P.[Id]
			WHERE		P.[Deleted] = 0 AND P.[Indispensable] = 1
						AND (CASE WHEN @PointOfInterestIds IS NULL THEN 1 ELSE [dbo].[CheckValueInList](PPOI.[IdPointOfInterest], @PointOfInterestIds) END) > 0
			GROUP BY	P.[Id], P.[Name], P.[Identifier]
		END
	END

	ELSE
	BEGIN
		SELECT		P.[Id], P.[Name], P.[Identifier]
		FROM		[dbo].[Product] P WITH (NOLOCK)
		WHERE		P.[Deleted] = 0 AND P.[Indispensable] = 1
		ORDER BY	P.[Id]
	END
END
