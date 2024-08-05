/****** Object:  Procedure [dbo].[GetPersonOfInterestWorkShiftsForTemplate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Created by: Juan Marin
-- Modified date: 11/03/2024
-- Description: Se retona info del turno de trabajo y de descanso para el Template
-- =============================================  
CREATE PROCEDURE [dbo].[GetPersonOfInterestWorkShiftsForTemplate]  
 @PersonOfInterestIds [sys].[varchar](MAX) = NULL
AS  
BEGIN  
    SELECT  POIWS.[IdPersonOfInterest], POIWS.[IdDayOfWeek], POIWS.[IdWorkShift], WS.[Name] AS WorkShiftName, POIWS.[IdRestShift], RS.[Name] AS RestShiftName
    FROM    [dbo].[PersonOfInterestWorkShift] POIWS WITH (NOLOCK)  
	INNER JOIN
			[dbo].[WorkShift] WS WITH (NOLOCK)  ON WS.Id = POIWS.IdWorkShift AND WS.Deleted = 0
	INNER JOIN
			[dbo].[WorkShift] RS WITH (NOLOCK)  ON RS.Id = POIWS.IdRestShift AND RS.Deleted = 0
	WHERE  ((@PersonOfInterestIds IS NULL) OR (dbo.[CheckValueInList]([IdPersonOfInterest], @PersonOfInterestIds) = 1))    
    AND 
			POIWS.[Deleted] = 0;  
END
