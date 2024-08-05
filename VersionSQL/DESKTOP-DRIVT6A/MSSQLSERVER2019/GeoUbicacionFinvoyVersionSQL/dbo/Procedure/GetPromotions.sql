/****** Object:  Procedure [dbo].[GetPromotions]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston Legnani
-- Create date: 25/07/2016
-- Description:	SP para obtener las promociones
-- =============================================
CREATE PROCEDURE [dbo].[GetPromotions]

	 @IdUser [sys].[int] = NULL
	,@PromotionIds [sys].[varchar](max) = NULL
	,@PointOfInterestIds [sys].[varchar](MAX) = NULL
	,@FilterOption [sys].[int] = 2
	,@AllPromotions [sys].[bit] = NULL
AS
BEGIN
	DECLARE @SystemToday [sys].[datetime]
	SET @SystemToday = DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(GETUTCDATE())), 0)

	;WITH vPromotions([Id], [Name], [AllPointOfInterest], [CreatedDate], [Deleted], [DeletedDate],
                      [StartDate], [StartDateSystemTruncated], [EndDate], [EndDateSystemTruncated],
                      [Description], [RealFileName], [IdUser]) AS
	(
		SELECT  PRO.[Id], PRO.[Name], PRO.[AllPointOfInterest], PRO.[CreatedDate], PRO.[Deleted], PRO.[DeletedDate],
                PRO.[StartDate], DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(PRO.[StartDate])), 0) AS StartDateSystemTruncated,
                PRO.[EndDate], DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(PRO.[EndDate])), 0) AS EndDateSystemTruncated,
                PRO.[Description], PRO.[RealFileName], PRO.[IdUser]
	    FROM	[dbo].[Promotion] PRO WITH (NOLOCK)
		WHERE	((@PromotionIds IS NULL) OR (dbo.[CheckValueInList](PRO.[Id], @PromotionIds) = 1))
				AND ((@AllPromotions = 1) OR (PRO.[IdUser] = @IdUser))
	)
    
    SELECT		PRO.[Id], PRO.[Name], U.[Id] AS IdUser, U.[Name] AS UserName, U.[LastName] AS UserLastName, PRO.[AllPointOfInterest],
				PRO.[CreatedDate], PRO.[Deleted], PRO.[DeletedDate], PRO.[StartDate], PRO.[EndDate], PRO.[Description], PRO.[RealFileName]
	
	FROM		vPromotions PRO WITH (NOLOCK)
				INNER JOIN [dbo].[User] U WITH (NOLOCK) ON PRO.[IdUser] = U.[Id]
				LEFT JOIN [dbo].[PromotionPointOfInterest] PP WITH (NOLOCK) ON PRO.[Id] = PP.[IdPromotion] 
				LEFT JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = PP.[IdPointOfInterest] AND P.[Deleted] = 0
	
	WHERE		((@PointOfInterestIds IS NULL) OR (dbo.[CheckValueInList](PP.[IdPointOfInterest], @PointOfInterestIds) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
				AND
				((@FilterOption = 1)
					OR (@FilterOption = 2 AND PRO.[Deleted] = 0 AND PRO.[StartDateSystemTruncated] <= @SystemToday AND PRO.[EndDateSystemTruncated] >= @SystemToday) --ACTIVOS
					OR (@FilterOption = 3 AND PRO.[Deleted] = 0 AND PRO.[EndDateSystemTruncated] < @SystemToday) -- VENCIDOS
					OR (@FilterOption = 4 AND PRO.[Deleted] = 1) -- DESACTIVADOS
					OR (@FilterOption = 5 AND PRO.[Deleted] = 0 AND PRO.[StartDateSystemTruncated] > @SystemToday) -- PLANIFICADOS
				)
	
	GROUP BY	PRO.[Id], PRO.[Name], U.[Id], U.[Name], U.[LastName], PRO.[AllPointOfInterest],
				PRO.[CreatedDate], PRO.[Deleted], PRO.[DeletedDate], PRO.[StartDate], PRO.[EndDate],PRO.[Description],[PRO].[RealFileName]
	
	ORDER BY	PRO.[CreatedDate] DESC
END

-- OLD)
-- BEGIN
-- 	DECLARE @Now [sys].[datetime]
-- 	SET @Now = GETUTCDATE()

-- 	SELECT		PRO.[Id], PRO.[Name], U.[Id] AS IdUser, U.[Name] AS UserName, U.[LastName] AS UserLastName, PRO.[AllPointOfInterest],
-- 						PRO.[CreatedDate], PRO.[Deleted], PRO.[DeletedDate], PRO.[StartDate], PRO.[EndDate], PRO.[Description],[PRO].[RealFileName]
	
-- 	FROM		[dbo].[Promotion] PRO
-- 				INNER JOIN [dbo].[User] U ON PRO.[IdUser] = U.[Id]
-- 				LEFT JOIN [dbo].[PromotionPointOfInterest] PP ON PRO.[Id] = PP.[IdPromotion] 
-- 				LEFT JOIN [dbo].[PointOfInterest] P ON P.[Id] = PP.[IdPointOfInterest] AND P.[Deleted] = 0
	
-- 	WHERE		((@PromotionIds IS NULL) OR (dbo.[CheckValueInList](PRO.[Id], @PromotionIds) = 1)) AND
-- 				((@PointOfInterestIds IS NULL) OR (dbo.[CheckValueInList](PP.[IdPointOfInterest], @PointOfInterestIds) = 1)) AND
-- 				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
-- 				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
-- 				((@AllPromotions = 1) OR (PRO.[IdUser] = @IdUser)) 
-- 				AND
-- 				((@FilterOption = 1)
-- 					OR (@FilterOption = 2 AND PRO.[Deleted] = 0 AND Tzdb.IsLowerOrSameSystemDate(PRO.[StartDate], @Now) = 1 AND Tzdb.IsGreaterOrSameSystemDate(PRO.[EndDate], @Now) = 1) --ACTIVOS
-- 					OR (@FilterOption = 3 AND PRO.[Deleted] = 0 AND Tzdb.IsLowerSystemDate(PRO.[EndDate], @Now) = 1) -- VENCIDOS
-- 					OR (@FilterOption = 4 AND PRO.[Deleted] = 1) -- DESACTIVADOS
-- 					OR (@FilterOption = 5 AND PRO.[Deleted] = 0 AND Tzdb.IsGreaterSystemDate(PRO.[StartDate], @Now) = 1) -- PLANIFICADOS
-- 				)
	
-- 	GROUP BY	PRO.[Id], PRO.[Name], U.[Id], U.[Name], U.[LastName], PRO.[AllPointOfInterest],
-- 				PRO.[CreatedDate], PRO.[Deleted], PRO.[DeletedDate], PRO.[StartDate], PRO.[EndDate],PRO.[Description],[PRO].[RealFileName]
	
-- 	ORDER BY	PRO.[CreatedDate] DESC
-- END
