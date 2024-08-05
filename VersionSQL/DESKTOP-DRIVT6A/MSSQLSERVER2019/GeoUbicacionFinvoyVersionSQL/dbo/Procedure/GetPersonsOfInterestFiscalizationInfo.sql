/****** Object:  Procedure [dbo].[GetPersonsOfInterestFiscalizationInfo]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 24/08/2023
-- Description:	SP para obtener la información
--              de fiscalización Chilena para
--              las personas de interés dadas
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonsOfInterestFiscalizationInfo]
	@PersonOfInterestIds [sys].[varchar](MAX) = NULL
AS
BEGIN
    SELECT  [IdPersonOfInterest], [IsOutsourced], [IdPlaceOfWork], [WorkOnSundays], [HasSplittedWorkHours], [SplittedWorkHoursResolutionNumber]
    FROM    [dbo].[PersonOfInterestFiscalizationInfo] WITH (NOLOCK)
	WHERE	((@PersonOfInterestIds IS NULL) OR (dbo.[CheckValueInList]([IdPersonOfInterest], @PersonOfInterestIds) = 1))
END
