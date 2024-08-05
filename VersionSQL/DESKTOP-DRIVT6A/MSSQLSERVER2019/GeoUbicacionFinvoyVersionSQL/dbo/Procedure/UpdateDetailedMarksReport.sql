/****** Object:  Procedure [dbo].[UpdateDetailedMarksReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[UpdateDetailedMarksReport]  
(  
  @EntryDate [sys].[datetime]  
 ,@ExitDate [sys].[datetime] = NULL  
 ,@RestStartDate [sys].[datetime] = NULL  
 ,@RestEndDate [sys].[datetime] = NULL  
 ,@Id [sys].[int]   
 ,@IdUser [sys].[INT]   
 ,@Comment [sys].VARCHAR(1024)  
)  
AS  
BEGIN  
  
	INSERT INTO [dbo].[MarkLog]([IdUser],[Date],[Comment],[IdEntry],[EntryDateOld],[EntryDate],[IdExit],[ExitDateOld],[ExitDate],
			[IdRestStart],[RestStartDate], [RestStartDateOld],IdRestEnd, [RestEndDate], [RestEndDateOld])  
	SELECT @IdUser, GETUTCDATE(), @Comment, @Id, Me.[Date], @EntryDate, MS.Id, MS.[Date], @ExitDate, 
		MSRestStart.Id, @RestStartDate, MSRestStart.[Date], MSRestEnd.Id,@RestEndDate, MSRestEnd.[Date]
	FROM dbo.Mark ME   
		LEFT OUTER JOIN dbo.Mark MS 
		    ON ME.Id = MS.IdParent AND MS.[Type] = 'S'  
		LEFT OUTER JOIN dbo.Mark MSRestStart
		    ON ME.Id = MSRestStart.IdParent AND MSRestStart.[Type] = 'ED'
		LEFT OUTER JOIN dbo.Mark MSRestEnd
		    ON ME.Id = MSRestEnd.IdParent AND MSRestEnd.[Type] = 'SD'
	WHERE ME.Id = @Id  
	DECLARE @IdLog [sys].[INT] = SCOPE_IDENTITY()  
   
	UPDATE [dbo].[Mark]  
	SET  [Date] = @EntryDate, [Edited] = 1  
	WHERE [Id] = @Id  
  
	DECLARE @IdExitMark int = (SELECT Id FROM Mark WHERE [IdParent] = @Id AND [Type] = 'S')  
  
	IF (@IdExitMark IS NOT NULL) 
	BEGIN  
		IF (@ExitDate IS NULL) 
		BEGIN  
  
			UPDATE [dbo].[Mark]  
			SET  [Edited] = 1, [Deleted] = 1  
			WHERE Id = @IdExitMark  
  
		END 
		ELSE 
		BEGIN  
  
			UPDATE [dbo].[Mark]  
			SET  [Date] = @ExitDate, [Edited] = 1, [Deleted] = 0  
			WHERE Id = @IdExitMark  
  
		END  
	END 
	ELSE IF (@ExitDate IS NOT NULL) 
	BEGIN  
  
		INSERT INTO Mark (IdPersonOfInterest, [Type], [Date], Latitude, Longitude, Accuracy, ReceivedDate, IdParent, LatLong, IdPointOfInterest, Edited)  
		SELECT IdPersonOfInterest, 'S', @ExitDate, Latitude, Longitude, Accuracy, ReceivedDate, Id, LatLong, IdPointOfInterest, 1  
		FROM Mark  
		WHERE Id = @Id  
			AND [Type] = 'E'  
  
		SET @IdExitMark = SCOPE_IDENTITY()  
  
		UPDATE dbo.[MarkLog]  
		SET IdExit = @IdExitMark  
		WHERE Id = @IdLog  
  	
	END  
  
	DECLARE @IdRestStartMark INT = (SELECT Id FROM Mark WHERE [IdParent] = @Id AND [Type] = 'ED');
	
	IF (@IdRestStartMark IS NOT NULL) 
	BEGIN  
	    IF (@RestStartDate IS NULL) 
	    BEGIN  
	        UPDATE [dbo].[Mark]  
	        SET [Edited] = 1, [Deleted] = 1  
	        WHERE Id = @IdRestStartMark;  
	    END 
	    ELSE 
	    BEGIN  
	        UPDATE [dbo].[Mark]  
	        SET [Date] = @RestStartDate, [Edited] = 1, [Deleted] = 0  
	        WHERE Id = @IdRestStartMark;  
	    END  
	END 
	ELSE IF (@RestStartDate IS NOT NULL) 
	BEGIN  
	    INSERT INTO Mark (IdPersonOfInterest, [Type], [Date], Latitude, Longitude, Accuracy, ReceivedDate, IdParent, LatLong, IdPointOfInterest, Edited)  
	    SELECT IdPersonOfInterest, 'ED', @RestStartDate, Latitude, Longitude, Accuracy, ReceivedDate, Id, LatLong, IdPointOfInterest, 1  
	    FROM Mark  
	    WHERE Id = @Id  
	        AND [Type] = 'E';  
	  
	    SET @IdRestStartMark = SCOPE_IDENTITY();  
	  
	    UPDATE dbo.[MarkLog]  
	    SET RestStartDate = @IdRestStartMark  
	    WHERE Id = @IdLog  
	END
	
	DECLARE @IdRestEndMark INT = (SELECT Id FROM Mark WHERE [IdParent] = @Id AND [Type] = 'SD');
	
	IF (@IdRestEndMark IS NOT NULL) 
	BEGIN  
	    IF (@RestEndDate IS NULL) 
	    BEGIN  
	        UPDATE [dbo].[Mark]  
	        SET [Edited] = 1, [Deleted] = 1  
	        WHERE Id = @IdRestEndMark;  
	    END 
	    ELSE 
	    BEGIN  
	        UPDATE [dbo].[Mark]  
	        SET [Date] = @RestEndDate, [Edited] = 1, [Deleted] = 0  
	        WHERE Id = @IdRestEndMark;  
	    END  
	END 
	ELSE IF (@RestEndDate IS NOT NULL) 
	BEGIN  
	    INSERT INTO Mark (IdPersonOfInterest, [Type], [Date], Latitude, Longitude, Accuracy, ReceivedDate, IdParent, LatLong, IdPointOfInterest, Edited)  
	    SELECT IdPersonOfInterest, 'SD', @RestEndDate, Latitude, Longitude, Accuracy, ReceivedDate, Id, LatLong, IdPointOfInterest, 1  
	    FROM Mark  
	    WHERE Id = @Id  
	        AND [Type] = 'E';  
	  
	    SET @IdRestEndMark = SCOPE_IDENTITY();  
	  
	    UPDATE dbo.[MarkLog]  
	    SET RestEndDate = @IdRestEndMark  
	    WHERE Id = @IdLog;  
	END;

  
END
