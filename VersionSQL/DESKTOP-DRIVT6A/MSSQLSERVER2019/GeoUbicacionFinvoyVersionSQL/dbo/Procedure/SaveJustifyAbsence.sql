/****** Object:  Procedure [dbo].[SaveJustifyAbsence]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================    
-- Author:  <Author,,Name>    
-- Create date: <Create Date,,>    
-- Description: <Description,,>    
-- =============================================    
CREATE PROCEDURE [dbo].[SaveJustifyAbsence]    
(    
  @EntryDate [sys].[datetime]    
 ,@ExitDate [sys].[datetime]   
 ,@IdPersonOfInterest [sys].[int]     
 ,@IdAbsenceReason [sys].[int]     
 ,@IdUser [sys].[INT]     
 ,@Comment [sys].[VARCHAR](1024)  = NULL  
)    
AS    
BEGIN   
  
    DECLARE @CurrentDate DATETIME = @EntryDate  
    DECLARE @DateNow DATETIME = SYSDATETIME()  
  
    WHILE @CurrentDate <= @ExitDate  
    BEGIN  
        IF NOT EXISTS (SELECT 1   
      FROM PersonOfInterestAbsenceJustification   
      WHERE Date = @CurrentDate AND IdPersonOfInterest = @IdPersonOfInterest)  
        BEGIN  
            INSERT INTO PersonOfInterestAbsenceJustification (IdPersonOfInterest, [Date], SavedDate, IdAbsenceReason, Comments)  
            VALUES (@IdPersonOfInterest, @CurrentDate, @DateNow, @IdAbsenceReason, @Comment)  
        END  
  
        SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate)  
    END  
      
END
