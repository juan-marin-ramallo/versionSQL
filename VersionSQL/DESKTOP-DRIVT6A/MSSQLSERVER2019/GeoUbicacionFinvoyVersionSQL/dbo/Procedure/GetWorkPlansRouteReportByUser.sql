/****** Object:  Procedure [dbo].[GetWorkPlansRouteReportByUser]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  Matias Corso  
-- Create date: 28/09/2017  
-- Description: SP para obtener reporte de visitas de agendas por usuario  
-- =============================================  
CREATE PROCEDURE [dbo].[GetWorkPlansRouteReportByUser]  
    @DateFrom [sys].[DATETIME] ,  
    @DateTo [sys].[DATETIME] ,  
    @UserId IdTableType Readonly,  
    @ActivityType [sys].[INT] --Visitas Directas o Indirectas  
AS  
BEGIN  
  
    DECLARE @PersonId [VARCHAR](max)  
 SET @PersonId = (  
  SELECT ','+ CAST(U.IdPersonOfInterest AS VARCHAR(12))  
  From @UserId IDU  
   INNER JOIN dbo.[User] U ON IDU.Id = U.Id  
  ORDER BY U.NAME ASC, U.LastName ASC  
  For XML PATH ('')  
 )  
  
    IF @PersonId IS NOT NULL  
        BEGIN  
            SELECT  R.PointOfInterestName ,  
                    R.RouteDate AS PlannedDate ,  
                    R.PointOfInterestVisitedInDate AS VisitDate ,  
     --0 AS PlannedTime ,  
                    R.VisitTime ,  
                    CASE WHEN R.RouteStatus = 1 THEN 1  
                            ELSE 0  
                    END AS RouteStatus,  
     U.[Name] AS UserName, U.[LastName] AS UserLastName  
            FROM    [dbo].[RoutesReportFiltered](@DateFrom, @DateTo, NULL, NULL,  
                                                    @PersonId + ',', NULL, NULL, DEFAULT, NULL, 1) AS R  
     INNER JOIN [dbo].[User] U ON U.IdPersonOfInterest = R.PersonOfInterestId  
            WHERE   ( R.ActivityVisitTypeId IS NOT NULL  
                        AND R.ActivityVisitTypeId = @ActivityType  
                    )  
                    AND ( R.RouteStatus = 1  
                            OR R.RouteStatus = 2  
                        )  
            ORDER BY U.[Name] ASC, U.LastName ASC, R.RouteDate desc;  
        END;  
END;  
  
