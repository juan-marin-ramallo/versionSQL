/****** Object:  Procedure [dbo].[GetBankImages]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================      
-- Author:  Cbarbarini      
-- Create date: 11/02/2022      
-- Description: Get images from tasks      
-- =============================================      
CREATE PROCEDURE [dbo].[GetBankImages]      
 @FilterDateFrom DATETIME      
 , @FilterDateTo DATETIME      
 , @CurrentPage INT = 0      
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
  , @InternalCurrentPage INT = @CurrentPage      
  , @InternalFilterFormIds VARCHAR(MAX) = @FilterFormIds      
  , @InternalFilterFormCategoryIds VARCHAR(MAX) = @FilterFormCategoryIds      
  , @InternalFilterTypeIds VARCHAR(MAX) = @FilterTypeIds      
  , @InternalFilterPersonOfInterestIds VARCHAR(MAX) = @FilterPersonOfInterestIds      
  , @InternalFilterPersonOfInterestZoneIds VARCHAR(MAX) = @FilterPersonOfInterestZoneIds      
  , @InternalFilterPointOfInterestIds VARCHAR(MAX) = @FilterPointOfInterestIds      
  , @InternalFilterIdUser INT = @FilterIdUser    
  , @InternalFilterTagIds VARCHAR(MAX) = @FilterTagIds    
    
 SELECT DISTINCT bi.CompletedFormDate AS CompletedFormDate      
  , bi.AnswerId      
  , bi.ImageName      
  , bi.ImageEncoded      
  , bi.ImageUrl      
  , bi.PersonOfInterestName      
  , bi.PersonOfInterestLastName      
  , bi.PointOfInterestName      
  , bi.Question      
  , bi.IdCompletedForm      
  , bi.QuestionId      
  , bi.HierarchyLevel1      
  , bi.Address      
  , bi.Department      
 FROM BankImages AS bi      
 LEFT JOIN Answer a (NOLOCK) ON bi.IdCompletedForm = a.IdCompletedForm AND a.QuestionType = 'TAG'
 LEFT JOIN AnswerTag [at] (NOLOCK) ON a.Id = [at].IdAnswer      
 WHERE ((bi.CompletedFormDate >= @InternalFilterDateFrom AND bi.CompletedFormDate <= @InternalFilterDateTo) OR      
  (bi.StartDate >= @InternalFilterDateFrom AND bi.StartDate <= @InternalFilterDateTo))      
  AND ((@InternalFilterFormIds IS NULL) OR (dbo.CheckValueInList(bi.FormId, @InternalFilterFormIds) = 1))      
  AND ((@InternalFilterFormCategoryIds IS NULL) OR (dbo.CheckValueInList(bi.IdFormCategory, @InternalFilterFormCategoryIds) = 1))      
  AND ((@InternalFilterTypeIds IS NULL) OR (dbo.CheckValueInList(bi.IdFormType, @InternalFilterTypeIds) = 1))      
  AND ((@InternalFilterPersonOfInterestIds IS NULL) OR (dbo.CheckValueInList(bi.IdPersonOfInterest, @InternalFilterPersonOfInterestIds) = 1))      
  AND ((@InternalFilterPersonOfInterestZoneIds IS NULL) OR (dbo.CheckValueInList(bi.IdZone, @InternalFilterPersonOfInterestZoneIds) = 1))      
  AND ((@InternalFilterPointOfInterestIds IS NULL) OR (dbo.CheckValueInList(bi.IdPointOfInterest, @InternalFilterPointOfInterestIds) = 1))      
  AND ((@InternalFilterIdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(bi.IdPointOfInterest, @InternalFilterIdUser) = 1))      
  AND ((@InternalFilterIdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(bi.IdPersonOfInterest, @InternalFilterIdUser) = 1))      
  AND ((@InternalFilterIdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(bi.PeIdDepartment, @InternalFilterIdUser) = 1))      
  AND ((@InternalFilterIdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(bi.PoIdDepartment, @InternalFilterIdUser) = 1))      
  AND ((@InternalFilterIdUser IS NULL) OR (dbo.CheckUserInFormCompanies(bi.IdCompany, @InternalFilterIdUser) = 1))      
  AND ((@InternalFilterTagIds IS NULL) OR ((@InternalFilterTagIds = '-1' AND [at].IdAnswer IS NULL) OR (@InternalFilterTagIds <> '-1' AND [at].IdTag IS NOT NULL AND dbo.[CheckValueInList]([at].IdTag, @InternalFilterTagIds) = 1)))      
 ORDER BY bi.CompletedFormDate DESC, bi.IdCompletedForm ASC, bi.QuestionId ASC      
 OFFSET (12 * @InternalCurrentPage) ROWS      
 FETCH NEXT 12 ROWS ONLY      
END
