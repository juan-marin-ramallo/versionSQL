/****** Object:  TableFunction [dbo].[GetDetailedMarks]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================              
-- Author:  Federico Sobral              
-- Create date: 23/08/2016              
-- Description: <Description,,>           
-- Modified by: Juan Marin    
-- Modified date: 15/03/2024    
-- Description: Se agrega los turnos de trabajo y colacion para Chile    
-- =============================================              
CREATE FUNCTION [dbo].[GetDetailedMarks]              
(              
  @DateFrom [sys].[datetime]              
 ,@DateTo [sys].[datetime]              
 ,@IdDepartments [sys].[varchar](1000) = NULL              
 ,@Types [sys].[varchar](1000) = NULL              
 ,@IdPersonsOfInterest [sys].[varchar](max) = NULL              
 ,@IdUser [sys].[int] = NULL              
)              
RETURNS @t TABLE (IdPersonOfInterest [sys].[int], [Id] [sys].[int], [Date] [sys].[datetime],              
  PersonOfInterestName [sys].[varchar](50), PersonOfInterestLastName [sys].[varchar](50),               
  PersonOfInterestIdentifier [sys].[varchar](20),              
  [EntryTime] [sys].[datetime], [EntryLatitude] [sys].[decimal](18,6), [EntryLongitude] [sys].[decimal](18,6), [EditedEntryTime] [sys].[bit],              
  [RestEntryTime] [sys].[datetime], [RestEntryLatitude] [sys].[decimal](18,6), [RestEntryLongitude] [sys].[decimal](18,6), [EditedRestEntryTime] [sys].[bit],            
  [RestExitTime] [sys].[datetime], [RestExitLatitude] [sys].[decimal](18,6), [RestExitLongitude] [sys].[decimal](18,6), [EditedRestExitTime] [sys].[bit],            
  [ExitTime] [sys].[datetime], [ExitLatitude] [sys].[decimal](18,6), [ExitLongitude] [sys].[decimal](18,6), [EditedExitTime] [sys].[bit],            
  [WorkedHours] [sys].[datetime], [RestedHours] [sys].[datetime], [ExtraHours] [sys].[datetime],               
  [LessWorkedHours] [sys].[bit], [MoreWorkedHours] [sys].[bit], [MoreRestedHours] [sys].[bit],             
  [IdPointOfInterestIn] [sys].[int], [PointOfInterestInName] [sys].[varchar](100),[PointOfInterestInIdentifier] [sys].[varchar](50),               
  [PointOfInterestInLatitude] [sys].[decimal](18,2), [PointOfInterestInLongitude] [sys].[decimal](18,2),              
  [IdPointOfInterestOut] [sys].[int], [PointOfInterestOutName] [sys].[varchar](100), [PointOfInterestOutIdentifier] [sys].[varchar](50),              
  [PointOfInterestOutLatitude] [sys].[decimal](18,2), [PointOfInterestOutLongitude] [sys].[decimal](18,2),              
  PersonOfInterestMobilePhoneNumber [sys].[varchar](20), PersonOfInterestMobileIMEI [sys].[varchar](40),              
  [ExitMarkId] [sys].[int], [TraveledDistance] [sys].[decimal](8, 2), IsJustification [sys].[bit], IdAbsenceReason [sys].[int], FromHour [sys].[time] , ToHour [sys].[time], Comment [sys].[varchar](1024),        
  AbsenceReasonName [sys].[varchar](20), AbsenceReasonDescription [sys].[varchar](200),     
  WorkShiftName [varchar](100), WorkShiftStartTime [sys].[time], WorkShiftEndTime [sys].[time],     
  RestShiftName [varchar](100), RestShiftStartTime [sys].[time], RestShiftEndTime [sys].[time])              
AS              
BEGIN              
 DECLARE @ViewDetailedMarksReport TABLE              
 (              
  Id [sys].[int], IdPersonOfInterest [sys].[int], [Type] [sys].[varchar](5), [Date] [sys].[datetime],              
  [Latitude] [sys].[decimal](18,6), [Longitude] [sys].[decimal](18,6), [LatLong] [sys].[geography],              
  [IdPointOfInterest] [sys].[int]   , [Edited] [sys].[bit]            
 )              
              
 INSERT INTO @ViewDetailedMarksReport (Id, IdPersonOfInterest, [Type], [Date],[Latitude], [Longitude], [LatLong], [IdPointOfInterest], [Edited])              
 SELECT [Id], [IdPersonOfInterest], [Type], [Date], [Latitude], [Longitude], [LatLong], [IdPointOfInterest], [Edited]            
 FROM [dbo].[Mark] M WITH(NOLOCK)             
 WHERE [type] ='E'              
 --AND Tzdb.IsGreaterOrSameSystemDate([Date], @DateFrom) = 1 AND Tzdb.IsLowerOrSameSystemDate([Date], @DateTo) = 1              
 AND [Date] BETWEEN @DateFrom AND @DateTo              
               
              
 INSERT INTO @t               
    
 SELECT  DISTINCT VDMR.[IdPersonOfInterest], VDMR.[Id], Tzdb.ToUtc(CAST(Tzdb.FromUtc(VDMR.[Date]) AS [sys].[date])) as Date,              
    S.[Name] AS PersonOfInterestName,               
    S.[LastName] AS PersonOfInterestLastName, S.[Identifier] AS PersonOfInterestIdentifier,              
    VDMR.[Date] as EntryTime, VDMR.[Latitude] as [EntryLatitude], VDMR.[Longitude] as [EntryLongitude], VDMR.[Edited] AS [EditedEntryTime] ,             
    EDMark.[Date] as [RestEntryTime], EDMark.[Latitude] as [RestEntryLatitude], EDMark.[Longitude] as [RestEntryLongitude], EDMark.[Edited] AS [EditedRestEntryTime],             
 SDMark.[Date] as[RestExitTime],  SDMark.[Latitude] as[RestExitLatitude], SDMark.[Longitude] as [RestExitLongitude], SDMark.[Edited] AS [EditedRestExitTime],             
    SMark.[Date] as[ExitTime], SMark.[Latitude] as [ExitLatitude], SMark.[Longitude] as [ExitLongitude], SMark.[Edited] AS [EditedExitTime],               
    (CASE              
     WHEN SMark.[Date] IS NOT NULL AND VDMR.[Date] IS NOT NULL THEN SMark.[Date] - VDMR.[Date]              
     WHEN SMark.[Date] IS NULL AND SDMark.[Date] IS NOT NULL AND VDMR.[Date]IS NOT NULL THEN SDMark.[Date]- VDMR.[Date]              
     WHEN SMark.[Date] IS NULL AND EDMark.[Date] IS NOT NULL AND VDMR.[Date] IS NOT NULL THEN EDMark.[Date] - VDMR.[Date]              
     --WHEN SMark.[Date] IS NULL AND EDMark.[Date] IS NULL AND SDMark.[Date] IS NULL THEN VDMR.[Date] - VDMR.[Date]              
     ELSE NULL              
     END) AS WorkedHours,              
    (CASE              
     WHEN SDMark.[Date] IS NOT NULL AND EDMark.[Date] IS NOT NULL THEN SDMark.[Date] - EDMark.[Date]              
     ELSE NULL              
     END) AS RestedHours,              
    dbo.CalculateExtraHours(VDMR.[Date], SMark.[Date], SS.[WorkHours]) AS ExtraHours,              
    (CASE              
     WHEN SMark.[Date] IS NOT NULL AND VDMR.[Date] IS NOT NULL THEN IIF((SMark.[Date] - VDMR.[Date]) < CAST(SS.[WorkHours] AS [sys].[datetime]), 1, 0)              
     WHEN SMark.[Date] IS NULL AND SDMark.[Date] IS NOT NULL AND VDMR.[Date] IS NOT NULL THEN IIF((SDMark.[Date] - VDMR.[Date]) < CAST(SS.[WorkHours] AS [sys].[datetime]), 1, 0)              
     WHEN SMark.[Date] IS NULL AND EDMark.[Date] IS NOT NULL AND VDMR.[Date] IS NOT NULL THEN IIF((EDMark.[Date] - VDMR.[Date]) < CAST(SS.[WorkHours] AS [sys].[datetime]), 1, 0)              
     ELSE 1              
     END) AS LessWorkedHours,              
  (CASE              
     WHEN SMark.[Date] IS NOT NULL AND VDMR.[Date] IS NOT NULL THEN IIF((SMark.[Date] - VDMR.[Date]) > CAST(SS.[WorkHours] AS [sys].[datetime]), 1, 0)              
     WHEN SMark.[Date] IS NULL AND SDMark.[Date] IS NOT NULL AND VDMR.[Date] IS NOT NULL THEN IIF((SDMark.[Date] - VDMR.[Date]) > CAST(SS.[WorkHours] AS [sys].[datetime]), 1, 0)              
     WHEN SMark.[Date] IS NULL AND EDMark.[Date] IS NOT NULL AND VDMR.[Date] IS NOT NULL THEN IIF((EDMark.[Date] - VDMR.[Date]) > CAST(SS.[WorkHours] AS [sys].[datetime]), 1, 0)              
     ELSE 1              
     END) AS MoreWorkedHours,             
    (CASE              
     WHEN SDMark.[Date] IS NOT NULL AND EDMark.[Date] IS NOT NULL THEN IIF(SS.[RestHours] IS NOT NULL AND (SDMark.[Date] - EDMark.[Date]) > CAST(SS.[RestHours] AS [sys].[datetime]), 1, 0)              
     ELSE 0              
     END) AS MoreRestedHours            
    ,POIIn.[Id] AS [IdPointOfInterestIn], POIIn.[Name] AS [PointOfInterestInName], POIIn.[Identifier] AS [PointOfInterestInIdentifier], POIIn.[Latitude] AS [PointOfInterestInLatitude], POIIn.[Longitude] AS [PointOfInterestInLongitude]              
    ,POIOut.[Id] AS [IdPointOfInterestOut], POIOut.[Name] AS [PointOfInterestOutName], POIOut.[Identifier] AS [PointOfInterestOutIdentifier], POIOut.[Latitude] AS [PointOfInterestOutLatitude], POIOut.[Longitude] AS [PointOfInterestOutLongitude],          
  
    
    S.[MobilePhoneNumber] AS PersonOfInterestMobilePhoneNumber, S.[MobileIMEI] AS PersonOfInterestMobileIMEI,              
    SMark.[Id] AS ExitMarkId, SMark.[TraveledDistance],            
 0 AS IsJustification,            
 NULL AS IdAbsenceReason, SS.FromHour, SS.ToHour,            
 ML.Comment AS Comment,           
 NULL AS AbsenceReasonName,        
 NULL AS AbsenceReasonDescription,        
 WS.[Name] WorkShiftName,    
 WS.[StartTime] WorkShiftStartTime,    
 WS.[EndTime] WorkShiftEndTime,    
 RS.[Name] RestShiftName,    
 RS.[StartTime] RestShiftStartTime,    
 RS.[EndTime] RestShiftEndTime    
 FROM  @ViewDetailedMarksReport VDMR              
    --INNER JOIN [dbo].[AvailablePersonOfInterest] S WITH(NOLOCK) ON S.[Id] = VDMR.[IdPersonOfInterest] SE CAMBIA PARA QUE APAREZCAN LOS ELIMINADOS              
    INNER JOIN [dbo].[PersonOfInterest] S WITH(NOLOCK) ON S.[Id] = VDMR.[IdPersonOfInterest]              
    LEFT OUTER JOIN [dbo].[PersonOfInterestSchedule] SS WITH(NOLOCK) ON SS.[IdPersonOfInterest] = S.[Id] AND SS.[IdDayOfWeek] = DATEPART(WEEKDAY, Tzdb.FromUtc(VDMR.[Date]))           
 LEFT OUTER JOIN [dbo].[PersonOfInterestWorkShift] PWS WITH(NOLOCK) ON PWS.[IdPersonOfInterest] = S.[Id] AND PWS.[IdDayOfWeek] = DATEPART(WEEKDAY, Tzdb.FromUtc(VDMR.[Date]))         
 LEFT OUTER JOIN [dbo].[WorkShift] WS WITH(NOLOCK) ON WS.[Id] = PWS.[IdWorkShift] AND WS.[IdType] = 1 AND WS.[Deleted] = 0    
 LEFT OUTER JOIN [dbo].[WorkShift] RS WITH(NOLOCK) ON RS.[Id] = PWS.[IdRestShift] AND RS.[IdType] = 2 AND RS.[Deleted] = 0    
    LEFT OUTER JOIN [dbo].[Mark] EDMark WITH (NOLOCK) ON  EDMark.IdParent = VDMR.Id --CAST(EDMark.[Date]  AS [sys].[date]) = CAST(VDMR.[Date]  AS [sys].[date])              
             AND EDMark.[IdPersonOfInterest] = VDMR.[IdPersonOfInterest]               
             AND EDMark.[Type] ='ED'              
             AND EDMark.[Date]> VDMR.[Date]               
             AND (SELECT COUNT(1)FROM [dbo].[Mark] M1 WITH (NOLOCK) WHERE M1.[IdPersonOfInterest] = VDMR.[IdPersonOfInterest]              
                AND M1.[Type] = 'ED' AND M1.[Id] != EDMark.[Id]              
                AND M1.[Date]> VDMR.[Date] AND M1.[Date]<EDMark.[Date])=0              
    LEFT OUTER JOIN [dbo].[Mark] SDMark WITH (NOLOCK) ON SDMark.IdParent = VDMR.Id-- CAST(SDMark.[Date]  AS [sys].[date]) = CAST(VDMR.[Date]  AS [sys].[date])              
             AND SDMark.[IdPersonOfInterest] = VDMR.[IdPersonOfInterest]              
             AND SDMark.[Type] = 'SD'              
             AND SDMark.[Date]> VDMR.[Date]              
             AND (SELECT COUNT(1) FROM [dbo].[Mark] M2 WITH (NOLOCK) WHERE M2.[IdPersonOfInterest] = VDMR.[IdPersonOfInterest]              
               AND M2.[Type] = 'SD' AND M2.[Id] != SDMark.[Id]              
               AND M2.[Date]> VDMR.[Date] AND M2.[Date]<SDMark.[Date])=0              
    LEFT OUTER JOIN (              
     SELECT   MIN([Id]) AS Id, [IdPersonOfInterest], [Type], [Date], [Latitude], [Longitude], [IdParent], [IdPointOfInterest], [Deleted], [TraveledDistance]   , [Edited]            
     FROM  [dbo].[Mark] WITH (NOLOCK)              
     GROUP BY [IdPersonOfInterest], [Type], [Date], [Latitude], [Longitude], [IdParent], [IdPointOfInterest], [Deleted], [TraveledDistance]   , [Edited]            
    ) SMark ON SMark.IdParent = VDMR.Id --  CAST(SMark.[Date]  AS [sys].[date]) = CAST(VDMR.[Date]  AS [sys].[date])              
             AND SMark.[IdPersonOfInterest] = VDMR.[IdPersonOfInterest]              
             AND SMark.[Type] = 'S'              
             --AND SMark.[Date]> VDMR.[Date]               
             AND SMark.[Deleted] = 0              
             AND (SELECT COUNT(1) FROM [dbo].[Mark] M3 WITH (NOLOCK) WHERE M3.[IdPersonOfInterest] = VDMR.[IdPersonOfInterest]              
               AND M3.[Type] = 'S' AND M3.[Id] != SMark.[Id]              
               AND M3.[Date]> VDMR.[Date] AND M3.[Date]<SMark.[Date] AND SMark.[Deleted] = 0)=0               
    LEFT OUTER JOIN [dbo].[PointOfInterest] POIIn WITH (NOLOCK) ON VDMR.[IdPointOfInterest] = POIIn.[Id]              
    LEFT OUTER JOIN [dbo].[PointOfInterest] POIOut WITH (NOLOCK) ON SMark.[IdPointOfInterest] = POIOut.[Id]            
 OUTER  APPLY dbo.GetLatestMarkLogForId(VDMR.Id) AS ML            
 WHERE  ((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) and              
    ((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND              
    ((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND              
    ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND              
    ((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1))              
            
UNION             
 SELECT            
  S.Id AS IdPersonOfInterest,            
  NULL AS Id,            
  PIAJ.[Date] AS [Date],            
  S.[Name] AS PersonOfInterestName,               
  S.[LastName] AS PersonOfInterestLastName,             
  S.[Identifier] AS PersonOfInterestIdentifier,            
  NULL AS EntryTime,            
  NULL AS EntryLatitude,            
  NULL AS EntryLongitude,            
  0 AS [EditedEntryTime],            
  NULL AS RestEntryTime,            
  NULL AS RestEntryLatitude,            
  NULL AS RestEntryLongitude,            
  0 AS [EditedRestEntryTime],            
  NULL AS RestExitTime,            
  NULL AS RestExitLatitude,            
  NULL AS RestExitLongitude,            
  0 AS [EditedRestExitTime],            
  NULL AS ExitTime,            
  NULL AS ExitLatitude,            
  NULL AS ExitLongitude,            
  0 AS [EditedExitTime],            
  NULL AS WorkedHours,            
  NULL AS RestedHours,            
  NULL AS ExtraHours,            
  NULL AS LessWorkedHours,            
  NULL AS MoreWorkedHours,            
  NULL AS MoreRestedHours,            
  NULL AS IdPointOfInterestIn,            
  NULL AS PointOfInterestInName,            
  NULL AS PointOfInterestInIdentifier,            
  NULL AS PointOfInterestInLatitude,            
  NULL AS PointOfInterestInLongitude,            
  NULL AS IdPointOfInterestOut,            
  NULL AS PointOfInterestOutName,            
  NULL AS PointOfInterestOutIdentifier,            
  NULL AS PointOfInterestOutLatitude,            
  NULL AS PointOfInterestOutLongitude,            
  S.[MobilePhoneNumber] AS PersonOfInterestMobilePhoneNumber,  
  S.[MobileIMEI] AS PersonOfInterestMobileIMEI,      
  NULL AS ExitMarkId,            
  NULL AS TraveledDistance,            
  1 AS IsJustification,            
  PIAJ.IdAbsenceReason AS IdAbsenceReason,            
  SS.FromHour,       
  SS.ToHour,          
  PIAJ.Comments AS Comment,             
  AR.Name AS AbsenceReasonName,        
  AR.Description AS AbsenceReasonDescription,        
  WS.[Name] WorkShiftName,    
  WS.[StartTime] WorkShiftStartTime,    
  WS.[EndTime] WorkShiftEndTime,    
  RS.[Name] RestShiftName,    
  RS.[StartTime] RestShiftStartTime,    
  RS.[EndTime] RestShiftEndTime        
 FROM dbo.PersonOfInterestAbsenceJustification PIAJ             
 INNER JOIN PersonOfInterest S             
  ON PIAJ.IdPersonOfInterest = S.id            
 INNER JOIN dbo.AbsenceReason AR        
  ON PIAJ.IdAbsenceReason = AR.Id        
    LEFT OUTER JOIN [dbo].[PersonOfInterestSchedule] SS WITH(NOLOCK)       
  ON SS.[IdPersonOfInterest] = S.[Id] AND SS.[IdDayOfWeek] = DATEPART(WEEKDAY, Tzdb.FromUtc(PIAJ.[Date]))              
  LEFT OUTER JOIN [dbo].[PersonOfInterestWorkShift] PWS WITH(NOLOCK)       
  ON PWS.[IdPersonOfInterest] = S.[Id] AND PWS.[IdDayOfWeek] = DATEPART(WEEKDAY, Tzdb.FromUtc(PIAJ.[Date]))         
  LEFT OUTER JOIN [dbo].[WorkShift] WS WITH(NOLOCK)      
  ON WS.[Id] = PWS.[IdWorkShift] AND WS.[IdType] = 1 AND WS.[Deleted] = 0    
  LEFT OUTER JOIN [dbo].[WorkShift] RS WITH(NOLOCK)      
  ON RS.[Id] = PWS.[IdRestShift] AND RS.[IdType] = 2 AND RS.[Deleted] = 0    
      
 WHERE PIAJ.[Date] BETWEEN @DateFrom AND @DateTo            
             
 ORDER BY VDMR.[IdPersonOfInterest],VDMR.[Date] DESC              
              
 RETURN               
END
