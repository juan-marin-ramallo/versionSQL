/****** Object:  Procedure [dbo].[SaveScheduleProfile]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  Gaston L.  
-- Create date: 22/10/2018  
-- Description: SP para guardar un schedule profile  
-- =============================================  
CREATE PROCEDURE [dbo].[SaveScheduleProfile]  
   
  @Id [sys].[int] OUTPUT  
 ,@IdUser [sys].[INT]  
 ,@FromDate [sys].[DATETIME]  
 ,@ToDate [sys].[DATETIME]   
 ,@Description [sys].[varchar](200) = NULL  
 ,@AllPointOfInterest [sys].bit  
 ,@AllPersonOfInterest [sys].bit  
 ,@IdPersonsOfInterest [sys].varchar(max) = NULL  
 ,@IdPointsOfInterest [sys].varchar(max) = NULL  
 ,@IdProductReportSections [sys].varchar(max) = NULL  
 ,@ScheduleProfilePermissions ScheduleProfilePermissionTableType READONLY  
 ,@IdPersonOfInterestTypes [sys].[varchar](max)= NULL  
 ,@CronExpression [sys].[VARCHAR](250) = NULL  
 ,@DaysOfWeek [sys].VARCHAR(20) = NULL  
 ,@RecurrenceCondition [sys].CHAR = NULL  
 ,@RecurrenceNumber [sys].[INT] = NULL  
AS  
BEGIN  
  
 DECLARE @IdAux  AS INT  
 DECLARE @dayAux [sys].INT = NULL  
 DECLARE @IdCronExpression [sys].INT = (SELECT Id FROM [dbo].[ScheduleProfileCron] WITH (NOLOCK) WHERE [CronExpression] = @CronExpression)  

  IF @IdCronExpression IS NULL  
 BEGIN  
  INSERT INTO [dbo].[ScheduleProfileCron]([CronExpression])  
  VALUES  (@CronExpression)  
  
  SELECT @IdCronExpression = SCOPE_IDENTITY()  
 END  

 BEGIN TRANSACTION;  
    SAVE TRANSACTION SaveScheduleProfileCompleted;  
 BEGIN TRY  
  
  INSERT INTO [dbo].[ScheduleProfile]  
      ([FromDate]  
      ,[ToDate]  
      ,[Description]  
      ,[AllPersonOfInterest]  
      ,[AllPointOfInterest]  
      ,[CreatedDate]  
      ,[Deleted]  
      ,[IdUser]  
      ,[LimitOneMissingReport]
      ,[IdScheduleProfileCron]
      ,[RecurrenceCondition]
      ,[RecurrenceNumber])  
   VALUES  
      (@FromDate  
      ,@ToDate  
      ,@Description  
      ,@AllPersonOfInterest  
      ,@AllPointOfInterest  
      ,GETUTCDATE()  
      ,0  
      ,@IdUser  
      ,0  -- Not used anymore  
      ,@IdCronExpression  
      ,@RecurrenceCondition  
      ,@RecurrenceNumber)  
  SELECT @Id = SCOPE_IDENTITY()  

  IF LEN(@DaysOfWeek) = 1  
  BEGIN  
    set @dayAux = CONVERT(int, SUBSTRING(@DaysOfWeek, 1, 1))  
    
    INSERT INTO [dbo].[ScheduleProfileDayOfWeek]([IdScheduleProfile], [DayOfWeek])  
    VALUES  (@Id, @dayAux)  
  END  
  
  ELSE  
  BEGIN  
    DECLARE @pos INT = 0  
    DECLARE @len INT = 0  
        
    WHILE CHARINDEX(',', @DaysOfWeek, @pos)>0  
    BEGIN  
      set @len = CHARINDEX(',', @DaysOfWeek, @pos+1) - @pos  
      set @dayAux = CONVERT(int, SUBSTRING(@DaysOfWeek, @pos, @len))  
                  
      INSERT INTO [dbo].[ScheduleProfileDayOfWeek]([IdScheduleProfile], [DayOfWeek])  
      VALUES  (@Id, @dayAux)  
          
      set @pos = CHARINDEX(',', @DaysOfWeek, @pos+@len) +1    
    END    
        
    set @dayAux = CONVERT(int, SUBSTRING(@DaysOfWeek, @pos, 1))      
          
    INSERT INTO [dbo].[ScheduleProfileDayOfWeek]([IdScheduleProfile], [DayOfWeek])    
    VALUES  (@Id, @dayAux)          
  END    

  
  INSERT INTO [dbo].[ScheduleProfileGeneralAssignation] ([IdScheduleProfile], [IdPersonOfInterestType])  
  SELECT  @Id, P.[Code]  
  FROM  [dbo].[PersonOfInterestType] P  
  WHERE  [dbo].[CheckCharValueInList](P.[Code], @IdPersonOfInterestTypes) > 0  
    
  INSERT INTO [dbo].[ScheduleProfilePermission] ([IdScheduleProfile], [IdPersonOfInterestPermission], [LimitOnlyOnce])  
  SELECT  @Id, [IdPersonOfInterestPermission], [LimitOnlyOnce]  
  FROM  @ScheduleProfilePermissions  
  
  INSERT INTO [dbo].[ScheduleProfileProductSection] ([IdScheduleProfile], [IdProductReportSection])  
  SELECT  @Id, S.[Id]  
  FROM  [dbo].[ProductReportSection] S  
  WHERE  [dbo].[CheckValueInList](S.[Id], @IdProductReportSections) > 0  
  
  IF @AllPointOfInterest = 0  
  BEGIN  
   INSERT INTO [dbo].[ScheduleProfileAssignation]([IdScheduleProfile], [IdPointOfInterest], [IdPersonOfInterest])  
   ( SELECT @Id AS IdScheduleProfile, POI.[Id] AS [IdPointOfInterest], P.[Id] AS [IdPersonOfInterest]  
    FROM (SELECT PAux.[Id] FROM dbo.[PersonOfInterest] PAux WITH(NOLOCK) WHERE PAux.Deleted = 0 UNION (SELECT NULL as [Id])) P,  
      -- Me fijo contra los Ids de Puntos agregando el NULL  
      (SELECT POIAux.[Id] FROM dbo.PointOfInterest POIAux WITH(NOLOCK) WHERE POIAux.Deleted = 0 UNION (SELECT NULL as [Id])) POI   
    WHERE  (P.[Id] IS NULL OR dbo.CheckValueInList(P.[Id], @IdPersonsOfInterest) = 1)  
      -- No viene lista ni esta en todos los POI, entonces no esta asignado a punto  
      AND (((@AllPointOfInterest IS NULL OR @AllPointOfInterest = 0) AND @IdPointsOfInterest IS NULL AND POI.[Id] IS NULL)  
      -- O El POI no es null y viene datos en almenos Todos o Lista de pois  
       OR (POI.[Id] IS NOT NULL   
        AND (@AllPointOfInterest = 1 OR @IdPointsOfInterest IS NOT NULL)   
        AND (@IdPointsOfInterest IS NULL OR dbo.CheckValueInList(POI.[Id], @IdPointsOfInterest) = 1)  
        )  
       ))  
  END  
  ELSE  
  BEGIN  
   INSERT INTO [dbo].[ScheduleProfileAssignation]([IdScheduleProfile], [IdPointOfInterest], [IdPersonOfInterest])  
   SELECT  @Id AS IdScheduleProfile, NULL, P.[Id] AS [IdPersonOfInterest]  
   FROM dbo.[PersonOfInterest] P  
   WHERE   (dbo.CheckValueInList(P.[Id], @IdPersonsOfInterest) = 1)  
  END  
  
 END TRY  
    BEGIN CATCH  
        IF @@TRANCOUNT > 0  
        BEGIN  
   SET @Id = 0  
            ROLLBACK TRANSACTION SaveScheduleProfileCompleted; -- rollback to SaveScheduleProfileCompleted  
        END  
    END CATCH  
    COMMIT TRANSACTION  
END  
  
-- OLD)  
-- BEGIN  
  
--  DECLARE @IdAux  AS INT  
--  BEGIN TRANSACTION;  
--     SAVE TRANSACTION SaveScheduleProfileCompleted;  
--  BEGIN TRY  
  
--   INSERT INTO [dbo].[ScheduleProfile]  
--       ([FromDate]  
--       ,[ToDate]  
--       ,[Description]  
--       ,[AllPersonOfInterest]  
--       ,[AllPointOfInterest]  
--       ,[CreatedDate]  
--       ,[Deleted]  
--       ,[IdUser]  
--       ,[LimitOneMissingReport])  
--    VALUES  
--       (@FromDate  
--       ,@ToDate  
--       ,@Description  
--       ,@AllPersonOfInterest  
--       ,@AllPointOfInterest  
--       ,GETUTCDATE()  
--       ,0  
--       ,@IdUser  
--       ,@LimitOneMissingReport)  
--   SELECT @Id = SCOPE_IDENTITY()  
  
--   INSERT INTO [dbo].[ScheduleProfileGeneralAssignation] ([IdScheduleProfile], [IdPersonOfInterestType])  
--   SELECT  @Id ,P.[Code]  
--   FROM  [dbo].[PersonOfInterestType] P  
--   WHERE  [dbo].[CheckCharValueInList](P.[Code], @IdPersonOfInterestTypes) > 0  
    
--   INSERT INTO [dbo].[ScheduleProfilePermission] ([IdScheduleProfile], [IdPersonOfInterestPermission])  
--   SELECT  @Id ,P.[Id]  
--   FROM  [dbo].[PersonOfInterestPermissionTranslated] P  
--   WHERE  [dbo].[CheckValueInList](P.[Id], @IdPermissions) > 0  
  
--   IF @AllPointOfInterest = 0  
--   BEGIN  
--    INSERT INTO [dbo].[ScheduleProfileAssignation]([IdScheduleProfile], [IdPointOfInterest], [IdPersonOfInterest])  
--    ( SELECT @Id AS IdScheduleProfile, POI.[Id] AS [IdPointOfInterest], P.[Id] AS [IdPersonOfInterest]  
--     FROM (SELECT PAux.[Id] FROM dbo.[PersonOfInterest] PAux WITH(NOLOCK) WHERE PAux.Deleted = 0 UNION (SELECT NULL as [Id])) P,  
--       -- Me fijo contra los Ids de Puntos agregando el NULL  
--       (SELECT POIAux.[Id] FROM dbo.PointOfInterest POIAux WITH(NOLOCK) WHERE POIAux.Deleted = 0 UNION (SELECT NULL as [Id])) POI   
--     WHERE  (P.[Id] IS NULL OR dbo.CheckValueInList(P.[Id], @IdPersonsOfInterest) = 1)  
--       -- No viene lista ni esta en todos los POI, entonces no esta asignado a punto  
--       AND (((@AllPointOfInterest IS NULL OR @AllPointOfInterest = 0) AND @IdPointsOfInterest IS NULL AND POI.[Id] IS NULL)  
--       -- O El POI no es null y viene datos en almenos Todos o Lista de pois  
--        OR (POI.[Id] IS NOT NULL   
--         AND (@AllPointOfInterest = 1 OR @IdPointsOfInterest IS NOT NULL)   
--         AND (@IdPointsOfInterest IS NULL OR dbo.CheckValueInList(POI.[Id], @IdPointsOfInterest) = 1)  
--         )  
--        ))  
--   END  
--   ELSE  
--   BEGIN  
--    INSERT INTO [dbo].[ScheduleProfileAssignation]([IdScheduleProfile], [IdPointOfInterest], [IdPersonOfInterest])  
--    SELECT  @Id AS IdScheduleProfile, NULL, P.[Id] AS [IdPersonOfInterest]  
--    FROM dbo.[PersonOfInterest] P  
--    WHERE   (dbo.CheckValueInList(P.[Id], @IdPersonsOfInterest) = 1)  
--   END  
  
--  END TRY  
--     BEGIN CATCH  
--         IF @@TRANCOUNT > 0  
--         BEGIN  
--    SET @Id = 0  
--             ROLLBACK TRANSACTION SaveScheduleProfileCompleted; -- rollback to SaveScheduleProfileCompleted  
--         END  
--     END CATCH  
--     COMMIT TRANSACTION  
-- END
