/****** Object:  Procedure [dbo].[GetDailyActivityReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 20/06/2018
-- Description:	SP para obtener las visitas realizadas para utilizar en el reporte de actividad diaria
-- =============================================
CREATE PROCEDURE [dbo].[GetDailyActivityReport]
(
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL	
	,@IdPointsOfInterest [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
	,@UseAutomaticMarks [sys].[bit] = 1
	,@IncludeDaysNoVisits [sys].[bit] = 1
)
AS
BEGIN

	CREATE TABLE #PointsOfInterestVisitedSomeWay
	(
		[IdPointOfInterestVisited] [sys].[int], IdPersonOfInterest [sys].[int], PersonOfInterestName [sys].[varchar](50), 
		[PersonOfInterestLastName] [sys].[varchar](50), PersonOfInterestIdentifier [sys].[varchar](50), [ActionDate] [sys].[datetime], 
		[Radius] [sys].[int], [MinElapsedTimeForVisit] [sys].[int], [IdDepartment] [sys].[INT], [Latitude] [sys].[decimal](25,20), 
		[Longitude] [sys].[decimal](25,20), [Address] [sys].[varchar](250),
		[LocationInDate] [sys].[datetime], [LocationOutDate] [sys].[datetime], [IdPointOfInterest] [sys].[int], 
		[PointOfInterestName] [sys].[varchar](100), [ElapsedTime] [sys].[time], 
		PointOfInterestIdentifier [sys].[varchar](50), AutomaticValue [sys].[int], Reason [sys].[varchar](100), Number [sys].[int]
	)

	;WITH TablePartition AS 
	( 
		SELECT	[IdPointOfInterestVisited], [IdPersonOfInterest], [PersonOfInterestName], 
				[PersonOfInterestLastName],[PersonOfInterestIdentifier], [ActionDate], [Radius], [MinElapsedTimeForVisit], [IdDepartment],
				[Latitude], [Longitude], [Address], [LocationInDate],[LocationOutDate],
				[IdPointOfInterest], [PointOfInterestName],[ElapsedTime], [PointOfInterestIdentifier],
				[AutomaticValue],[Reason],
				ROW_NUMBER() OVER 
				( 
					PARTITION BY IdPersonOfInterest, IdPointOfInterest, ActionDate
					ORDER BY AutomaticValue 
				) AS Number 
		 FROM [dbo].PointsOfInterestVisitedDailyReport(@DateFrom, @DateTo, @IdPersonsOfInterest, 
			@IdPointsOfInterest, @UseAutomaticMarks, @IdUser) POIV
	) 

	INSERT INTO #PointsOfInterestVisitedSomeWay(IdPointOfInterestVisited , IdPersonOfInterest , PersonOfInterestName, 
			PersonOfInterestLastName,[PersonOfInterestIdentifier], [ActionDate], [Radius], [MinElapsedTimeForVisit], [IdDepartment],
			[Latitude], [Longitude], [Address], LocationInDate , LocationOutDate , [IdPointOfInterest], 
			[PointOfInterestName], [ElapsedTime] , PointOfInterestIdentifier , AutomaticValue , Reason, Number)
	SELECT * FROM TablePartition WHERE Number = 1

	
	
	SELECT	P.[IdPointOfInterest], P.[PointOfInterestName], P.[IdPersonOfInterest], P.[PersonOfInterestName], 
			P.[PersonOfInterestLastName], P.[PersonOfInterestIdentifier], P.[Address], P.[Latitude], P.[Longitude], P.[IdDepartment], P.[LocationInDate], 
			P.[LocationOutDate], P.[ActionDate], P.[IdPersonOfInterest], P.[PointOfInterestIdentifier], P.[ElapsedTime]
	
	FROM	#PointsOfInterestVisitedSomeWay P
	
	GROUP
	BY		P.[IdPointOfInterest], P.[PointOfInterestName], P.[IdPersonOfInterest], P.[PersonOfInterestName], 
			P.[PersonOfInterestLastName], P.[PersonOfInterestIdentifier], P.[Address], P.[Latitude], P.[Longitude], P.[IdDepartment], P.[LocationInDate], P.[LocationOutDate],
			P.[ActionDate], P.[IdPersonOfInterest], P.[PointOfInterestIdentifier], P.[ElapsedTime]

	ORDER 
	BY		P.[IdPersonOfInterest], P.[ActionDate] ASC 



	DROP TABLE #PointsOfInterestVisitedSomeWay
	
END
