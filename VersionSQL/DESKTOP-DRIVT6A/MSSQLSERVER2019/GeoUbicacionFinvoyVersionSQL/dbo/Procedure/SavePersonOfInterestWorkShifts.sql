/****** Object:  Procedure [dbo].[SavePersonOfInterestWorkShifts]    Committed by VersionSQL https://www.versionsql.com ******/

-- ==============================================================  
-- Author:  Jesús Portillo  
-- Create date: 24/08/2023  
-- Description: SP para guardar los turnos de trabajo de una  
--              persona de interés  
-- ==============================================================  
CREATE PROCEDURE [dbo].[SavePersonOfInterestWorkShifts]  
(  
     @IdPersonOfInterest [sys].[int]     
	,@WorkShifts [dbo].[WorkShiftTableType] READONLY  
)  
AS  
BEGIN  
    DECLARE @Now [sys].[datetime] = GETUTCDATE();  
  
    INSERT INTO [dbo].[PersonOfInterestWorkShift]([IdPersonOfInterest], [IdDayOfWeek], [IdWorkShift], [IdRestShift], [AssignedDate], [Deleted])  
    SELECT @IdPersonOfInterest, [IdDayOfWeek], [IdWorkShift], [IdRestShift], @Now, 0  
    FROM @WorkShifts;  
  
    INSERT INTO [dbo].[PersonOfInterestWorkShiftModification]([Date], [IdPersonOfInterest], [IdDayOfWeek],  
  [IdCurrentWorkShift], [CurrentWorkShiftStartTime], [CurrentWorkShiftEndTime], [CurrentWorkShiftAssignedDate],  
        [IdWorkShiftRecurrenceType], [IdNewWorkShift], [NewWorkShiftStartTime], [NewWorkShiftEndTime], [NewWorkShiftAssignedDate],  
        [IdWorkShiftRequestor])  
    SELECT  @Now, @IdPersonOfInterest, SH.[IdDayOfWeek], NULL, NULL, NULL, NULL,  
   1, SH.[IdWorkShift], WS.[StartTime], WS.[EndTime], @Now, 1  
    FROM    @WorkShifts SH  
            INNER JOIN [dbo].[WorkShift] WS ON WS.[Id] = SH.[IdWorkShift];  
END
