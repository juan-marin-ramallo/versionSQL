/****** Object:  Procedure [dbo].[GetPersonsOfInterestFiscalizationInfoForTempate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  Juan Marin
-- Create date: 12/03/2024  
-- Description: SP para obtener la información  
--              de fiscalización Chilena para  
--              las personas de interés dadas para el template 
-- =============================================  
CREATE PROCEDURE [dbo].[GetPersonsOfInterestFiscalizationInfoForTempate]  
  @PersonOfInterestIds [sys].[varchar](MAX) = NULL
AS  
BEGIN  
    SELECT  POIFI.[IdPersonOfInterest], POIFI.[IsOutsourced], POIFI.[IdPlaceOfWork], PW.[Identifier]  AS PlaceOfWorkIdentifier, PW.[Name] AS PlaceOfWorkName, PW.BusinessName AS PlaceOfWorkBusinessName, 
			POIFI.[WorkOnSundays], POIFI.[HasSplittedWorkHours], POIFI.[SplittedWorkHoursResolutionNumber]  
    FROM    [dbo].[PersonOfInterestFiscalizationInfo] POIFI WITH (NOLOCK)  
	LEFT JOIN
			[dbo].[PlaceOfWork] PW  WITH (NOLOCK)  ON PW.Id = POIFI.IdPlaceOfWork
	WHERE ((@PersonOfInterestIds IS NULL) OR (dbo.[CheckValueInList]([IdPersonOfInterest], @PersonOfInterestIds) = 1))    
END
