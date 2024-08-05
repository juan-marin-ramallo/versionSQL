/****** Object:  Procedure [dbo].[GetAssetsReportImagesFilteredById]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetAssetsReportImagesFilteredById]
	@Ids [sys].[VARCHAR](max) = NULL 
AS 
    SELECT		AR.[Id], AR.[Image] AS ReportImageArray
     
	FROM		dbo.[AssetReport] AR
    
	WHERE		((@Ids IS NULL) OR dbo.CheckVarcharInList(AR.[Id], @Ids)=1)  
	
