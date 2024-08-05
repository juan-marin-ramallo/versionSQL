/****** Object:  Procedure [dbo].[SaveScheduleProfileCatalog]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  Juan Marin  
-- Create date: 15/01/2024  
-- Description: SP para guardar una planificacion de Catalogos
-- =============================================  
CREATE PROCEDURE [dbo].[SaveScheduleProfileCatalog]  
(  
  @IdScheduleProfile [sys].INT = NULL  
 ,@IdCatalog [sys].[INT] = NULL  
 ,@CronExpression [sys].[VARCHAR](250) = NULL
 ,@Comment [sys].[VARCHAR](250) = NULL  
 ,@DaysOfWeek [sys].VARCHAR(20) = NULL   
 ,@RecurrenceCondition [sys].CHAR = NULL  
 ,@RecurrenceNumber [sys].[INT] = NULL  
)  
AS  
BEGIN  
  
 DECLARE @IdScheduleProfileCatalog [sys].[int] = 0  
 DECLARE @dayAux [sys].INT = NULL  
 DECLARE @IdCronExpression [sys].INT = (SELECT Id FROM [dbo].[ScheduleProfileCatalogCron] WITH (NOLOCK) WHERE [CronExpression] = @CronExpression)  

 IF @IdCronExpression IS NULL  
 BEGIN  
  INSERT INTO [dbo].[ScheduleProfileCatalogCron]([CronExpression])  
  VALUES  (@CronExpression)        

  SELECT @IdCronExpression = SCOPE_IDENTITY()
 END  
      
 --******************************************  
 --Primero inserto en la tabla [ScheduleProfileCatalog]  
 INSERT INTO [dbo].[ScheduleProfileCatalog]  
         ( 
			[IdScheduleProfile],
			[IdCatalog],
			[IdScheduleProfileCatalogCron],
			[Comment],  
			[Deleted],
			[RecurrenceCondition],
			[RecurrenceNumber]
         )  
 VALUES  ( 
			@IdScheduleProfile,   
			@IdCatalog,
			@IdCronExpression,
			@Comment,  
			0,
			@RecurrenceCondition,
			@RecurrenceNumber
		)  
   
 SELECT @IdScheduleProfileCatalog = SCOPE_IDENTITY()  
 
 ----******************************************  
 ----Inserto dias de la semana
IF LEN(@DaysOfWeek) = 1  
 BEGIN  
  set @dayAux = CONVERT(int, SUBSTRING(@DaysOfWeek, 1, 1))    
  
  INSERT INTO [dbo].[ScheduleProfileCatalogDayOfWeek]([IdScheduleProfileCatalog], [DayOfWeek])  
  VALUES  (@IdScheduleProfileCatalog, @dayAux)        
END  

ELSE  
 BEGIN  
  DECLARE @pos INT = 0  
  DECLARE @len INT = 0  
  
  WHILE CHARINDEX(',', @DaysOfWeek, @pos)>0  
  BEGIN  
   set @len = CHARINDEX(',', @DaysOfWeek, @pos+1) - @pos  
   set @dayAux = CONVERT(int, SUBSTRING(@DaysOfWeek, @pos, @len))  
          
   INSERT INTO [dbo].[ScheduleProfileCatalogDayOfWeek]([IdScheduleProfileCatalog], [DayOfWeek])  
   VALUES  (@IdScheduleProfileCatalog, @dayAux)        
  
   set @pos = CHARINDEX(',', @DaysOfWeek, @pos+@len) +1  
  END  
  
  --INSERTO EL ULTIMO  
  set @dayAux = CONVERT(int, SUBSTRING(@DaysOfWeek, @pos, 1))    
    
  INSERT INTO [dbo].[ScheduleProfileCatalogDayOfWeek]([IdScheduleProfileCatalog], [DayOfWeek])  
  VALUES  (@IdScheduleProfileCatalog, @dayAux)        
 END  
END
