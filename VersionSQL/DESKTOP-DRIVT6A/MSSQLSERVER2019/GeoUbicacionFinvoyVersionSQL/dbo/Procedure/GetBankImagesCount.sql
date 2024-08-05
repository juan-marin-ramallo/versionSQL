/****** Object:  Procedure [dbo].[GetBankImagesCount]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================      
-- Author:  Cbarbarini      
-- Create date: 14/02/2022      
-- Description: Get images count from tasks      
-- =============================================      
CREATE PROCEDURE [dbo].[GetBankImagesCount]      
 @FilterDateFrom DATETIME      
 , @FilterDateTo DATETIME      
 , @FilterFormIds VARCHAR(MAX) = NULL      
 , @FilterFormCategoryIds VARCHAR(MAX) = NULL      
 , @FilterTypeIds VARCHAR(MAX) = NULL      
 , @FilterPersonOfInterestIds VARCHAR(MAX) = NULL      
 , @FilterPersonOfInterestZoneIds VARCHAR(MAX) = NULL      
 , @FilterPointOfInterestIds VARCHAR(MAX) = NULL      
 , @FilterIdUser INT = NULL      
 , @FilterTagIds VARCHAR(MAX) = NULL      
AS      
BEGIN      
 DECLARE @InternalFilterDateFrom DATETIME = @FilterDateFrom      
  , @InternalFilterDateTo DATETIME = @FilterDateTo      
  , @InternalFilterFormIds VARCHAR(MAX) = @FilterFormIds      
  , @InternalFilterFormCategoryIds VARCHAR(MAX) = @FilterFormCategoryIds      
  , @InternalFilterTypeIds VARCHAR(MAX) = @FilterTypeIds      
  , @InternalFilterPersonOfInterestIds VARCHAR(MAX) = @FilterPersonOfInterestIds      
  , @InternalFilterPersonOfInterestZoneIds VARCHAR(MAX) = @FilterPersonOfInterestZoneIds      
  , @InternalFilterPointOfInterestIds VARCHAR(MAX) = @FilterPointOfInterestIds      
  , @InternalFilterIdUser INT = @FilterIdUser    
  , @InternalFilterTagIds VARCHAR(MAX) = @FilterTagIds    
    
 SELECT COUNT(DISTINCT bi.AnswerId) AS Count      
 FROM BankImages AS bi WITH (NOLOCK)      
 LEFT JOIN Answer a (NOLOCK) ON bi.IdCompletedForm = a.IdCompletedForm AND a.QuestionType = 'TAG'
 LEFT JOIN AnswerTag [at] (NOLOCK) ON a.Id = [at].IdAnswer      
 WHERE ((bi.CompletedFormDate >= @InternalFilterDateFrom AND bi.CompletedFormDate <= @InternalFilterDateTo) OR      
  (bi.StartDate >= @InternalFilterDateFrom AND bi.StartDate <= @InternalFilterDateTo))      
  AND ((@InternalFilterFormIds IS NULL) OR (dbo.CheckValueInList(bi.FormId, @InternalFilterFormIds) = 1))      
  AND ((@InternalFilterFormCategoryIds IS NULL) OR (dbo.CheckValueInList(bi.IdFormCategory, @InternalFilterFormCategoryIds) = 1))      
  AND ((@InternalFilterTypeIds IS NULL) OR (dbo.CheckValueInList(bi.IdFormType, @InternalFilterTypeIds) = 1))      
  AND ((@InternalFilterPersonOfInterestIds IS NULL) OR (dbo.CheckValueInList(bi.IdPersonOfInterest, @InternalFilterPersonOfInterestIds) = 1))      
  AND ((@InternalFilterPersonOfInterestIds IS NULL) OR (dbo.CheckValueInList(bi.IdPersonOfInterest, @FilterPersonOfInterestIds) = 1))      
  AND ((@InternalFilterPointOfInterestIds IS NULL) OR (dbo.CheckValueInList(bi.IdPointOfInterest, @InternalFilterPointOfInterestIds) = 1))      
  AND ((@InternalFilterIdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(bi.IdPointOfInterest, @InternalFilterIdUser) = 1))      
  AND ((@InternalFilterIdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(bi.IdPersonOfInterest, @InternalFilterIdUser) = 1))      
  AND ((@InternalFilterIdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(bi.PeIdDepartment, @InternalFilterIdUser) = 1))      
  AND ((@InternalFilterIdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(bi.PoIdDepartment, @InternalFilterIdUser) = 1))      
  AND ((@InternalFilterIdUser IS NULL) OR (dbo.CheckUserInFormCompanies(bi.IdCompany, @InternalFilterIdUser) = 1))      
  AND ((@InternalFilterTagIds IS NULL) OR ((@InternalFilterTagIds = '-1' AND [at].IdAnswer IS NULL) OR (@InternalFilterTagIds <> '-1' AND [at].IdTag IS NOT NULL AND dbo.[CheckValueInList]([at].IdTag, @InternalFilterTagIds) = 1)))      
END
