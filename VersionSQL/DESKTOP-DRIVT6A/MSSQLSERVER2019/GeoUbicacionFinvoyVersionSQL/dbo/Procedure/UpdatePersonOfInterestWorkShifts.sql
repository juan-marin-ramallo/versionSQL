/****** Object:  Procedure [dbo].[UpdatePersonOfInterestWorkShifts]    Committed by VersionSQL https://www.versionsql.com ******/

-- ==============================================================    
-- Author:  Jesús Portillo    
-- Create date: 24/08/2023    
-- Description: SP para actualizar los turnos de trabajo de una    
--              persona de interés    
-- Modified by: Juan Marin
-- Modified date: 21/03/2024
-- Description: Se corrige el actualizar para permitie activar un turno que estaba eliminado logicamente, y se cambia el eliminado fisico por el logico
-- ==============================================================    
CREATE PROCEDURE [dbo].[UpdatePersonOfInterestWorkShifts]    
(    
     @IdPersonOfInterest [sys].[int]       
 ,@WorkShifts [dbo].[WorkShiftTableType] READONLY    
)    
AS    
BEGIN    
    DECLARE @Now [sys].[datetime] = GETUTCDATE();    
    
    -- MERGE INTO [dbo].[PersonOfInterestWorkShift] AS T    
    -- USING @WorkShifts AS S    
    -- ON T.[IdPersonOfInterest] = @IdPersonOfInterest AND T.[IdDayOfWeek] = S.[IdDayOfWeek] AND T.[IdWorkShift] = S.[IdWorkShift]    
    -- WHEN MATCHED AND ISNULL(T.[IdRestShift], 0) <> ISNULL(S.[IdRestShift], 0) THEN    
    --     -- Change on rest shift    
    --     UPDATE SET T.[IdRestShift] = S.[IdRestShift]    
    -- WHEN NOT MATCHED BY TARGET THEN    
    --     -- Insert new    
    --     INSERT ([IdPersonOfInterest], [IdDayOfWeek], [IdWorkShift], [IdRestShift], [AssignedDate], [Deleted])    
    --     VALUES (@IdPersonOfInterest, S.[IdDayOfWeek], S.[IdWorkShift], S.[IdRestShift], @Now, 0)    
    -- WHEN NOT MATCHED BY SOURCE AND T.[IdPersonOfInterest] = @IdPersonOfInterest THEN    
    --     -- Delete...    
    --     DELETE;    
    
    -- INSERT    
    CREATE TABLE #InsertedData    
    (    
         [IdDayOfWeek] [sys].[smallint]    
        ,[IdWorkShift] [sys].[int]    
        ,[AssignedDate] [sys].[datetime]    
    )    
    
    INSERT INTO [dbo].[PersonOfInterestWorkShift] ([IdPersonOfInterest], [IdDayOfWeek], [IdWorkShift], [IdRestShift], [AssignedDate], [Deleted])    
    OUTPUT INSERTED.[IdDayOfWeek], INSERTED.[IdWorkShift], INSERTED.[AssignedDate]    
    INTO #InsertedData ([IdDayOfWeek], [IdWorkShift], [AssignedDate])    
    SELECT  @IdPersonOfInterest, WS.[IdDayOfWeek], WS.[IdWorkShift], WS.[IdRestShift], @Now, 0    
    FROM    @WorkShifts AS WS    
    WHERE   NOT EXISTS (    
            SELECT 1    
            FROM [dbo].[PersonOfInterestWorkShift] AS PIWS    
            WHERE PIWS.[IdPersonOfInterest] = @IdPersonOfInterest    
            AND PIWS.[IdDayOfWeek] = WS.[IdDayOfWeek] 
            -- AND PIWS.[IdWorkShift] = WS.[IdWorkShift]    
    );    
    
    INSERT INTO [dbo].[PersonOfInterestWorkShiftModification]([Date], [IdPersonOfInterest], [IdDayOfWeek],    
  [IdCurrentWorkShift], [CurrentWorkShiftStartTime], [CurrentWorkShiftEndTime], [CurrentWorkShiftAssignedDate],    
        [IdWorkShiftRecurrenceType], [IdNewWorkShift], [NewWorkShiftStartTime], [NewWorkShiftEndTime], [NewWorkShiftAssignedDate],    
        [IdWorkShiftRequestor])    
    SELECT  @Now, @IdPersonOfInterest, ID.[IdDayOfWeek], NULL, NULL, NULL, NULL, 1,    
            ID.[IdWorkShift], WS.[StartTime], WS.[EndTime], ID.[AssignedDate], 1    
    FROM    #InsertedData ID    
            INNER JOIN [dbo].[WorkShift] WS ON WS.[Id] = ID.[IdWorkShift];    
    
    DROP TABLE #InsertedData;    
    
    -- UPDATE    
    CREATE TABLE #UpdatedData    
    (    
         [IdDayOfWeek] [sys].[smallint]    
        ,[IdCurrentWorkShift] [sys].[int]    
  ,[CurrentAssignedDate] [sys].[datetime]    
        ,[IdNewWorkShift] [sys].[int]    
        ,[NewAssignedDate] [sys].[datetime]    
    )    
    
    UPDATE  PIWS    
    SET     PIWS.[IdWorkShift] = WS.[IdWorkShift], PIWS.[IdRestShift] = WS.[IdRestShift], [AssignedDate] = @Now ,  [Deleted] = 0, [DeletedDate] = NULL
    OUTPUT  INSERTED.[IdDayOfWeek], DELETED.[IdWorkShift], DELETED.[AssignedDate], INSERTED.[IdWorkShift], INSERTED.[AssignedDate]    
    INTO    #UpdatedData ([IdDayOfWeek], [IdCurrentWorkShift], [CurrentAssignedDate], [IdNewWorkShift], [NewAssignedDate])    
    FROM    [dbo].[PersonOfInterestWorkShift] AS PIWS    
            INNER JOIN @WorkShifts AS WS    
                ON PIWS.[IdPersonOfInterest] = @IdPersonOfInterest    
                AND WS.[IdDayOfWeek] = PIWS.[IdDayOfWeek]    
                AND ((PIWS.[IdWorkShift] <> WS.[IdWorkShift] OR ISNULL(PIWS.[IdRestShift], 0) <> ISNULL(WS.[IdRestShift], 0)) OR PIWS.Deleted = 1);


				
    -- MERGE INTO [dbo].[PersonOfInterestWorkShift] AS PIWS    
    -- USING @WorkShifts AS WS    
    -- ON PIWS.[IdPersonOfInterest] = @IdPersonOfInterest    
    -- AND PIWS.[IdDayOfWeek] = WS.[IdDayOfWeek]    
    -- AND PIWS.[IdWorkShift] = WS.[IdWorkShift]    
    -- WHEN MATCHED AND ISNULL(PIWS.[IdRestShift], 0) <> ISNULL(WS.[IdRestShift], 0) THEN    
    --     UPDATE SET PIWS.[IdRestShift] = WS.[IdRestShift]    
    -- OUTPUT    
    --     INSERTED.[IdDayOfWeek],    
    --     DELETED.[IdWorkShift],    
    --     DELETED.[AssignedDate],    
    --     INSERTED.[IdWorkShift],    
    --     INSERTED.[AssignedDate]    
    -- INTO #UpdatedData ([IdDayOfWeek], [IdCurrentWorkShift], [CurrentAssignedDate], [IdNewWorkShift], [NewAssignedDate]);    
    
    INSERT INTO [dbo].[PersonOfInterestWorkShiftModification]([Date], [IdPersonOfInterest], [IdDayOfWeek],    
  [IdCurrentWorkShift], [CurrentWorkShiftStartTime], [CurrentWorkShiftEndTime], [CurrentWorkShiftAssignedDate],    
        [IdWorkShiftRecurrenceType], [IdNewWorkShift], [NewWorkShiftStartTime], [NewWorkShiftEndTime], [NewWorkShiftAssignedDate],    
        [IdWorkShiftRequestor])    
    SELECT  @Now, @IdPersonOfInterest, DD.[IdDayOfWeek],    
   DD.[IdCurrentWorkShift], CWS.[StartTime], CWS.[EndTime], DD.[CurrentAssignedDate], 1,    
            ND.[IdNewWorkShift], NWS.[StartTime], NWS.[EndTime], ND.[CurrentAssignedDate], 1    
    FROM    #UpdatedData DD    
            INNER JOIN [dbo].[WorkShift] CWS ON CWS.[Id] = DD.[IdCurrentWorkShift]    
            INNER JOIN #UpdatedData ND ON ND.[IdDayOfWeek] = DD.[IdDayOfWeek] AND ND.[IdNewWorkShift] IS NOT NULL    
            INNER JOIN [dbo].[WorkShift] NWS ON NWS.[Id] = ND.[IdNewWorkShift]    
    WHERE   DD.[IdCurrentWorkShift] IS NOT NULL;    
    
    DROP TABLE #UpdatedData;    
    
    -- DELETE    
    CREATE TABLE #DeletedData    
    (    
         [IdDayOfWeek] [sys].[smallint]    
        ,[IdWorkShift] [sys].[int]    
        ,[AssignedDate] [sys].[datetime]    
    )    
    
    /*
	DELETE  PIWS    
    OUTPUT  DELETED.[IdDayOfWeek], DELETED.[IdWorkShift], DELETED.[AssignedDate]    
    INTO    #DeletedData (IdDayOfWeek, IdWorkShift, AssignedDate)    
    FROM    [dbo].[PersonOfInterestWorkShift] AS PIWS    
            LEFT JOIN @WorkShifts AS WS    
                ON PIWS.[IdPersonOfInterest] = @IdPersonOfInterest    
                AND PIWS.[IdDayOfWeek] = WS.[IdDayOfWeek]    
                AND PIWS.[IdWorkShift] = WS.[IdWorkShift]    
    WHERE   PIWS.[IdPersonOfInterest] = @IdPersonOfInterest    
            AND WS.[IdDayOfWeek] IS NULL; */

	UPDATE  PIWS    
    SET     [Deleted] = 1, [DeletedDate] = @Now
    OUTPUT  DELETED.[IdDayOfWeek], DELETED.[IdWorkShift], DELETED.[AssignedDate]    
    INTO    #DeletedData (IdDayOfWeek, IdWorkShift, AssignedDate)    
    FROM    [dbo].[PersonOfInterestWorkShift] AS PIWS    
            LEFT JOIN @WorkShifts AS WS    
                ON PIWS.[IdPersonOfInterest] = @IdPersonOfInterest    
                AND PIWS.[IdDayOfWeek] = WS.[IdDayOfWeek]    
                AND PIWS.[IdWorkShift] = WS.[IdWorkShift]  AND PIWS.Deleted = 0  
    WHERE   PIWS.[IdPersonOfInterest] = @IdPersonOfInterest  
			AND WS.[IdWorkShift] IS NULL
            AND WS.[IdDayOfWeek] IS NULL;

    
    INSERT INTO [dbo].[PersonOfInterestWorkShiftModification]([Date], [IdPersonOfInterest], [IdDayOfWeek],    
  [IdCurrentWorkShift], [CurrentWorkShiftStartTime], [CurrentWorkShiftEndTime], [CurrentWorkShiftAssignedDate],    
        [IdWorkShiftRecurrenceType], [IdNewWorkShift], [NewWorkShiftStartTime], [NewWorkShiftEndTime], [NewWorkShiftAssignedDate],    
        [IdWorkShiftRequestor])    
    SELECT  @Now, @IdPersonOfInterest, DD.[IdDayOfWeek],    
   DD.[IdWorkShift], WS.[StartTime], WS.[EndTime], DD.[AssignedDate], 1,    
            NULL, NULL, NULL, NULL, 1    
    FROM    #DeletedData DD    
            INNER JOIN [dbo].[WorkShift] WS ON WS.[Id] = DD.[IdWorkShift];    
    
    DROP TABLE #DeletedData;
END
