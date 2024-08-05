/****** Object:  Procedure [dbo].[GetAllRoutesReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  gl  
-- Create date: 10/07/2015  
-- Description: SP para obtener todas las rutas definidas para los filtros establecidos  
-- =============================================  
CREATE PROCEDURE [dbo].[GetAllRoutesReport]  
(  
  @DateFrom [sys].[datetime]  
 ,@DateTo [sys].[datetime]  
 ,@IdDepartments [sys].[varchar](max) = NULL  
 ,@Types [sys].[varchar](max) = NULL  
 ,@IdPersonsOfInterest [sys].[varchar](max) = NULL  
 ,@IdPointsOfInterest [sys].[varchar](max) = NULL   
 ,@IdUser [sys].[int] = NULL  
)  
AS  
BEGIN  
 SELECT R.IdRoute, R.[RouteDate], R.IdPersonOfInterest, R.PersonOfInterestName,   
   R.PersonOfInterestLastName, R.[IdPointOfInterest], R.PointOfInterestName,  
   R.PointOfInterestIdentifier  
 FROM [dbo].[AllRoutesFiltered](@DateFrom,@DateTo,@IdDepartments,@Types,@IdPersonsOfInterest,@IdPointsOfInterest,@IdUser,1) R  
 ORDER BY R.IdRoute desc  
END  
  
