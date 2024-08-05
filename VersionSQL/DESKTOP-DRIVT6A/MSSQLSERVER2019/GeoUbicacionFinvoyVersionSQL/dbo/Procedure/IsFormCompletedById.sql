/****** Object:  Procedure [dbo].[IsFormCompletedById]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[IsFormCompletedById]
	 @Id [sys].[int]
	,@DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@PointOfInterestIds [sys].[varchar](MAX) = NULL
	,@StockersIds [sys].[varchar](MAX) = NULL
AS
BEGIN

	DECLARE @DateFromTruncated [sys].[datetime]
	DECLARE @DateToTruncated [sys].[datetime]
	DECLARE @FormIdLocal [sys].[INT]
	DECLARE @PointOfInterestIdsLocal [sys].[varchar](MAX)
	DECLARE @StockersIdsLocal [sys].[varchar](MAX)

	SET @DateFromTruncated = @DateFrom
	SET @DateToTruncated = @DateTo
	SET @FormIdLocal = @Id
	SET @PointOfInterestIdsLocal = @PointOfInterestIds
	SET @StockersIdsLocal = @StockersIds

	SELECT		TOP 1 F.[Id]

	FROM		[dbo].[Form] F
				INNER JOIN [dbo].[User] U ON F.[IdUser] = U.[Id]
				LEFT JOIN [dbo].[FormCategory] FC ON FC.[Id] = F.[IdFormCategory]
				LEFT OUTER JOIN [dbo].[Parameter] PT WITH (NOLOCK) ON PT.[Id] = F.[IdFormType]
				INNER JOIN [dbo].[CompletedForm] CF ON F.[Id] = CF.[IdForm]
				LEFT OUTER JOIN [dbo].[PointOfInterest] P ON P.[Id] = CF.[IdPointOfInterest]
				INNER JOIN [dbo].[PersonOfInterest] S ON S.[Id] = CF.[IdPersonOfInterest]
	
	WHERE		F.[Id] = @FormIdLocal AND
				((CF.[Date] >= @DateFromTruncated AND CF.[Date] <= @DateToTruncated) OR
					(CF.[StartDate] >= @DateFromTruncated AND CF.[StartDate] <= @DateToTruncated)) AND
				((@PointOfInterestIdsLocal IS NULL) OR (dbo.[CheckValueInList](CF.[IdPointOfInterest], @PointOfInterestIdsLocal) = 1)) AND
				((@StockersIdsLocal IS NULL) OR (dbo.[CheckValueInList](CF.[IdPersonOfInterest], @StockersIdsLocal) = 1))

	
	GROUP BY	F.[Id]
END
