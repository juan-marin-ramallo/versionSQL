/****** Object:  Procedure [dbo].[DeletePointsOfInterestActivity]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:        Jesús Portillo
-- Create date: 19/10/2016
-- Description:    SP para guardar varios puntos de interés visitados
-- =============================================
CREATE PROCEDURE [dbo].[DeletePointsOfInterestActivity]
(
     @AutomaticValue [sys].[smallint]
    ,@IdPointOfInterestVisited [sys].[int] = NULL
    ,@IdPointOfInterestManualVisited [sys].[int] = NULL
    ,@IdPersonOfInterest [sys].[int] = null
    ,@IdPointOfInterest [sys].[int] = NULL
    ,@DateIn [sys].[datetime] = NULL
)
AS
BEGIN
    SET NOCOUNT OFF;
    DECLARE @Id [sys].[int]
    DECLARE @OldAutomaticValue [sys].[int]
    DECLARE @ActionValue [sys].[int]
    DECLARE @ActionDate [sys].[datetime]
    DECLARE @ActionDateOut [sys].[datetime]
    DECLARE @IdPointOfInterestSelected [sys].[int]
    DECLARE @IdPointOfInterestMaualVisitSelected [sys].[int]
    DECLARE @InHourWindow [sys].[bit]
    
    SELECT TOP 1 
        @Id = Id, 
        @OldAutomaticValue = [AutomaticValue],
        @ActionValue = [ActionValue], 
        @ActionDate = [ActionDate], 
        @IdPointOfInterestSelected = [IdPointOfInterest],
        @IdPointOfInterestVisited = IdPointOfInterestVisited, 
        @IdPointOfInterestMaualVisitSelected = [IdPointOfInterestManualVisited]
    FROM [dbo].[PointOfInterestActivity] 
    WHERE (@IdPointOfInterestVisited IS NOT NULL AND IdPointOfInterestVisited = @IdPointOfInterestVisited)
        OR (@IdPointOfInterestManualVisited IS NOT NULL AND IdPointOfInterestManualVisited = @IdPointOfInterestManualVisited)

    -- Si no lo encontre por ids busco por la info ordenando por el más reciente por si llega tengo que definir entre 2 dias
    IF @Id IS NULL AND @IdPointOfInterestVisited IS NULL AND @IdPointOfInterestManualVisited IS NULL
    BEGIN
        SELECT TOP 1 @Id = Id, @OldAutomaticValue = [AutomaticValue], @ActionValue = [ActionValue], @ActionDate = [ActionDate], @IdPointOfInterestSelected = IdPointOfInterest
        FROM [dbo].[PointOfInterestActivity] 
        WHERE [IdPointOfInterest] = @IdPointOfInterest AND [IdPersonOfInterest] = @IdPersonOfInterest 
            AND (tzdb.AreSameSystemDates([DateIn], @DateIn) = 1 OR ([DateOut] IS NOT NULL AND tzdb.AreSameSystemDates([DateOut], @DateIn) = 1))
        ORDER BY ABS(DATEDIFF(ms, @DateIn, [DateIn])) ASC
    END        

    IF @Id IS NOT NULL
    BEGIN
        SET @InHourWindow = [dbo].[IsVisitedLocationInPointHourWindowIgnoreConfig](@IdPointOfInterestSelected, @ActionDate, @ActionDate)
        
        -- limpio si es una visita automatica con manual/accion
        IF @AutomaticValue = 1 AND (@ActionValue > 2 OR @IdPointOfInterestMaualVisitSelected IS NOT NULL)
        BEGIN
            -- caso manual
            if @IdPointOfInterestMaualVisitSelected IS NOT NULL
            BEGIN
                SELECT TOP 1 @ActionDate = CheckInDate, @ActionDateOut = CheckOutDate
                FROM dbo.PointOfInterestManualVisited
                WHERE Id = @IdPointOfInterestMaualVisitSelected
            END
            -- caso accion
            ELSE
            BEGIN
                SET @ActionDateOut = @ActionDate
            END

            UPDATE [dbo].[PointOfInterestActivity]
            SET  [IdPointOfInterestVisited] = NULL,
                ActionValue = IIF(@IdPointOfInterestMaualVisitSelected IS NOT NULL, 2, @ActionValue),
                DateIn = @ActionDate,
                DateOut = @ActionDateOut
            WHERE Id = @Id
        END
        -- Limpio y Actualizo si es una visita manual con acción
        ELSE IF @AutomaticValue = 2 AND @ActionValue > 2
        BEGIN
            UPDATE [dbo].[PointOfInterestActivity]
            SET  [IdPointOfInterestManualVisited] = NULL
                ,[AutomaticValue] = @ActionValue
                ,[DateIn] = @ActionDate
                ,[DateOut] = @ActionDate
                ,[ElapsedTime] = NULL
                ,[InHourWindow] = @InHourWindow
            WHERE Id = @Id
        END
        -- Actualizo la tabla [PointOfInterestActivity] si tiene una marca automatica y marca manual

        ELSE IF @AutomaticValue <= 2 AND @OldAutomaticValue = 1 AND @IdPointOfInterestVisited IS NOT NULL 
        BEGIN
            UPDATE POIA
                SET POIA.[IdPointOfInterestManualVisited] = NULL
                    ,POIA.[DateIn] = POIV.LocationInDate
                    ,POIA.[DateOut] = POIV.LocationOutDate
                    ,POIA.[ElapsedTime] = POIV.ElapsedTime
                    ,POIA.[InHourWindow] = [dbo].[IsVisitedLocationInPointHourWindowIgnoreConfig](POIV.IdPointOfInterest,POIV.LocationInDate,ISNULL(POIV.LocationOutDate,POIV.LocationInDate))
                FROM dbo.PointOfInterestActivity POIA
                    INNER JOIN PointOfInterestVisited POIV
                        ON POIV.Id = POIA.IdPointOfInterestVisited
                WHERE POIA.Id = @Id
        END
        
        -- Actualizo la tabla [PointOfInterestActivity] si tiene una marca automatica y marca manual
        ELSE IF @AutomaticValue <= 2 AND @OldAutomaticValue = 1 AND @IdPointOfInterestVisited IS NULL 
        BEGIN
            DELETE [dbo].[PointOfInterestActivity]
            WHERE Id = @Id
        END
        --  Limpio si es una entrada 
        ELSE IF @AutomaticValue <= 2 AND @AutomaticValue = @OldAutomaticValue
        BEGIN
            DELETE [dbo].[PointOfInterestActivity]
            WHERE Id = @Id
        END
    END
END
