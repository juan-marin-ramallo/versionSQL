/****** Object:  Procedure [dbo].[GetDetailedMarksReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================          
-- Author:  Jesús Portillo          
-- Create date: 27/02/2013          
-- Description: SP para obtener un reporte de marcas realizadas      
-- Modified by: Juan Marin    
-- Modified date: 15/03/2024    
-- Description: Se agrega los turnos de trabajo y colacion para Chile    
-- =============================================          
CREATE PROCEDURE [dbo].[GetDetailedMarksReport]          
          
  @DateFrom [sys].[datetime]          
 ,@DateTo [sys].[datetime]          
 ,@IdDepartments [sys].[varchar](1000) = NULL          
 ,@Types [sys].[varchar](1000) = NULL          
 ,@IdPersonsOfInterest [sys].[varchar](max) = NULL          
 ,@IdUser [sys].[int] = NULL          
 ,@IncludeNonMarks [sys].[bit] = NULL          
AS          
BEGIN          
          
 declare @DateFromAux [sys].[datetime] = @DateFrom          
 IF @IncludeNonMarks = 1          
 BEGIN          
          
  CREATE TABLE #AllPersonOfInterestDates          
  (          
   GroupedDate [sys].[DATETIME], IdPersonOfInterest [sys].[int], PersonOfInterestName [sys].[varchar](50)          
   , PersonOfInterestLastName [sys].[varchar](50), PersonOfInterestIdentifier [sys].[varchar](50),          
   PersonOfInterestMobilePhoneNumber [sys].[varchar](20), PersonOfInterestMobileIMEI [sys].[varchar](40)          
  )          
          
  WHILE (@DateFromAux <= @DateTo)           
  BEGIN          
          
   INSERT INTO #AllPersonOfInterestDates(GroupedDate, IdPersonOfInterest, PersonOfInterestName, PersonOfInterestLastName,          
     PersonOfInterestIdentifier, PersonOfInterestMobilePhoneNumber, PersonOfInterestMobileIMEI)          
   SELECT DISTINCT @DateFromAux, P.[Id], P.[Name], P.[LastName], P.[Identifier],          
     P.[MobilePhoneNumber], P.[MobileIMEI]          
   FROM [dbo].[PersonOfInterest] P WITH (NOLOCK)          
     JOIN PersonOfInterestSchedule S WITH (NOLOCK) ON S.IdPersonOfInterest = P.Id          
   WHERE P.[Deleted] = 0          
     AND S.IdDayOfWeek = DATEPART(WEEKDAY, Tzdb.FromUtc(@DateFromAux))          
     AND ((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPersonsOfInterest) = 1))          
     AND P.[Id] NOT IN (SELECT PA.[IdPersonOfInterest]          
         FROM    [dbo].[PersonOfInterestAbsence] PA WITH (NOLOCK)          
         WHERE   @DateFromAux >= PA.[FromDate] AND (PA.[ToDate] IS NULL OR @DateFromAux < PA.[ToDate]))          
          
   SET @DateFromAux = DATEADD(day, 1, @DateFromAux)          
  END          
          
  SELECT D.[IdPersonOfInterest], D.GroupedDate AS Date, VDMR.[Id], D.PersonOfInterestName,           
    D.PersonOfInterestLastName, D.PersonOfInterestIdentifier, D.PersonOfInterestMobilePhoneNumber,           
    D.PersonOfInterestMobileIMEI,          
  VDMR.EntryTime, VDMR.[EntryLatitude], VDMR.[EntryLongitude], VDMR.[EditedEntryTime],         
 VDMR.[RestEntryTime], VDMR.[RestEntryLatitude], VDMR.[RestEntryLongitude], VDMR.[EditedRestEntryTime],        
 VDMR.[RestExitTime], VDMR.[RestExitLatitude], VDMR.[RestExitLongitude], VDMR.[EditedRestExitTime],        
 VDMR.[ExitTime], VDMR.[ExitLatitude], VDMR.[ExitLongitude], VDMR.[EditedExitTime],        
 VDMR.WorkedHours, VDMR.RestedHours,          
    VDMR.ExtraHours, VDMR.LessWorkedHours, VDMR.MoreWorkedHours, VDMR.MoreRestedHours, VDMR.[IdPointOfInterestIn], VDMR.[PointOfInterestInName],           
    VDMR.[PointOfInterestInIdentifier], VDMR.[PointOfInterestInLatitude], VDMR.[PointOfInterestInLongitude],           
    VDMR.[IdPointOfInterestOut], VDMR.[PointOfInterestOutName], VDMR.[PointOfInterestOutIdentifier], VDMR.[PointOfInterestOutLatitude],           
    VDMR.[PointOfInterestOutLongitude], VDMR.[ExitMarkId], VDMR.[TraveledDistance]  , VDMR.IsJustification, VDMR.IdAbsenceReason, VDMR.FromHour, VDMR.ToHour, VDMR.Comment,    
 VDMR.WorkShiftName, VDMR.WorkShiftStartTime, VDMR.WorkShiftEndTime, VDMR.RestShiftName, VDMR.RestShiftStartTime, VDMR.RestShiftEndTime,   
 VDMR.AbsenceReasonName,VDMR.AbsenceReasonDescription  
  FROM #AllPersonOfInterestDates D          
  LEFT JOIN [dbo].[GetDetailedMarks](@DateFrom, @DateTo, @IdDepartments, @Types, @IdPersonsOfInterest, @IdUser) VDMR          
     ON VDMR.[IdPersonOfInterest] = D.[IdPersonOfInterest] AND Tzdb.AreSameSystemDates(VDMR.[Date], D.[GroupedDate]) = 1           
  ORDER BY D.GroupedDate ASC,VDMR.[RestEntryTime] ASC          
  DROP TABLE #AllPersonOfInterestDates          
 END          
 ELSE          
 BEGIN          
          
  SELECT *           
  FROM [dbo].[GetDetailedMarks](@DateFrom, @DateTo, @IdDepartments, @Types, @IdPersonsOfInterest, @IdUser)          
  ORDER BY [Date] ASC, EntryTime ASC          
 END          
          
 --DECLARE @DateFromTruncated [sys].[date]          
 --DECLARE @DateToTruncated [sys].[date]          
          
 --SET @DateFromTruncated = CAST(@DateFrom AS [sys].[date])          
 --SET @DateToTruncated = CAST(@DateTo AS [sys].[date])          
          
 --;WITH ViewDetailedMarksReport([Id], [IdPersonOfInterest], [Type], [Date], [Latitude], [Longitude], [LatLong], [IdPointOfInterest]) AS          
 --(          
 -- SELECT [Id], [IdPersonOfInterest], [Type], [Date], [Latitude], [Longitude], [LatLong], [IdPointOfInterest]          
 -- FROM [dbo].[Mark] M WITH(NOLOCK)          
 -- WHERE [type] ='E'          
 -- AND CAST([Date] AS [sys].[date])>= @DateFromTruncated AND CAST([Date] AS [sys].[date])<=@DateToTruncated          
 --)          
          
 --SELECT  DISTINCT VDMR.[IdPersonOfInterest], VDMR.[Id], CAST(VDMR.[Date] AS [sys].[date]) as Date, S.[Name] AS PersonOfInterestName, S.[LastName] AS PersonOfInterestLastName, S.[Identifier] AS PersonOfInterestIdentifier,          
 --   VDMR.[Date] as EntryTime, VDMR.[Latitude] as [EntryLatitude], VDMR.[Longitude] as [EntryLongitude], EDMark.[Date] as [RestEntryTime], EDMark.[Latitude] as [RestEntryLatitude],          
 --   EDMark.[Longitude] as [RestEntryLongitude],SDMark.[Date] as[RestExitTime], SDMark.[Latitude] as[RestExitLatitude], SDMark.[Longitude] as [RestExitLongitude],          
 --   SMark.[Date] as[ExitTime], SMark.[Latitude] as [ExitLatitude], SMark.[Longitude] as [ExitLongitude],          
 --   (CASE          
 --    WHEN SMark.[Date] IS NOT NULL AND VDMR.[Date] IS NOT NULL THEN SMark.[Date] - VDMR.[Date]          
 --    WHEN SMark.[Date] IS NULL AND SDMark.[Date] IS NOT NULL AND VDMR.[Date]IS NOT NULL THEN SDMark.[Date]- VDMR.[Date]          
 --    WHEN SMark.[Date] IS NULL AND EDMark.[Date] IS NOT NULL AND VDMR.[Date] IS NOT NULL THEN EDMark.[Date] - VDMR.[Date]          
 --    --WHEN SMark.[Date] IS NULL AND EDMark.[Date] IS NULL AND SDMark.[Date] IS NULL THEN VDMR.[Date] - VDMR.[Date]          
 --    ELSE NULL          
 --    END) AS WorkedHours,          
 --   (CASE          
 --    WHEN SDMark.[Date] IS NOT NULL AND EDMark.[Date] IS NOT NULL THEN SDMark.[Date] - EDMark.[Date]          
 --    ELSE NULL          
 --    END) AS RestedHours,          
 --   dbo.CalculateExtraHours(VDMR.[Date], SMark.[Date], SS.[WorkHours]) AS ExtraHours,          
 --   (CASE          
 --    WHEN SMark.[Date] IS NOT NULL AND VDMR.[Date] IS NOT NULL THEN IIF((SMark.[Date] - VDMR.[Date]) < CAST(SS.[WorkHours] AS [sys].[datetime]), 1, 0)          
 --    WHEN SMark.[Date] IS NULL AND SDMark.[Date] IS NOT NULL AND VDMR.[Date] IS NOT NULL THEN IIF((SDMark.[Date] - VDMR.[Date]) < CAST(SS.[WorkHours] AS [sys].[datetime]), 1, 0)          
 --    WHEN SMark.[Date] IS NULL AND EDMark.[Date] IS NOT NULL AND VDMR.[Date] IS NOT NULL THEN IIF((EDMark.[Date] - VDMR.[Date]) < CAST(SS.[WorkHours] AS [sys].[datetime]), 1, 0)          
 --    ELSE 1          
 --    END) AS LessWorkedHours,          
 --   (CASE          
 --    WHEN SDMark.[Date] IS NOT NULL AND EDMark.[Date] IS NOT NULL THEN IIF(SS.[RestHours] IS NOT NULL AND (SDMark.[Date] - EDMark.[Date]) > CAST(SS.[RestHours] AS [sys].[datetime]), 1, 0)          
 --    ELSE 0          
 --    END) AS MoreRestedHours          
 --   ,POIIn.[Id] AS [IdPointOfInterestIn], POIIn.[Name] AS [PointOfInterestInName], POIIn.[Identifier] AS [PointOfInterestInIdentifier], POIIn.[Latitude] AS [PointOfInterestInLatitude], POIIn.[Longitude] AS [PointOfInterestInLongitude]          
 --   ,POIOut.[Id] AS [IdPointOfInterestOut], POIOut.[Name] AS [PointOfInterestOutName], POIOut.[Identifier] AS [PointOfInterestOutIdentifier], POIOut.[Latitude] AS [PointOfInterestOutLatitude], POIOut.[Longitude] AS [PointOfInterestOutLongitude]         
 
 --FROM  ViewDetailedMarksReport VDMR          
 --   --INNER JOIN [dbo].[AvailablePersonOfInterest] S WITH(NOLOCK) ON S.[Id] = VDMR.[IdPersonOfInterest] SE CAMBIA PARA QUE APAREZCAN LOS ELIMINADOS          
 --   INNER JOIN [dbo].[PersonOfInterest] S WITH(NOLOCK) ON S.[Id] = VDMR.[IdPersonOfInterest]          
 --   LEFT OUTER JOIN [dbo].[PersonOfInterestSchedule] SS WITH(NOLOCK) ON SS.[IdPersonOfInterest] = S.[Id] AND SS.[IdDayOfWeek] = DATEPART(WEEKDAY, VDMR.[Date])          
 --   LEFT OUTER JOIN [dbo].[Mark] EDMark WITH (NOLOCK) ON  CAST(EDMark.[Date]  AS [sys].[date]) = CAST(VDMR.[Date]  AS [sys].[date])          
 --            AND EDMark.[IdPersonOfInterest] = VDMR.[IdPersonOfInterest]           
 --            AND EDMark.[Type] ='ED'          
 --            AND EDMark.[Date]> VDMR.[Date]           
 --            AND (SELECT COUNT(1)FROM [dbo].[Mark] M1 WITH (NOLOCK) WHERE M1.[IdPersonOfInterest] = VDMR.[IdPersonOfInterest]          
 --               AND M1.[Type] = 'ED' AND M1.[Id] != EDMark.[Id]          
 --               AND M1.[Date]> VDMR.[Date] AND M1.[Date]<EDMark.[Date])=0          
 --   LEFT OUTER JOIN [dbo].[Mark] SDMark WITH (NOLOCK) ON  CAST(SDMark.[Date]  AS [sys].[date]) = CAST(VDMR.[Date]  AS [sys].[date])          
 --            AND SDMark.[IdPersonOfInterest] = VDMR.[IdPersonOfInterest]          
 --            AND SDMark.[Type] = 'SD'          
 --            AND SDMark.[Date]> VDMR.[Date]          
 --            AND (SELECT COUNT(1) FROM [dbo].[Mark] M2 WITH (NOLOCK) WHERE M2.[IdPersonOfInterest] = VDMR.[IdPersonOfInterest]          
 --              AND M2.[Type] = 'SD' AND M2.[Id] != SDMark.[Id]          
 --              AND M2.[Date]> VDMR.[Date] AND M2.[Date]<SDMark.[Date])=0          
 --   LEFT OUTER JOIN [dbo].[Mark] SMark WITH (NOLOCK) ON SMark.IdParent = VDMR.Id --  CAST(SMark.[Date]  AS [sys].[date]) = CAST(VDMR.[Date]  AS [sys].[date])          
 --            AND SMark.[IdPersonOfInterest] = VDMR.[IdPersonOfInterest]          
 --            AND SMark.[Type] = 'S'          
 --            --AND SMark.[Date]> VDMR.[Date]           
 --            AND SMark.[Deleted] = 0          
 --            AND (SELECT COUNT(1) FROM [dbo].[Mark] M3 WITH (NOLOCK) WHERE M3.[IdPersonOfInterest] = VDMR.[IdPersonOfInterest]          
 --              AND M3.[Type] = 'S' AND M3.[Id] != SMark.[Id]          
 --              AND M3.[Date]> VDMR.[Date] AND M3.[Date]<SMark.[Date] AND SMark.[Deleted] = 0)=0           
 --   LEFT OUTER JOIN [dbo].[PointOfInterest] POIIn WITH (NOLOCK) ON VDMR.[IdPointOfInterest] = POIIn.[Id]          
 --   LEFT OUTER JOIN [dbo].[PointOfInterest] POIOut WITH (NOLOCK) ON SMark.[IdPointOfInterest] = POIOut.[Id]          
 --WHERE  ((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) and          
 --   ((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND          
 --   ((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND          
 --   ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND          
 --   ((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1))          
 --ORDER BY VDMR.[IdPersonOfInterest],VDMR.[Date] DESC          
END
