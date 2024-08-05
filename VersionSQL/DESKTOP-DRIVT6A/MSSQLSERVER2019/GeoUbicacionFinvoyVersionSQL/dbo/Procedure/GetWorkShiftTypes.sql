/****** Object:  Procedure [dbo].[GetWorkShiftTypes]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetWorkShiftTypes]      
AS      
BEGIN      
 SELECT 
	WST.[Id],   
	WST.[Name]
 FROM [dbo].WorkShiftType WST  
END
