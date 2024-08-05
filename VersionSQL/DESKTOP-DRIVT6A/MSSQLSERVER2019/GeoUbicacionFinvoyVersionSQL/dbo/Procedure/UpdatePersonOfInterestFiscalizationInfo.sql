/****** Object:  Procedure [dbo].[UpdatePersonOfInterestFiscalizationInfo]    Committed by VersionSQL https://www.versionsql.com ******/

-- ==============================================================
-- Author:		Jesús Portillo
-- Create date: 25/08/2023 (Independence day!)
-- Description:	SP para actualizar la información de
--              fiscalización Chilena para una persona de interés
-- ==============================================================
CREATE PROCEDURE [dbo].[UpdatePersonOfInterestFiscalizationInfo]
(
     @IdPersonOfInterest [sys].[int]
	,@IsOutsourced [sys].[bit]
    ,@IdPlaceOfWork [sys].[int] = NULL
    ,@WorkOnSundays [sys].[bit]
    ,@HasSplittedWorkHours [sys].[bit]
    ,@SplittedWorkHoursResolutionNumber [sys].[varchar](50) = NULL
)
AS
BEGIN
    UPDATE  [dbo].[PersonOfInterestFiscalizationInfo]
    SET     [IsOutsourced] = @IsOutsourced,
            [IdPlaceOfWork] = @IdPlaceOfWork,
            [WorkOnSundays] = @WorkOnSundays,
            [HasSplittedWorkHours] = @HasSplittedWorkHours,
            [SplittedWorkHoursResolutionNumber] = @SplittedWorkHoursResolutionNumber
    WHERE   [IdPersonOfInterest] = @IdPersonOfInterest;
END
