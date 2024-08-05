/****** Object:  Procedure [dbo].[SyncPersonsOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================    
-- Author:  GL    
-- Create date: 24/09/2018    
-- Description: SP para sincronizar lAS PERSONAS DE INTERES    
-- Modified by:  JM    
-- Modified date: 12/03/2024    
-- Description: Se agregan los campos para chile y lo de Turno de Trabajo
-- =============================================    
CREATE PROCEDURE [dbo].[SyncPersonsOfInterest]    
(    
  @SyncType [int]    
 ,@Data [PersonOfInterestTableType] READONLY    
 ,@DataFiscalizationInfo [PersonOfInterestFiscalizationInfoTableType] READONLY   
 ,@DataHour [PersonOfInterestScheduleTableType] READONLY    
 ,@DataWorkShift [PersonOfInterestWorkShiftTableType] READONLY    
 ,@DataAttributeValues [PersonCustomAttributeValueTableType] READONLY    
)    
AS    
BEGIN    
SET ANSI_WARNINGS  OFF;    
 DECLARE @Add [int] = 0    
 DECLARE @AddUpdate [int] = 1    
 DECLARE @AddUpdateDelete [int] = 2    

 DECLARE @Now [sys].[datetime]    
 SET @Now = GETUTCDATE()

  --Tablas temporales para Chile
  CREATE TABLE #DataFiscalizationInfo
  (              
   [IdPersonOfInterest] [int] NULL,  
   [PersonOfInterestIdentifier] [varchar](50) NOT NULL,   
   [IsOutsourced] [bit] NOT NULL,
   [IdPlaceOfWork] [int] NULL,  
   [PlaceOfWorkIdentifier] [varchar](50) NULL, 
   [HasSplittedWorkHours] [bit] NOT NULL,
   [SplittedWorkHoursResolutionNumber] [varchar](50) NULL,   
   [WorkOnSundays] [bit] NOT NULL  
  )    
  
  INSERT INTO #DataFiscalizationInfo
  SELECT POI.Id, D.Id, D.IsOutsourced, PW.Id, PW.Identifier, D.HasSplittedWorkHours, D.SplittedWorkHoursResolutionNumber, D.WorkOnSundays
  FROM  @DataFiscalizationInfo D
  LEFT JOIN [dbo].[PersonOfInterest]	POI WITH(NOLOCK) ON POI.[Identifier] = D.[Id] AND POI.[Deleted] = 0
  LEFT JOIN [dbo].[PlaceOfWork]			PW WITH(NOLOCK) ON PW.[Identifier] = D.[PlaceOfWorkIdentifier] AND PW.[Deleted] = 0
  
  CREATE TABLE #DataWorkShift
  (              
   [IdPersonOfInterest] [int] NULL,  
   [PersonOfInterestIdentifier] [varchar](50) NOT NULL,   
   [IdDayOfWeek] [smallint] NOT NULL,  
   [IdWorkShift] [int] NOT NULL, 
   [WorkShift] [varchar](100) NOT NULL, 
   [WorkShiftStartTime] [time] NOT NULL,
   [WorkShiftEndTime] [time] NOT NULL,
   [IdRestShift] [int] NULL,
   [RestShift] [varchar](100) NULL,
   [RestShiftStartTime] [time] NULL,
   [RestShiftEndTime] [time] NULL
  )    

  INSERT INTO #DataWorkShift
  SELECT POI.Id, D.Id, D.IdDayOfWeek, WS.Id, D.WorkShift, WS.StartTime, WS.EndTime, RS.Id, D.RestShift, RS.StartTime, RS.EndTime
  FROM  @DataWorkShift D
  LEFT JOIN [dbo].[PersonOfInterest]	POI WITH(NOLOCK) ON POI.[Identifier] = D.[Id] AND POI.[Deleted] = 0
  INNER JOIN [dbo].[WorkShift]	WS WITH(NOLOCK) ON WS.[Name] = D.[WorkShift] AND WS.[Deleted] = 0
  LEFT JOIN  [dbo].[WorkShift]	RS WITH(NOLOCK) ON RS.[Name] = D.[RestShift] AND RS.[Deleted] = 0
  --Tablas temporales para Chile

 -- Update ingresados    
 IF @AddUpdate <= @SyncType    
 BEGIN    
  UPDATE PR    
  SET  PR.[Identifier] = P.[Id],    
    PR.[Name] = P.[Name],    
    PR.[LastName] = P.[LastName],    
    PR.[MobilePhoneNumber] = P.[MobilePhoneNumber],    
    PR.[MobileIMEI] = P.[MobileIMEI],    
    PR.[Email] = P.[Email],    
    PR.[Type] = P.[ProfileCode],    
    PR.[IdDepartment] = P.[ProvinceId]     
           
  FROM [dbo].[PersonOfInterest] PR WITH(NOLOCK)    
    INNER JOIN @Data as P ON (PR.[Identifier] = P.[Id] OR PR.[MobileIMEI] = P.[MobileIMEI] OR PR.[MobilePhoneNumber] = P.[MobilePhoneNumber])    
    INNER JOIN [dbo].[PersonOfInterestType] PT WITH(NOLOCK) ON PT.[Code] = P.[ProfileCode]    
    LEFT OUTER JOIN [dbo].[Department] D WITH(NOLOCK) ON d.[Id] = P.[ProvinceId]    
      
  WHERE PR.[Deleted] = 0    
    AND (P.[ProvinceId] IS NULL OR D.[Id] IS NOT NULL)    

  --Actualizo la info de fiscalizacion en caso que aplique (Chile)
  UPDATE PFI    
  SET	PFI.IsOutsourced = D.IsOutsourced,
		PFI.IdPlaceOfWork = D.IdPlaceOfWork,
		PFI.HasSplittedWorkHours = D.HasSplittedWorkHours,
		PFI.SplittedWorkHoursResolutionNumber = D.SplittedWorkHoursResolutionNumber,
		PFI.WorkOnSundays = D.WorkOnSundays           
  FROM [dbo].[PersonOfInterestFiscalizationInfo] PFI WITH(NOLOCK)  
	INNER JOIN #DataFiscalizationInfo D ON D.IdPersonOfInterest = PFI.IdPersonOfInterest
 END    
     

 -- Delete faltantes    
 IF @AddUpdateDelete <= @SyncType    
 BEGIN     
  UPDATE PR    
  SET  PR.[Deleted] = 1    
  FROM [dbo].[PersonOfInterest] PR    
    LEFT OUTER JOIN @Data as P ON (PR.[Identifier] = P.[Id] OR PR.[MobileIMEI] = P.[MobileIMEI] OR PR.[MobilePhoneNumber] = P.[MobilePhoneNumber])    
  WHERE PR.[Deleted] = 0 AND P.[Id] IS NULL    
   
  --Cuando se borra LA PERSONA tengo que eliminar las rutas para ese punt de ahora en mas.    
  --Elimino las rutas que tiene asignada la persona desde la fecha en adelante    
  UPDATE [dbo].[RouteGroup]    
  SET  [Deleted] = 1, [EditedDate] = GETUTCDATE()    
  WHERE [EndDate] > GETUTCDATE() AND [IdPersonOfInterest] IN     
         (SELECT PR.[Id]     
          FROM [dbo].[PersonOfInterest] PR WITH(NOLOCK)    
          LEFT OUTER JOIN @Data as P ON (PR.[Identifier] = P.[Id] OR PR.[MobileIMEI] = P.[MobileIMEI] OR PR.[MobilePhoneNumber] = P.[MobilePhoneNumber])    
          WHERE PR.[Deleted] = 1 AND P.[Id] IS NULL)    
    
  --Elimino todas las rutas que haya en RouteDetail y RoutePointOfInterest posteriores a la fecha actual.    
  UPDATE dbo.[RoutePointOfInterest]    
  SET  [Deleted] = 1, [EditedDate] = GETUTCDATE()    
  WHERE [IdRouteGroup] IN     
  (SELECT [Id] FROM [dbo].[RouteGroup] WITH(NOLOCK) WHERE [EndDate] > GETUTCDATE() AND [IdPersonOfInterest] IN     
         (SELECT PR.[Id]     
          FROM [dbo].[PersonOfInterest] PR WITH(NOLOCK)    
          LEFT OUTER JOIN @Data as P ON (PR.[Identifier] = P.[Id] OR PR.[MobileIMEI] = P.[MobileIMEI] OR PR.[MobilePhoneNumber] = P.[MobilePhoneNumber])    
          WHERE PR.[Deleted] = 1 AND P.[Id] IS NULL))     
    
  DELETE FROM [dbo].[RouteDetail]    
  WHERE  Tzdb.IsGreaterOrSameSystemDate([RouteDate], @Now) = 1    
     AND [IdRoutePointOfInterest] IN    
     (SELECT [Id] FROM [dbo].[RoutePointOfInterest] WITH(NOLOCK) WHERE     
     [IdRouteGroup] IN (SELECT [Id] FROM [dbo].[RouteGroup] WITH(NOLOCK) WHERE [EndDate] > GETUTCDATE() AND [IdPersonOfInterest] IN     
         (SELECT PR.[Id]     
          FROM [dbo].[PersonOfInterest] PR WITH(NOLOCK)    
          LEFT OUTER JOIN @Data as P ON (PR.[Identifier] = P.[Id] OR PR.[MobileIMEI] = P.[MobileIMEI] OR PR.[MobilePhoneNumber] = P.[MobilePhoneNumber])    
          WHERE PR.[Deleted] = 1 AND P.[Id] IS NULL)))             
 END    
     

 -- Obtengo los que no tiene referencia    
 -- Si solo agrego Obtengo los repetidos antes de agregar los nuevos    
 -- de lo contrario siempre van a existir     
 SELECT P.[Id], P.[Name], P.[LastName], P.[MobilePhoneNumber], P.[MobileIMEI], P.[Email]    
   ,P.[ProfileCode], P.[ProvinceId]    
   ,IIF(P.[ProfileCode] IS NOT NULL AND PT.[Code] IS NULL, 1, 0) AS ProfileCodeError -- 0 indicador repetido, 1 Codigo de perfil no existe    
   ,IIF(P.[ProvinceId] IS NOT NULL AND D.[Id] IS NULL, 1, 0) AS ProvinceIdError -- 0 indicador repetido, 1 Departamento no existe    
     
 FROM @Data P    
   LEFT OUTER JOIN [PersonOfInterest] as PR ON     
   (PR.[Identifier] = P.[Id] OR PR.[MobileIMEI] = P.[MobileIMEI] OR PR.[MobilePhoneNumber] = P.[MobilePhoneNumber]) --NINGUNO DE LOS 3 SE PUEDE REPETIR    
   AND PR.[Deleted] = 0    
   LEFT OUTER JOIN [dbo].[Department] D ON d.[Id] = P.[ProvinceId]    
   LEFT OUTER JOIN [dbo].[PersonOfInterestType] PT ON PT.[Code] = P.[ProfileCode]    
     
 WHERE (@Add = @SyncType AND PR.[Id] IS NOT NULL)    
   OR (P.[ProfileCode] IS NOT NULL AND PT.[Code] IS NULL)    
   OR (P.[ProvinceId] IS NOT NULL AND D.[Id] IS NULL)    
    
	
 -- Insert nuevos     
 IF @Add <= @SyncType    
 BEGIN     
  INSERT INTO [dbo].[PersonOfInterest]([Name], [LastName], [Identifier],     
        [MobilePhoneNumber], [MobileIMEI], [Email], [Status], [Type], [IdDepartment],     
        [Deleted], [Pending], [Pin], [PinDate], [Avatar])    
    
  SELECT P.[Name], P.[LastName], P.[Id], P.[MobilePhoneNumber], P.[MobileIMEI], P.[Email], 'H', P.[ProfileCode],    
    P.[ProvinceId], 0, 0, NULL, NULL, NULL    

  FROM    @Data P    
    LEFT OUTER JOIN [PersonOfInterest] as PR ON     
    (PR.[Identifier] = P.[Id] OR PR.[MobileIMEI] = P.[MobileIMEI] OR PR.[MobilePhoneNumber] = P.[MobilePhoneNumber]) --NINGUNO DE LOS 3 SE PUEDE REPETIR    
    AND PR.[Deleted] = 0    
        
    LEFT OUTER JOIN [dbo].[Department] D ON D.[Id] = P.[ProvinceId]    
    INNER JOIN [dbo].[PersonOfInterestType] PT ON PT.[Code] = P.[ProfileCode]    
  WHERE   PR.[Id] IS NULL AND    
    (P.[ProvinceId] IS NULL OR D.[Id] IS NOT NULL)     
	
	--Inserto la info de fiscalizacion en caso que aplique (Chile)
	INSERT INTO [dbo].[PersonOfInterestFiscalizationInfo]
           ([IdPersonOfInterest]
           ,[IsOutsourced]
           ,[IdPlaceOfWork]
           ,[WorkOnSundays]
           ,[HasSplittedWorkHours]
           ,[SplittedWorkHoursResolutionNumber]
           ,[CreatedDate])    
	SELECT	POI.Id, D.IsOutsourced, D.IdPlaceOfWork, D.WorkOnSundays, D.HasSplittedWorkHours, D.SplittedWorkHoursResolutionNumber, @Now
	FROM	#DataFiscalizationInfo	D    
	INNER JOIN
			dbo.PersonOfInterest POI WITH(NOLOCK) ON POI.Identifier = D.PersonOfInterestIdentifier AND POI.Deleted = 0
    LEFT OUTER JOIN 
			dbo.PersonOfInterestFiscalizationInfo PFI WITH(NOLOCK) ON PFI.IdPersonOfInterest = POI.Id
	WHERE PFI.IdPersonOfInterest IS NULL AND D.IdPersonOfInterest IS NULL
	
    
  DECLARE @IdZoneAllPerson [INT]    
  SET @IdZoneAllPerson = (SELECT Z.[Id] FROM [dbo].[ZoneTranslated] Z WITH (NOLOCK) WHERE Z.[ApplyToAllPersonOfInterest] = 1)    
    
  DELETE FROM [dbo].[PersonCustomAttributeValue] WHERE [IdPersonOfInterest] IN (SELECT DISTINCT [Id] FROM PersonOfInterest peoi INNER JOIN @DataAttributeValues pcav on peoi.[Identifier] = pcav.[PersonOfInterestIdentifier])  
  INSERT INTO [dbo].[PersonCustomAttributeValue] ([IdPersonCustomAttribute], [Value], [IdPersonOfInterest])  
  SELECT pcav.[IdPersonCustomAttribute], pcav.[Value], pr.[Id]  
  FROM @DataAttributeValues pcav    
  INNER JOIN [dbo].[PersonOfInterest] pr ON pcav.[PersonOfInterestIdentifier] = pr.[Identifier]  
  
  IF @IdZoneAllPerson IS NOT NULL    
  BEGIN    
   INSERT INTO dbo.PersonOfInterestZone    
   SELECT P.[Id], @IdZoneAllPerson    
   FROM [dbo].[PersonOfInterest] P     
   WHERE P.[Deleted] = 0 AND P.[Id] NOT IN (SELECT PZ.[IdPersonOfInterest] FROM [dbo].[PersonOfInterestZone] PZ     
             WHERE PZ.[IdPersonOfInterest] = P.[Id] AND PZ.[IdZone] = @IdZoneAllPerson)    
  END    
 END    
    
 -----------------------------------------------------------------------------------
 -- Actualizo ventana horaria  o los turnos de trabajo en caso que aplique  (Chile)
 -----------------------------------------------------------------------------------
 IF @AddUpdate <= @SyncType    
 BEGIN     
	UPDATE  PH    
	SET  PH.[FromHour] = P.[FromHour],    
		PH.[ToHour] = P.[ToHour],    
		PH.[RestHours] = P.[RestHour],    
		PH.[WorkHours] = P.[WorkHours]    
	FROM [PersonOfInterestSchedule] PH    
    INNER JOIN [PersonOfInterest] PR ON PR.[Id] =  PH.[IdPersonOfInterest] AND PR.[Deleted] = 0    
    INNER JOIN @DataHour P ON P.[Id] = PR.[Identifier] AND P.[Day] = PH.[IdDayOfWeek]    

	--Actualizo Turnos de Trabajo para Chile
	CREATE TABLE #UpdatedData    
    (    
		 [IdPersonOfInterest] [sys].[int]    
        ,[IdDayOfWeek] [sys].[smallint]    
        ,[IdCurrentWorkShift] [sys].[int]    
		,[CurrentAssignedDate] [sys].[datetime]    
        ,[IdNewWorkShift] [sys].[int]    
        ,[NewAssignedDate] [sys].[datetime]    
    )

	UPDATE	PWS
	SET		PWS.[IdWorkShift] = D.[IdWorkShift], 
			PWS.[IdRestShift] = D.[IdRestShift], 
			PWS.[AssignedDate] = @Now, 
			PWS.[Deleted] = 0,
			PWS.[DeletedDate] = NULL
	OUTPUT  INSERTED.[IdPersonOfInterest],INSERTED.[IdDayOfWeek], DELETED.[IdWorkShift], DELETED.[AssignedDate], INSERTED.[IdWorkShift], INSERTED.[AssignedDate]    
    INTO    #UpdatedData ([IdPersonOfInterest],[IdDayOfWeek], [IdCurrentWorkShift], [CurrentAssignedDate], [IdNewWorkShift], [NewAssignedDate])    
	FROM dbo.[PersonOfInterestWorkShift] PWS
	INNER JOIN 
			#DataWorkShift D ON  PWS.IdPersonOfInterest = D.IdPersonOfInterest AND PWS.IdDayOfWeek = D.IdDayOfWeek
																				AND ((PWS.[IdWorkShift] <> D.[IdWorkShift] OR ISNULL(PWS.[IdRestShift], 0) <> ISNULL(D.[IdRestShift], 0)) OR PWS.Deleted = 1);

	INSERT INTO [dbo].[PersonOfInterestWorkShiftModification]([Date], [IdPersonOfInterest], [IdDayOfWeek],    
		[IdCurrentWorkShift], [CurrentWorkShiftStartTime], [CurrentWorkShiftEndTime], [CurrentWorkShiftAssignedDate],    
        [IdWorkShiftRecurrenceType], [IdNewWorkShift], [NewWorkShiftStartTime], [NewWorkShiftEndTime], [NewWorkShiftAssignedDate],    
        [IdWorkShiftRequestor])    
    SELECT  @Now, DD.IdPersonOfInterest, DD.[IdDayOfWeek],    
			DD.[IdCurrentWorkShift], CWS.[StartTime], CWS.[EndTime], DD.[CurrentAssignedDate], 1,    
            ND.[IdNewWorkShift], NWS.[StartTime], NWS.[EndTime], ND.[CurrentAssignedDate], 1    
    FROM    #UpdatedData DD    
            INNER JOIN [dbo].[WorkShift] CWS ON CWS.[Id] = DD.[IdCurrentWorkShift]    
            INNER JOIN #UpdatedData ND ON ND.[IdDayOfWeek] = DD.[IdDayOfWeek] AND ND.[IdNewWorkShift] IS NOT NULL    
            INNER JOIN [dbo].[WorkShift] NWS ON NWS.[Id] = ND.[IdNewWorkShift]    
    WHERE   DD.[IdCurrentWorkShift] IS NOT NULL;    
    
    DROP TABLE #UpdatedData;    

	--Elimino Turnos de Trabajo para Chile que no esten en la hoja de Turnos si es que estoy actualizando turnos y si la configuracion de Chile esta prendida
    IF EXISTS (SELECT TOP (1) 1 FROM [dbo].[Configuration] C WITH (NOLOCK) WHERE [Id] = 4089 AND [Value] = '1') -- Chilean Regulation Compliance  
    BEGIN 
		DELETE PH    
		FROM [PersonOfInterestSchedule] PH    
		INNER JOIN 
				[PersonOfInterest] PR ON PR.[Id] =  PH.[IdPersonOfInterest] AND PR.[Deleted] = 0    
		INNER JOIN 
				@Data O ON O.Id = PR.Identifier
		LEFT OUTER JOIN @DataHour P ON P.[Id] = PR.[Identifier] AND P.[Day] = PH.[IdDayOfWeek]    
		WHERE P.[Id] IS NULL    

        CREATE TABLE #DeletedDataUpdate    
		(    
			 [IdPersonOfInterest] [sys].[int]    
			,[IdDayOfWeek] [sys].[smallint]    
			,[IdWorkShift] [sys].[int]    
			,[AssignedDate] [sys].[datetime]    
		) 

        UPDATE	PWS
		SET		PWS.[Deleted] = 1, 
				PWS.[DeletedDate] = @Now
		OUTPUT  DELETED.[IdPersonOfInterest],DELETED.[IdDayOfWeek], DELETED.[IdWorkShift], DELETED.[AssignedDate]    
		INTO    #DeletedDataUpdate (IdPersonOfInterest, IdDayOfWeek, IdWorkShift, AssignedDate)  
		FROM dbo.[PersonOfInterestWorkShift] PWS
		INNER JOIN 
				[PersonOfInterest] PR ON PR.[Id] =  PWS.[IdPersonOfInterest] AND PR.[Deleted] = 0    
		INNER JOIN 
				@Data O ON O.Id = PR.Identifier
		LEFT OUTER JOIN 
				#DataWorkShift D ON  PWS.IdPersonOfInterest = D.IdPersonOfInterest AND PWS.IdDayOfWeek = D.IdDayOfWeek AND PWS.IdWorkShift = D.IdWorkShift AND PWS.Deleted = 0
		WHERE	D.IdPersonOfInterest IS NULL AND D.IdWorkShift IS NULL AND D.IdDayOfWeek IS NULL

		INSERT INTO [dbo].[PersonOfInterestWorkShiftModification]([Date], [IdPersonOfInterest], [IdDayOfWeek],    
			[IdCurrentWorkShift], [CurrentWorkShiftStartTime], [CurrentWorkShiftEndTime], [CurrentWorkShiftAssignedDate],    
			[IdWorkShiftRecurrenceType], [IdNewWorkShift], [NewWorkShiftStartTime], [NewWorkShiftEndTime], [NewWorkShiftAssignedDate],    
			[IdWorkShiftRequestor])    
		SELECT  @Now, DD.IdPersonOfInterest, DD.[IdDayOfWeek],    
				DD.[IdWorkShift], WS.[StartTime], WS.[EndTime], DD.[AssignedDate], 1,    
				NULL, NULL, NULL, NULL, 1    
		FROM    #DeletedDataUpdate DD    
				INNER JOIN 
				[dbo].[WorkShift] WS ON WS.[Id] = DD.[IdWorkShift];    
    
		DROP TABLE #DeletedDataUpdate; 
    END  
 END    
    
	
 -----------------------------------------------------------------------------------------------------------------------
 -- Elimino los que no existen en el template para las ventanas horarias que no son de (Chile)    
 -----------------------------------------------------------------------------------------------------------------------
 IF @AddUpdateDelete <= @SyncType AND NOT EXISTS (SELECT TOP (1) 1 FROM [dbo].[Configuration] C WITH (NOLOCK) WHERE [Id] = 4089 AND [Value] = '1') -- NO Chilean Regulation Compliance  
 BEGIN 
	DELETE PH    
	FROM [PersonOfInterestSchedule] PH    
	INNER JOIN [PersonOfInterest] PR ON PR.[Id] =  PH.[IdPersonOfInterest] AND PR.[Deleted] = 0    
	LEFT OUTER JOIN @DataHour P ON P.[Id] = PR.[Identifier] AND P.[Day] = PH.[IdDayOfWeek]    
	WHERE P.[Id] IS NULL    

	--NO es necesario esto porque ya se lo hace en el UPDATE
    /*CREATE TABLE #DeletedData    
	(    
		[IdPersonOfInterest] [sys].[int]    
		,[IdDayOfWeek] [sys].[smallint]    
		,[IdWorkShift] [sys].[int]    
		,[AssignedDate] [sys].[datetime]    
	) 

	--Eliminado logico del turno de trabajo
    UPDATE	PWS
	SET		PWS.[Deleted] = 1, 
			PWS.[DeletedDate] = @Now
	OUTPUT  DELETED.[IdPersonOfInterest],DELETED.[IdDayOfWeek], DELETED.[IdWorkShift], DELETED.[AssignedDate]    
	INTO    #DeletedData (IdPersonOfInterest, IdDayOfWeek, IdWorkShift, AssignedDate)    
	FROM dbo.[PersonOfInterestWorkShift] PWS
	LEFT OUTER JOIN 
			#DataWorkShift D ON  PWS.IdPersonOfInterest = D.IdPersonOfInterest AND PWS.IdDayOfWeek = D.IdDayOfWeek AND PWS.IdWorkShift = D.IdWorkShift AND PWS.Deleted = 0
	WHERE	D.IdPersonOfInterest IS NULL AND D.IdWorkShift IS NULL AND D.IdDayOfWeek IS NULL

	INSERT INTO [dbo].[PersonOfInterestWorkShiftModification]([Date], [IdPersonOfInterest], [IdDayOfWeek],    
		[IdCurrentWorkShift], [CurrentWorkShiftStartTime], [CurrentWorkShiftEndTime], [CurrentWorkShiftAssignedDate],    
		[IdWorkShiftRecurrenceType], [IdNewWorkShift], [NewWorkShiftStartTime], [NewWorkShiftEndTime], [NewWorkShiftAssignedDate],    
		[IdWorkShiftRequestor])    
	SELECT  @Now, DD.IdPersonOfInterest, DD.[IdDayOfWeek],    
			DD.[IdWorkShift], WS.[StartTime], WS.[EndTime], DD.[AssignedDate], 1,    
			NULL, NULL, NULL, NULL, 1    
	FROM    #DeletedData DD    
			INNER JOIN [dbo].[WorkShift] WS ON WS.[Id] = DD.[IdWorkShift];    
    
	DROP TABLE #DeletedData; */
 END     
 
 -------------------------------------------------------------------------------------
 -- Inserto nuevas ventanas horarias  o Turnos de trabajo en caso que aplique (Chile)
 -------------------------------------------------------------------------------------
 IF @Add <= @SyncType    
 BEGIN     
	INSERT INTO [dbo].[PersonOfInterestSchedule]([IdPersonOfInterest], [IdDayOfWeek],     
    [WorkHours], [RestHours], [FromHour], [ToHour])    
    SELECT PR.[Id], P.[Day], P.[WorkHours], P.[RestHour],  P.[FromHour], P.[ToHour]    
    FROM @DataHour P     
    INNER JOIN [PersonOfInterest] PR ON P.[Id] = PR.[Identifier] AND PR.[Deleted] = 0    
    LEFT OUTER JOIN [PersonOfInterestSchedule] PH ON PR.[Id] =  PH.[IdPersonOfInterest] AND P.[Day] = PH.[IdDayOfWeek]    
    WHERE PH.[IdPersonOfInterest] IS NULL    
	
	--Agrego Turnos de Trabajo para Chile
	CREATE TABLE #InsertedData    
    (    
		 [IdPersonOfInterest] [sys].[int]    
        ,[IdDayOfWeek] [sys].[smallint]    
        ,[IdWorkShift] [sys].[int]    
        ,[AssignedDate] [sys].[datetime]    
    )  

	INSERT INTO [dbo].[PersonOfInterestWorkShift]([IdPersonOfInterest], [IdDayOfWeek], [IdWorkShift], [IdRestShift], [AssignedDate], [Deleted])    
	OUTPUT INSERTED.[IdPersonOfInterest],INSERTED.[IdDayOfWeek], INSERTED.[IdWorkShift], INSERTED.[AssignedDate]    
    INTO #InsertedData ([IdPersonOfInterest],[IdDayOfWeek], [IdWorkShift], [AssignedDate])    
	SELECT POI.Id, D.[IdDayOfWeek], D.[IdWorkShift], D.[IdRestShift], @Now, 0    
	FROM #DataWorkShift D
	INNER JOIN
			dbo.PersonOfInterest POI WITH(NOLOCK) ON POI.Identifier = D.PersonOfInterestIdentifier AND POI.Deleted = 0
	LEFT OUTER JOIN 
			dbo.PersonOfInterestWorkShift PWS WITH(NOLOCK) ON PWS.IdPersonOfInterest = D.IdPersonOfInterest AND PWS.IdDayOfWeek = D.IdDayOfWeek
	WHERE PWS.IdPersonOfInterest IS NULL AND PWS.IdDayOfWeek IS NULL

    INSERT INTO [dbo].[PersonOfInterestWorkShiftModification]([Date], [IdPersonOfInterest], [IdDayOfWeek],    
		[IdCurrentWorkShift], [CurrentWorkShiftStartTime], [CurrentWorkShiftEndTime], [CurrentWorkShiftAssignedDate],    
        [IdWorkShiftRecurrenceType], [IdNewWorkShift], [NewWorkShiftStartTime], [NewWorkShiftEndTime], [NewWorkShiftAssignedDate],    
        [IdWorkShiftRequestor])    
    SELECT  @Now, ID.IdPersonOfInterest, ID.[IdDayOfWeek], NULL, NULL, NULL, NULL, 1,    
            ID.[IdWorkShift], WS.[StartTime], WS.[EndTime], ID.[AssignedDate], 1    
    FROM    #InsertedData ID    
            INNER JOIN [dbo].[WorkShift] WS ON WS.[Id] = ID.[IdWorkShift];    
    
    DROP TABLE #InsertedData;   
 END    

 DROP TABLE #DataFiscalizationInfo                
 DROP TABLE #DataWorkShift                

 SET ANSI_WARNINGS  ON;
END
