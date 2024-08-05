/****** Object:  Procedure [dbo].[IsPersonOfInterestAbsent]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 20/04/2020
-- Description:	SP para saber si una persona de interés está actualmente ausente o no
-- =============================================
CREATE PROCEDURE [dbo].[IsPersonOfInterestAbsent]
(
  @IdPersonOfInterest [sys].[int]
)
AS
BEGIN
  DECLARE @IsAbsent [sys].[bit]
  
  SET @IsAbsent = ISNULL((SELECT  TOP(1) 1
                          FROM    [dbo].[PersonOfInterestAbsence] WITH (NOLOCK)
                          WHERE   [IdPersonOfInterest] = @IdPersonOfInterest
                                  AND [ToDate] IS NULL), 0)
  SELECT @IsAbsent AS IsAbsent	
END
