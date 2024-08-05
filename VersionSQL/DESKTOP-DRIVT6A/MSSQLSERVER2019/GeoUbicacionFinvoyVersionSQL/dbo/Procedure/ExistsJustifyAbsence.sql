/****** Object:  Procedure [dbo].[ExistsJustifyAbsence]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[ExistsJustifyAbsence]    
(    
  @EntryDate [sys].[datetime]    
 ,@ExitDate [sys].[datetime]   
 ,@IdPersonOfInterest [sys].[int]
  ,@Exists [sys].[BIT] OUTPUT
)    
AS    
BEGIN   
	
     SET @Exists= ISNULL((SELECT TOP 1 1  Exist
      FROM PersonOfInterestAbsenceJustification  POIAJ
      WHERE (POIAJ.[Date] BETWEEN  @EntryDate AND @ExitDate)
		AND IdPersonOfInterest = @IdPersonOfInterest),0)
      
END
