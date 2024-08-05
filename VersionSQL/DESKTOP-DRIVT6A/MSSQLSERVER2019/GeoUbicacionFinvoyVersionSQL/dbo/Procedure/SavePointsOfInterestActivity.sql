/****** Object:  Procedure [dbo].[SavePointsOfInterestActivity]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:        Jesús Portillo
-- Create date: 19/10/2016
-- Description:    SP para guardar varios puntos de interés visitados
-- =============================================
CREATE PROCEDURE [dbo].[SavePointsOfInterestActivity]
(
     @IdPersonOfInterest [sys].[int]
    ,@IdPointOfInterest [sys].[int]
    ,@DateIn [sys].[datetime]
    ,@DateOut [sys].[datetime] = NULL
    ,@ElapsedTime [sys].[time] = NULL
    ,@AutomaticValue [sys].[smallint]
    ,@IdPointOfInterestVisited [sys].[int] = NULL
    ,@IdPointOfInterestManualVisited [sys].[int] = NULL
)
AS
BEGIN
    SET NOCOUNT OFF;
    DECLARE @Id [sys].[int]
    DECLARE @OldAutomaticValue [sys].[smallint]
    DECLARE @OldActionValue [sys].[smallint]
    --DECLARE @OldElapsedTime [sys].[smallint]
    DECLARE @OldIdPOIV [sys].[int]
    DECLARE @OldIdPOIMV [sys].[int]
    DECLARE @InHourWindow [sys].[bit]

    IF @DateOut IS NULL BEGIN
        SET @DateOut = @DateIn
    END
    
    SELECT TOP 1 @Id = Id --, @OldElapsedTime = ElapsedTime
        , @OldAutomaticValue = AutomaticValue, @OldActionValue = ActionValue
        , @OldIdPOIV = IdPointOfInterestVisited, @OldIdPOIMV = IdPointOfInterestManualVisited 
    FROM [dbo].[PointOfInterestActivity] 
    WHERE IdPersonOfInterest = @IdPersonOfInterest AND IdPointOfInterest = @IdPointOfInterest 
        AND (tzdb.AreSameSystemDates(DateIn, @DateIn) = 1 OR tzdb.AreSameSystemDates(DateOut, @DateOut) = 1)
    ORDER BY DATEDIFF(minute, DateIn, @DateIn) ASC

    SET @InHourWindow = [dbo].[IsVisitedLocationInPointHourWindowIgnoreConfig](@IdPointOfInterest, @DateIn, ISNULL(@DateOut, @DateIn))

    IF @Id IS NULL
    BEGIN
        INSERT INTO [dbo].[PointOfInterestActivity]
               ([IdPersonOfInterest]
               ,[IdPointOfInterest]
               ,[DateIn]
               ,[DateOut]
               ,[InHourWindow]
               ,[AutomaticValue]
               ,[ElapsedTime]
               ,ActionValue
               ,ActionDate
               ,IdPointOfInterestVisited
               ,IdPointOfInterestManualVisited)
         VALUES
               (@IdPersonOfInterest
               ,@IdPointOfInterest
               ,@DateIn
               ,@DateOut
               ,@InHourWindow
               ,@AutomaticValue
               ,@ElapsedTime
               ,IIF(@AutomaticValue > 2, @AutomaticValue, NULL)
               ,IIF(@AutomaticValue > 2, @DateIn, NULL)
               ,@IdPointOfInterestVisited
               ,@IdPointOfInterestManualVisited)
    END
    ELSE 
    BEGIN
        -- Tener en cuenta si realiza al menos una actividad en ventana horaria???
        
        -- Entrada automatica, actualizo Id si no tiene
        IF @AutomaticValue = 1 AND @OldIdPOIV IS NULL
        BEGIN
            UPDATE [dbo].[PointOfInterestActivity]
            SET     [AutomaticValue] = @AutomaticValue
                ,[IdPointOfInterestVisited] = @IdPointOfInterestVisited
            WHERE Id = @Id
        END
        -- Entrada manual, actualizo datos si no tiene
        ELSE IF @AutomaticValue = 2 AND @OldIdPOIMV IS NULL
        BEGIN
            UPDATE [dbo].[PointOfInterestActivity]
            SET  [AutomaticValue] = IIF(@AutomaticValue < @OldAutomaticValue, @AutomaticValue, @OldAutomaticValue) -- Dejar 1 si tiene auto
                ,[DateIn] = @DateIn
                ,[DateOut] = @DateOut
                ,[ElapsedTime] = @ElapsedTime
                ,[InHourWindow] = @InHourWindow
                ,[IdPointOfInterestManualVisited] = @IdPointOfInterestManualVisited
            WHERE Id = @Id
        END
        -- Entrada por acción sin POIV/POIMV
        ELSE IF @AutomaticValue > 2 AND @AutomaticValue < @OldAutomaticValue
        BEGIN
            UPDATE [dbo].[PointOfInterestActivity]
            SET     [AutomaticValue] = @AutomaticValue
                ,[DateIn] = @DateIn
                ,[DateOut] = @DateOut
                ,[InHourWindow] = @InHourWindow
                ,[ElapsedTime] = @ElapsedTime
                ,[ActionDate] = @DateIn
                ,[ActionValue] = @AutomaticValue 
            WHERE Id = @Id
        END
        -- Entrada por acción con POIMV
        ELSE IF @AutomaticValue > 2 AND (@AutomaticValue < @OldActionValue OR @OldActionValue IS NULL)
        BEGIN
            UPDATE [dbo].[PointOfInterestActivity]
            SET     [ActionDate] = @DateIn
                ,[ActionValue] = @AutomaticValue 
            WHERE Id = @Id
        END
    END
END
