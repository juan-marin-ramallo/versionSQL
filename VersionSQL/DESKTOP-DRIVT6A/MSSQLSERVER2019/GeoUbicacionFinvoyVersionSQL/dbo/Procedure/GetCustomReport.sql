/****** Object:  Procedure [dbo].[GetCustomReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================    
-- Author:  <Author,,Name>    
-- Create date: <Create Date,,>    
-- Description: <Description,,>    
-- =============================================    
CREATE PROCEDURE [dbo].[GetCustomReport]    
 @Id int    
AS    
BEGIN    
    
 SELECT C.[Id], C.[Name], C.[TemplateFilename],    
     T.[Id] AS IdType, T.[Name] AS TypeName,    
     F.[Id] AS IdField, F.[Name] AS FieldName,    
     F.[IdCustomAttribute], F.[IdProductReportAttribute], FG.[Id] AS IdFieldGroup, F.[IdOrderReportAttribute], F.[IdAssetReportAttribute]    
    
 FROM [dbo].CustomReport C  WITH(NOLOCK)    
 JOIN [dbo].[CustomReportCustomReportType] CRT WITH(NOLOCK) ON CRT.IdCustomReport = C.Id    
 JOIN [dbo].CustomReportTypeTranslated T  WITH(NOLOCK) ON T.[Id] = CRT.[IdCustomReportType]    
 LEFT JOIN [dbo].CustomReportField CF WITH(NOLOCK) ON CF.[IdCustomReport] = C.[Id]    
 LEFT JOIN [dbo].FieldTranslated F WITH(NOLOCK) ON F.[Id] = CF.[IdField]    
 LEFT JOIN [dbo].FieldGroupTranslated FG  WITH(NOLOCK) ON FG.[Id] = F.[IdFieldGroup]    
    
 WHERE C.[Id] = @Id    
 ORDER BY FG.[Order], CRT.Id asc ,F.[Order]    
    
    
 SELECT C.[IdCustomReport], FO.[Id] AS IdForm, FO.[Name] AS FormName    
    
 FROM [dbo].CustomReportForm C  WITH(NOLOCK)    
 INNER JOIN [dbo].Form FO  WITH(NOLOCK) ON FO.[Id] = C.[IdForm]    
    
 WHERE C.[IdCustomReport] = @Id AND FO.IsFormPlus = 0    
    
    
 SELECT C.[IdCustomReport], D.[Id] AS IdDynamic, D.[Name] AS DynamicName    
    
 FROM [dbo].CustomReportDynamic C  WITH(NOLOCK)    
 INNER JOIN [dbo].[Dynamic] D  WITH(NOLOCK) ON D.[Id] = C.[IdDynamic]    
    
 WHERE C.[IdCustomReport] = @Id    
     
END
