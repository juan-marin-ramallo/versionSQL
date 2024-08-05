/****** Object:  Procedure [dbo].[GetTimeZoneByImei]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  Franco  
-- Create date: 14/02/2023  
-- Description: SP para obtener el timezone si esta configurado en el perfil
-- =============================================  
CREATE PROCEDURE [dbo].[GetTimeZoneByImei]  
(  
 @MobileIMEI [sys].[varchar](40) = NULL  
)  
AS  
BEGIN  
 SELECT 
	IdTimeZone
 FROM [dbo].[PersonOfInterest] S WITH (NOLOCK)  
	LEFT JOIN dbo.PersonOfInterestType POIT
		ON S.[Type] = POIT.Code
 WHERE S.[Deleted] = 0 AND  
   S.[Status] = 'H' AND  
   S.[Pending] = 0 AND  
   (S.[MobileIMEI] LIKE '%' + @MobileIMEI + '%')   
END
