/****** Object:  Procedure [dbo].[GetCustomReportTypeFieldGroups]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[GetCustomReportTypeFieldGroups]  
 @IdCustomReportType [int] ,
 @IncludeChileanAttribute BIT = 0 
AS  
BEGIN  
   
 SELECT FG.[Id] AS IdFieldGroup, FG.[Name] AS FieldGroupName  
    ,F.[Id] AS IdField, F.[Name] AS FieldName, F.[IsDefault]  
    ,F.[IdCustomAttribute], F.[IdProductReportAttribute], F.[IdOrderReportAttribute], F.[IdAssetReportAttribute]  
 FROM FieldGroupTranslated FG WITH (NOLOCK)  
	JOIN FieldTranslated F WITH (NOLOCK) 
		ON F.[IdFieldGroup] = FG.[Id]  
	JOIN CustomReportTypeFieldGroup C WITH (NOLOCK) 
		ON C.[IdFieldGroup] = FG.[Id]  
  
 WHERE C.IdCustomReportType = @IdCustomReportType  
		AND F.[Deleted] = 0 AND F.[FullDeleted] = 0  
		AND (F.IsOnlyChileanRegulation = @IncludeChileanAttribute OR @IncludeChileanAttribute = 1)

  
 ORDER BY FG.[Order], F.[Order]  
  
END
