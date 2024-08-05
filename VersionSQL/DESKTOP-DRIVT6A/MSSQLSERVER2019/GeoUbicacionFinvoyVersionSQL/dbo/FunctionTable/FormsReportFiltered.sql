/****** Object:  TableFunction [dbo].[FormsReportFiltered]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  Federico Sobral  
-- Create date: 23/08/2016  
-- Description: <Description,,>  
-- =============================================  
CREATE FUNCTION [dbo].[FormsReportFiltered]  
(  
  @DateFrom [sys].[DATETIME]  
 ,@DateTo [sys].[DATETIME]  
 ,@IdPersonsOfInterest [sys].[VARCHAR](MAX) = NULL  
 ,@IdPointsOfInterest [sys].[VARCHAR](MAX) = NULL   
 ,@IncludeAutomaticVisits [sys].[BIT] = 1  
 ,@IdUser [sys].[INT] = NULL  
)  
RETURNS @t TABLE ([FormId] [sys].[INT], [FormName] [sys].[VARCHAR](100), [Date] [sys].[DATETIME],   
 [PersonOfInterestId] [sys].[INT], [PersonOfInterestName] [sys].[VARCHAR](50), [PersonOfInterestLastName] [sys].[VARCHAR](50),  
  [PointOfInterestId] [sys].[INT], PointOfInterestName [sys].[VARCHAR](100),[PointOfInterestIdentifier] [sys].[VARCHAR](50),  
  [CompletedFormId] [sys].[INT], IdPointOfInterestVisited [sys].[INT])  
AS  
BEGIN  
  
 --INSERT INTO @t   
 -- SELECT F.[Id] as [FormId], F.[Name] as [FormName], r.[RouteDate] AS [Date],  
 --  r.[PersonOfInterestId], r.[PersonOfInterestName], r.[PersonOfInterestLastName], R.[PointOfInterestId], r.[PointOfInterestName],  r.[PointOfInterestIdentifier],  
 --  cf.[Id] as [CompletedFormId]  
 --FROM [dbo].[RoutesReportFiltered](@DateFrom,@DateTo,null,null,@IdPersonsOfInterest,@IdPointsOfInterest,@IdUser) r   
 --  INNER JOIN [dbo].[AssignedForm] af ON r.[PointOfInterestId] = af.[IdPointOfInterest] AND r.[PersonOfInterestId] = af.[IdPersonOfInterest] AND r.[RouteDate] >= af.[Date] AND (af.[Deleted] = 0 OR r.[RouteDate] <= af.[DeletedDate])  
 --  INNER JOIN [dbo].[Form] f ON af.[IdForm] = f.[Id] AND (r.[RouteDate] <= f.[EndDate] OR (f.[Deleted] = 1 AND  R.[RouteDate] <= F.[DeletedDate]))  
 --  LEFT OUTER JOIN [dbo].[CompletedForm] cf ON F.[Id] = CF.[IdForm] AND r.[PointOfInterestId] = cf.[IdPointOfInterest] AND r.[PersonOfInterestId] = cf.[IdPersonOfInterest] AND CAST(r.[RouteDate] AS [sys].[date]) = CAST(cf.[Date] AS [sys].[date])  
 --WHERE r.[RouteStatus] = 1  
  
 --RETURN   
  
 INSERT INTO @t   
  SELECT F.[Id] as [FormId], F.[Name] as [FormName], r.[RouteDate] AS [Date],  
   r.[PersonOfInterestId], r.[PersonOfInterestName], r.[PersonOfInterestLastName], R.[PointOfInterestId], r.[PointOfInterestName],  r.[PointOfInterestIdentifier],  
   cf.[Id] as [CompletedFormId], r.IdPointOfInterestVisited  
   
 FROM [dbo].[RoutesReportFiltered](@DateFrom,@DateTo,null,null,@IdPersonsOfInterest,@IdPointsOfInterest,@IncludeAutomaticVisits,DEFAULT,@IdUser,1) r   
   INNER JOIN [dbo].[AssignedForm] af with(nolock) ON r.[PersonOfInterestId] = af.[IdPersonOfInterest] AND r.[RouteDate] >= af.[Date] AND (af.[Deleted] = 0 OR r.[RouteDate] <= af.[DeletedDate])  
   INNER JOIN [dbo].[Form] f with(nolock) ON af.[IdForm] = f.[Id] AND (f.[Deleted] = 0 AND r.[RouteDate] <= f.[EndDate] OR (f.[Deleted] = 1 AND  R.[RouteDate] <= F.[DeletedDate]))  
   LEFT OUTER JOIN [dbo].[CompletedForm] cf with(nolock) ON F.[Id] = CF.[IdForm] AND r.[PointOfInterestId] = cf.[IdPointOfInterest] AND r.[PersonOfInterestId] = cf.[IdPersonOfInterest] AND Tzdb.AreSameSystemDates(r.[RouteDate], cf.[Date]) = 1 --CONVERT(date, r.[RouteDate]) = CONVERT(date, cf.[Date])  
  
 WHERE (r.[RouteStatus] = 1 OR r.[RouteStatus] = 3) AND   
 (F.[AllPointOfInterest] = 1 OR r.[PointOfInterestId] = af.[IdPointOfInterest])  
 AND ((@IdUser IS NULL) OR (dbo.CheckUserInFormCompanies(F.[IdCompany], @IdUser) = 1))   
 RETURN   
  
END  
