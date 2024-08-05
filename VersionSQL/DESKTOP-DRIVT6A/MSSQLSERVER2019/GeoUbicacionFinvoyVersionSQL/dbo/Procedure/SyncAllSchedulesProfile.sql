/****** Object:  Procedure [dbo].[SyncAllSchedulesProfile]    Committed by VersionSQL https://www.versionsql.com ******/

-- ====================================================================          
-- Author:  JUAN MARIN          
-- Create date: 25/03/2024          
-- Description: SP para sincronizar las los Cronogramas de Actividades          
-- ====================================================================    
CREATE PROCEDURE [dbo].[SyncAllSchedulesProfile]              
(              
  @SyncType [int]              
 ,@DataScheduleProfile [ScheduleProfileTableType] READONLY              
 ,@DataScheduleProfilePlannedCatalog [ScheduleProfilePlannedCatalogTableType]  READONLY         
 ,@DataScheduleProfilePersonOfInterest [ScheduleProfilePersonOfInterestTableType]  READONLY             
 ,@DataScheduleProfilePointOfInterest [ScheduleProfilePointOfInterestTableType]  READONLY 
 ,@LoggedUserId [INT]              
)              
AS              
BEGIN              
 SET ANSI_WARNINGS  OFF;               
   
 DECLARE @Add [int] = 0   

 DECLARE @Now [sys].[datetime]    
 SET @Now = GETUTCDATE()

 BEGIN TRY

	BEGIN TRANSACTION;  
	
		-- Insert nuevos              
		IF @Add <= @SyncType              
		BEGIN    
			DECLARE @IdScheduleProfile int
			DECLARE @FromDate datetime
			DECLARE @ToDate datetime
			DECLARE @Description varchar(200)
			DECLARE @AllPersonOfInterest bit
			DECLARE @AllPointOfInterest bit
			DECLARE @DaysOfWeekScheduleProfile varchar(20)			
			DECLARE @RecurrenceConditionScheduleProfile char
			DECLARE @RecurrenceNumberScheduleProfile int
			DECLARE @CronExpressionScheduleProfile varchar(250)			
			DECLARE @IdScheduleProfilePermissions varchar(max)	
			DECLARE @IdProductReportSections varchar(max)						
			
			--ScheduleProfileCron
			INSERT INTO [dbo].[ScheduleProfileCron] (CronExpression) 
			SELECT	DISTINCT D.CronExpression
			FROM	@DataScheduleProfile D
			LEFT JOIN
					[dbo].[ScheduleProfileCron] SPC ON SPC.CronExpression = D.CronExpression
			WHERE	SPC.Id IS NULL			

			--ScheduleProfileCatalogCron
			INSERT INTO [dbo].[ScheduleProfileCatalogCron] (CronExpression) 
			SELECT	DISTINCT D.CronExpression
			FROM	@DataScheduleProfilePlannedCatalog D
			LEFT JOIN
					[dbo].[ScheduleProfileCatalogCron] SPCC ON SPCC.CronExpression = D.CronExpression
			WHERE	SPCC.Id IS NULL

		 
			--ScheduleProfile
			CREATE TABLE #ScheduleProfile(
				[ScheduleProfileId] int  NOT NULL,
				[FromDate] datetime NOT NULL,
				[ToDate] datetime NOT NULL,
				[Description] varchar(200) NULL
			) 

			--ScheduleProfileCatalog
			CREATE TABLE #ScheduleProfileCatalog(
				[ScheduleProfileCatalogId] int  NOT NULL,
				[ScheduleProfileId] int  NOT NULL,
				[ScheduleProfileDescription] varchar(200) NULL,
				[DayOfWeek] varchar(200) NULL
			) 

			INSERT	INTO [dbo].[ScheduleProfile] ([FromDate],[ToDate],[Description],[AllPersonOfInterest],[AllPointOfInterest],[CreatedDate],[Deleted],[IdUser],[LimitOneMissingReport],[RecurrenceCondition],[RecurrenceNumber],[IdScheduleProfileCron])  
			OUTPUT	inserted.Id, inserted.[FromDate], inserted.[ToDate], inserted.[Description] INTO #ScheduleProfile
			SELECT	D.FromDate, D.ToDate, D.[Description], D.[AllPersonOfInterest], D.AllPointOfInterest, @Now, 0, @LoggedUserId, 0, D.RecurrenceCondition, D.RecurrenceNumber, SPC.Id
			FROM	@DataScheduleProfile D     
			INNER JOIN
					[dbo].[ScheduleProfileCron] SPC  WITH (NOLOCK) ON SPC.CronExpression = D.CronExpression
			

			DECLARE @i INT        
			DECLARE @count INT 
          
			SELECT @i = MIN([ScheduleProfileId]) FROM #ScheduleProfile         
			SELECT @count = MAX([ScheduleProfileId]) FROM #ScheduleProfile         
                     
			WHILE (@i <= @count)         
			BEGIN         
				SELECT	@IdScheduleProfile = @i, 
						@FromDate = SPD.[FromDate], 
						@ToDate = SPD.[ToDate], 
						@Description = SPD.[Description], 
						@AllPersonOfInterest = SPO.[AllPersonOfInterest], 
						@AllPointOfInterest = SPO.[AllPointOfInterest], 
						@DaysOfWeekScheduleProfile = ISNULL(SPO.[DaysOfWeek],DATEPART(weekday, SPD.[FromDate])), 
						@RecurrenceConditionScheduleProfile = SPO.[RecurrenceCondition], 
						@RecurrenceNumberScheduleProfile = SPO.[RecurrenceNumber],
						@CronExpressionScheduleProfile = SPO.[CronExpression],
						@IdScheduleProfilePermissions = SPO.[Actions],
						@IdProductReportSections = SPO.[SKUsections]
				FROM #ScheduleProfile SPD 
				INNER JOIN 
					@DataScheduleProfile SPO ON SPO.[Description] = SPD.[Description] AND SPO.FromDate = SPD.FromDate AND SPO.ToDate = SPD.ToDate
				WHERE [ScheduleProfileId] = @i        
								
				
				--ScheduleProfileDayOfWeek
				DECLARE @DayAuxScheduleProfile int
				IF LEN(@DaysOfWeekScheduleProfile) = 1  
					BEGIN  
						set @DayAuxScheduleProfile = CONVERT(int, SUBSTRING(@DaysOfWeekScheduleProfile, 1, 1))  
    
						INSERT INTO [dbo].[ScheduleProfileDayOfWeek]([IdScheduleProfile], [DayOfWeek]) VALUES (@IdScheduleProfile, @DayAuxScheduleProfile)  
					END    
				ELSE  
					BEGIN  
						DECLARE @posDW INT = 0  
						DECLARE @lenDW INT = 0  
        
						WHILE CHARINDEX(',', @DaysOfWeekScheduleProfile, @posDW) > 0  
						BEGIN  
							set @lenDW = CHARINDEX(',', @DaysOfWeekScheduleProfile, @posDW+1) - @posDW  
							set @DayAuxScheduleProfile = CONVERT(int, SUBSTRING(@DaysOfWeekScheduleProfile, @posDW, @lenDW))  
                  
							INSERT INTO [dbo].[ScheduleProfileDayOfWeek]([IdScheduleProfile], [DayOfWeek]) VALUES (@IdScheduleProfile, @DayAuxScheduleProfile)            
							set @posDW = CHARINDEX(',', @DaysOfWeekScheduleProfile, @posDW+@lenDW) +1    
						END    
        
						set @DayAuxScheduleProfile = CONVERT(int, SUBSTRING(@DaysOfWeekScheduleProfile, @posDW, 1))      
						INSERT INTO [dbo].[ScheduleProfileDayOfWeek]([IdScheduleProfile], [DayOfWeek]) VALUES (@IdScheduleProfile, @DayAuxScheduleProfile)          
					END    
				

				--ScheduleProfilePermission
				DECLARE @IdAuxScheduleProfilePermission int
				IF  CHARINDEX(',', @IdScheduleProfilePermissions) = 0  
					BEGIN  
						set @IdAuxScheduleProfilePermission = CONVERT(int, SUBSTRING(@IdScheduleProfilePermissions, 1, LEN(@IdScheduleProfilePermissions)))  
    
						INSERT INTO [dbo].[ScheduleProfilePermission]([IdScheduleProfile], [IdPersonOfInterestPermission], [LimitOnlyOnce]) VALUES (@IdScheduleProfile, @IdAuxScheduleProfilePermission, 0)  
					END    
				ELSE  
					BEGIN  
						DECLARE @posP INT = 0  
						DECLARE @lenP INT = 0  
        
						WHILE CHARINDEX(',', @IdScheduleProfilePermissions, @posP) > 0  
						BEGIN  
							set @lenP = CHARINDEX(',', @IdScheduleProfilePermissions, @posP+1) - @posP  
							set @IdAuxScheduleProfilePermission = CONVERT(int, SUBSTRING(@IdScheduleProfilePermissions, @posP, @lenP))  
                  
							INSERT INTO [dbo].[ScheduleProfilePermission]([IdScheduleProfile], [IdPersonOfInterestPermission], [LimitOnlyOnce]) VALUES (@IdScheduleProfile, @IdAuxScheduleProfilePermission, 0)  
							set @posP = CHARINDEX(',', @IdScheduleProfilePermissions, @posP+@lenP) + 1    
						END    
        
						set @IdAuxScheduleProfilePermission = CONVERT(int, SUBSTRING(@IdScheduleProfilePermissions, @posP, 1))      
						INSERT INTO [dbo].[ScheduleProfilePermission]([IdScheduleProfile], [IdPersonOfInterestPermission], [LimitOnlyOnce]) VALUES (@IdScheduleProfile, @IdAuxScheduleProfilePermission, 0)  
					END    


				--ScheduleProfileProductSection
				INSERT INTO [dbo].[ScheduleProfileProductSection] ([IdScheduleProfile], [IdProductReportSection])  
				SELECT  @IdScheduleProfile, S.[Id]  
				FROM	[dbo].[ProductReportSection] S  WITH (NOLOCK)
				WHERE	[dbo].[CheckValueInList](S.[Id], CONCAT(',',@IdProductReportSections,',')) > 0


				--ScheduleProfileGeneralAssignation
				INSERT INTO [dbo].[ScheduleProfileGeneralAssignation] ([IdScheduleProfile], [IdPersonOfInterestType])  
				SELECT  @IdScheduleProfile, PIT.[Code]  
				FROM	[dbo].[PersonOfInterestType] PIT WITH (NOLOCK)
				INNER JOIN
						@DataScheduleProfilePersonOfInterest D ON  D.[Filter] = 'Perfil' AND D.[Value] = PIT.[Description] AND D.[ScheduleProfileDescription] = @Description
    

				--ScheduleProfileAssignation		
				DECLARE @IdPersonsOfInterest varchar(max) 

				SELECT @IdPersonsOfInterest = CONCAT(',',
					STUFF
						(
							(
								SELECT ',' + IdPersonOfInterest
								FROM (
									SELECT DISTINCT IdPersonOfInterest
									FROM 
									(
										--Filtro por Persona de Interes
										SELECT	CAST(POI.Id AS VARCHAR(50)) IdPersonOfInterest
										FROM	@DataScheduleProfilePersonOfInterest D
										INNER JOIN
												dbo.PersonOfInterest POI WITH(NOLOCK) ON POI.Identifier = (SELECT TOP 1 RTRIM(value) FROM STRING_SPLIT(D.[Value], '|')) AND POI.Deleted = 0 AND D.[Filter] = 'Persona de Interes'
										WHERE	D.ScheduleProfileDescription = @Description
										UNION
										--Filtro por Perfil
										SELECT	CAST(POI.Id AS VARCHAR(50)) IdPersonOfInterest 
										FROM	@DataScheduleProfilePersonOfInterest D
										INNER JOIN
												dbo.PersonOfInterestType POIT WITH(NOLOCK) ON POIT.[Description] = D.[Value] AND D.[Filter] = 'Perfil'
										INNER JOIN
												dbo.PersonOfInterest POI WITH(NOLOCK) ON POI.[Type] = POIT.[Code] AND POI.Deleted = 0
										WHERE	D.ScheduleProfileDescription = @Description
										UNION
										--Filtro por Agrupacion
										SELECT	CAST(POI.Id AS VARCHAR(50)) IdPersonOfInterest
										FROM	@DataScheduleProfilePersonOfInterest D
										INNER JOIN
												dbo.[Zone] Z WITH(NOLOCK) ON Z.[Description] = D.[Value] AND D.[Filter] = 'Agrupacion'
										INNER JOIN
												dbo.PersonOfInterestZone POIZ WITH(NOLOCK) ON POIZ.IdZone = Z.Id 
										INNER JOIN
												dbo.PersonOfInterest POI WITH(NOLOCK) ON POI.Id = POIZ.IdPersonOfInterest AND POI.Deleted = 0
										WHERE	D.ScheduleProfileDescription = @Description
									) IT
								) OT
								FOR XML PATH('')
							), 1, 1, ''
						), 
				',') 


				DECLARE @IdPointsOfInterest varchar(max)

				SELECT @IdPointsOfInterest = CONCAT(',',
					STUFF
						(		
							(
								SELECT ',' + IdPointOfInterest
								FROM 
								(
									SELECT DISTINCT IdPointOfInterest
									FROM 
									(
										--Filtro por Punto de Interes
										SELECT	CAST( POI.Id AS VARCHAR(50)) IdPointOfInterest
										FROM	@DataScheduleProfilePointOfInterest D
										INNER JOIN
												dbo.PointOfInterest POI WITH(NOLOCK) ON POI.Identifier = (SELECT TOP 1 RTRIM(value) FROM STRING_SPLIT(D.[Value], '|')) AND POI.Deleted = 0 AND D.[Filter] = 'Punto de Interes'
										WHERE	D.ScheduleProfileDescription = @Description
										UNION
										--Filtro por HierarchyLevel1
										SELECT	CAST( POI.Id AS VARCHAR(50)) IdPointOfInterest
										FROM	@DataScheduleProfilePointOfInterest D
										INNER JOIN
												dbo.POIHierarchyLevel1 POIH1 WITH(NOLOCK) ON POIH1.[Name] = D.[Value] AND D.[Filter] = 'Jerarquia 1' AND POIH1.Deleted = 0
										INNER JOIN
												dbo.PointOfInterest POI WITH(NOLOCK) ON POI.[GrandfatherId] = POIH1.Id AND POI.Deleted = 0
										WHERE	D.ScheduleProfileDescription = @Description
										UNION
										--Filtro por HierarchyLevel2
										SELECT	CAST( POI.Id AS VARCHAR(50)) IdPointOfInterest
										FROM	@DataScheduleProfilePointOfInterest D
										INNER JOIN
												dbo.POIHierarchyLevel2 POIH2 WITH(NOLOCK) ON POIH2.[Name] = D.[Value] AND D.[Filter] = 'Jerarquia 2' AND POIH2.Deleted = 0
										INNER JOIN
												dbo.PointOfInterest POI WITH(NOLOCK) ON POI.[FatherId] = POIH2.Id AND POI.Deleted = 0
										WHERE	D.ScheduleProfileDescription = @Description
										UNION
										--Filtro por Agrupacion
										SELECT	CAST( POI.Id AS VARCHAR(50)) IdPointOfInterest
										FROM	@DataScheduleProfilePointOfInterest D
										INNER JOIN
												dbo.[Zone] Z WITH(NOLOCK) ON Z.[Description] = D.[Value] AND D.[Filter] = 'Agrupacion'
										INNER JOIN
												dbo.PointOfInterestZone POIZ WITH(NOLOCK) ON POIZ.IdZone = Z.Id 
										INNER JOIN
												dbo.PointOfInterest POI WITH(NOLOCK) ON POI.Id = POIZ.IdPointOfInterest AND POI.Deleted = 0
										WHERE	D.ScheduleProfileDescription = @Description
									) IT
								) OT
								FOR XML PATH('')
							), 1, 1, ''
						), 
				',')

				  IF @AllPointOfInterest = 0  
				  BEGIN  
					   INSERT INTO [dbo].[ScheduleProfileAssignation]([IdScheduleProfile], [IdPointOfInterest], [IdPersonOfInterest])  
						SELECT	@IdScheduleProfile AS IdScheduleProfile,	POI.[Id] AS [IdPointOfInterest],	P.[Id] AS [IdPersonOfInterest]  
						FROM (
								SELECT	PAux.[Id] 
								FROM	dbo.[PersonOfInterest] PAux WITH(NOLOCK) 
								WHERE	PAux.Deleted = 0 
								UNION	(SELECT NULL as [Id])) P,  
								-- Me fijo contra los Ids de Puntos agregando el NULL  
								(
									SELECT	POIAux.[Id] 
									FROM	dbo.PointOfInterest POIAux WITH(NOLOCK) 
									WHERE	POIAux.Deleted = 0 
									UNION	(SELECT NULL as [Id])
								) POI   
						WHERE  (P.[Id] IS NULL OR dbo.CheckValueInList(P.[Id], @IdPersonsOfInterest) = 1)  
								-- No viene lista ni esta en todos los POI, entonces no esta asignado a punto  
								AND (
										(
											(@AllPointOfInterest IS NULL OR @AllPointOfInterest = 0) 
											AND 
											@IdPointsOfInterest IS NULL AND POI.[Id] IS NULL
										)  
									-- O El POI no es null y viene datos en almenos Todos o Lista de pois  
									OR 
									(
										POI.[Id] IS NOT NULL   
										AND (@AllPointOfInterest = 1 OR @IdPointsOfInterest IS NOT NULL)   
										AND (@IdPointsOfInterest IS NULL OR dbo.CheckValueInList(POI.[Id], @IdPointsOfInterest) = 1)  
									)  
								)  
				  END  
				  ELSE  
				  BEGIN  
					   INSERT INTO [dbo].[ScheduleProfileAssignation]([IdScheduleProfile], [IdPointOfInterest], [IdPersonOfInterest])  
					   SELECT  @IdScheduleProfile AS IdScheduleProfile, NULL, P.[Id] AS [IdPersonOfInterest]  
					   FROM dbo.[PersonOfInterest] P  
					   WHERE   (dbo.CheckValueInList(P.[Id], @IdPersonsOfInterest) = 1)  
				  END  


				--ScheduleProfileCatalog
				INSERT INTO [dbo].[ScheduleProfileCatalog] ([IdScheduleProfile],[IdCatalog],[IdScheduleProfileCatalogCron],[Comment],[Deleted],[RecurrenceCondition],[RecurrenceNumber])
				OUTPUT inserted.Id, inserted.[IdScheduleProfile], @Description, @DaysOfWeekScheduleProfile INTO #ScheduleProfileCatalog
				SELECT	@IdScheduleProfile, C.Id, SPCC.Id, D.Comment, 0, D.RecurrenceCondition, D.RecurrenceNumber
				FROM	@DataScheduleProfilePlannedCatalog D     
				INNER JOIN
					[dbo].[ScheduleProfileCatalogCron] SPCC  WITH (NOLOCK) ON SPCC.CronExpression = D.CronExpression
				INNER JOIN
						dbo.[Catalog] C WITH (NOLOCK) ON C.[Name] = D.[CatalogProduct] AND C.[Deleted] = 0 
				WHERE D.[ScheduleProfileDescription] = @Description
				
				SELECT @i = @i + 1        
			END --END WHILE (@i <= @count)   
			
			
			-------------------------------
			----SCHEDULE PROFILE CATALOG---
			-------------------------------
			DECLARE @ScheduleProfileId int
			DECLARE @ScheduleProfileDescription varchar(200)
			DECLARE @ScheduleProfileCatalogId int
			DECLARE @DaysOfWeekScheduleProfileCatalog varchar(20)	

			DECLARE @iPC INT        
			DECLARE @countPC INT 
          
			SELECT @iPC = MIN([ScheduleProfileCatalogId]) FROM #ScheduleProfileCatalog         
			SELECT @countPC = MAX([ScheduleProfileCatalogId]) FROM #ScheduleProfileCatalog         
                     
			WHILE (@iPC <= @countPC)         
			BEGIN         
				SELECT	@ScheduleProfileId = SPD.[ScheduleProfileId],
						@ScheduleProfileCatalogId = SPD.[ScheduleProfileCatalogId], 
						@ScheduleProfileDescription = SPD.[ScheduleProfileDescription],
						@DaysOfWeekScheduleProfileCatalog = SPD.[DayOfWeek]
				FROM #ScheduleProfileCatalog SPD 
				WHERE [ScheduleProfileCatalogId] = @iPC        
								
				
				--ScheduleProfileCatalogDayOfWeek
				DECLARE @DayAuxScheduleProfileCatalog int
				IF LEN(@DaysOfWeekScheduleProfileCatalog) = 1  
					BEGIN  
						set @DayAuxScheduleProfileCatalog = CONVERT(int, SUBSTRING(@DaysOfWeekScheduleProfileCatalog, 1, 1))  
    
						INSERT INTO [dbo].[ScheduleProfileCatalogDayOfWeek]([IdScheduleProfileCatalog], [DayOfWeek]) VALUES (@ScheduleProfileCatalogId, @DaysOfWeekScheduleProfileCatalog)  
					END    
				ELSE  
					BEGIN  
						DECLARE @posPC INT = 0  
						DECLARE @lenPC INT = 0  
        
						WHILE CHARINDEX(',', @DaysOfWeekScheduleProfileCatalog, @posPC) > 0  
						BEGIN  
							set @lenPC = CHARINDEX(',', @DaysOfWeekScheduleProfileCatalog, @posPC+1) - @posPC  
							set @DayAuxScheduleProfileCatalog = CONVERT(int, SUBSTRING(@DaysOfWeekScheduleProfileCatalog, @posPC, @lenPC))  
                  
							INSERT INTO [dbo].[ScheduleProfileCatalogDayOfWeek]([IdScheduleProfileCatalog], [DayOfWeek]) VALUES (@ScheduleProfileCatalogId, @DayAuxScheduleProfileCatalog)            
							set @posPC = CHARINDEX(',', @DaysOfWeekScheduleProfileCatalog, @posPC+@lenPC) +1    
						END    
        
						set @DayAuxScheduleProfileCatalog = CONVERT(int, SUBSTRING(@DaysOfWeekScheduleProfileCatalog, @posPC, 1))      
						INSERT INTO [dbo].[ScheduleProfileCatalogDayOfWeek]([IdScheduleProfileCatalog], [DayOfWeek]) VALUES (@ScheduleProfileCatalogId, @DayAuxScheduleProfileCatalog)          
					END    
					
				
				SELECT @iPC = @iPC + 1        
			END --END WHILE (@iPC <= @count)   

		END --END IF @Add <= @SyncType              
		
		--Validaciones POST INSERT              
		--Report Days Of Week Invalid in Schedule Profile 
		
		--Report Actions Invalid in ScheduleProfile

		--Report SKUsections Invalid in ScheduleProfile
					
		--Report Invalid in ScheduleProfileCatalog
		
		--Report Days Of Week Invalid in ScheduleProfileCatalog
		
		--Report PersonOfInterest assignation

		--Report PointOfInterest assignation
								
		DROP TABLE #ScheduleProfile
		DROP TABLE #ScheduleProfileCatalog

	COMMIT TRANSACTION;	
 END TRY
 BEGIN CATCH
	-- Test if the transaction is uncommittable.  
	IF (XACT_STATE()) = -1  
	BEGIN  
		PRINT  N'The transaction is in an uncommittable state.' +  
				'Rolling back transaction.'  
		ROLLBACK TRANSACTION;  
	END;  
        
	-- Test if the transaction is committable.  
	IF (XACT_STATE()) = 1  
	BEGIN  
		PRINT N'The transaction is committable.' +  
			'Committing transaction.'  
		COMMIT TRANSACTION;     
	END;  
 END CATCH  

 SET ANSI_WARNINGS  ON;              
END
