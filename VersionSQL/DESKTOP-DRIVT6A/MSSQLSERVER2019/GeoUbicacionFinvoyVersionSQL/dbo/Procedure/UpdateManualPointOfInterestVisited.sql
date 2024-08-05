/****** Object:  Procedure [dbo].[UpdateManualPointOfInterestVisited]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 17/01/2016
-- Description:	SP para actuaizar entradas y salidas manuales a puntos de venta
-- =============================================
CREATE PROCEDURE [dbo].[UpdateManualPointOfInterestVisited]
(
	 @EntryDate [sys].[datetime]
	,@ExitDate [sys].[datetime]
	,@Id [sys].[int] 
)
AS
BEGIN
	DECLARE @IdPointOfInterest [sys].[int]
	DECLARE @ElapsedTime [sys].[time](7)
	SET @ElapsedTime =  CONVERT(varchar,(@ExitDate-@EntryDate),108)
	
	UPDATE	[dbo].[PointOfInterestManualVisited]
	SET		[CheckInDate] = @EntryDate, [CheckOutDate] = @ExitDate, [Edited] = 1,
			[ElapsedTime] = @ElapsedTime
	WHERE	[Id] = @Id

	SET @IdPointOfInterest = (SELECT IdPointOfInterest FROM [dbo].[PointOfInterestManualVisited] WHERE [Id] = @Id)

	EXEC [dbo].[UpdatePointsOfInterestActivity]
		 @IdPointOfInterest = @IdPointOfInterest
		,@DateIn = @EntryDate
		,@DateOut = @ExitDate
		,@ElapsedTime = @ElapsedTime
		,@AutomaticValue = 2
		,@IdPointOfInterestManualVisited = @Id

END
