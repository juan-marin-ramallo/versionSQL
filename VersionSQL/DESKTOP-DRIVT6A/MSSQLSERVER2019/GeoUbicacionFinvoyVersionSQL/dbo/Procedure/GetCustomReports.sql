/****** Object:  Procedure [dbo].[GetCustomReports]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[GetCustomReports]  
  @CustomReportIds varchar(max) = NULL  
 ,@CustomReportTypeIds varchar(max) = NULL  
 ,@AllCustomReports [sys].[bit] = 1  
 ,@IdUser [int] = NULL  
AS  
BEGIN  
   
 SELECT C.[Id], C.[Name], CRT.[IdCustomReportType] AS IdType, --C.[IdType],  
     T.[Name] AS TypeName, C.TemplateFilename
   
 FROM CustomReport C WITH (NOLOCK)  
 LEFT JOIN [dbo].[Form] F WITH (NOLOCK) ON F.[Id] = C .[IdForm]  
 JOIN [dbo].[CustomReportCustomReportType] CRT WITH(NOLOCK) ON CRT.IdCustomReport = C.Id  
 JOIN CustomReportTypeTranslated T WITH (NOLOCK) ON T.[Id] = CRT.[IdCustomReportType]  
 LEFT JOIN [dbo].[PermissionTranslated] P WITH (NOLOCK) ON P.[Id] = T.[IdPermission]  
 WHERE C.[Deleted] = 0  
   AND ((@CustomReportIds IS NULL) OR (dbo.[CheckValueInList](C.[Id], @CustomReportIds) = 1))  
   --AND ((@CustomReportTypeIds IS NULL) OR (dbo.[CheckValueInList](C.[IdType], @CustomReportTypeIds) = 1))  
   AND ((@CustomReportTypeIds IS NULL) OR (dbo.[CheckValueInList](CRT.[IdCustomReportType], @CustomReportTypeIds) = 1))  
   AND ((@AllCustomReports = 1) OR (C.[IdUser] = @IdUser))  
   AND (T.[IdPermission] IS NULL OR EXISTS (SELECT 1 FROM [dbo].[UserPermission] UP WHERE UP.[IdUser] = @IdUser AND UP.[IdPermission] = P.[Id]))  
   AND ((C.[IdForm] IS NULL) OR ((@IdUser IS NULL) OR (dbo.CheckUserInFormCompanies(F.[IdCompany], @IdUser) = 1)))  
   
 ORDER BY C.[EditedDate] DESC, C.[CreateDate] DESC  
  
END
