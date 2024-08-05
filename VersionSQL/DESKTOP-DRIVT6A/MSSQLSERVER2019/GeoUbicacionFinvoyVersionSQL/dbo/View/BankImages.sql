/****** Object:  View [dbo].[BankImages]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:  Cbarbarini
-- Create date: 17/02/2022
-- Description: Get images from tasks
-- =============================================
CREATE VIEW [dbo].[BankImages]
AS
SELECT DISTINCT cf.Date AS CompletedFormDate
	, a.Id AS AnswerId
	, a.ImageName
	, a.ImageEncoded
	, a.ImageUrl
	, peoi.Name AS PersonOfInterestName
	, peoi.LastName AS PersonOfInterestLastName
	, pooi.Name AS PointOfInterestName
	, q.Text AS Question
	, q.Id AS QuestionId
	, cf.StartDate
	, f.Id AS FormId
	, f.IdFormCategory
	, f.IdFormType
	, cf.IdPersonOfInterest
	, cf.IdPointOfInterest
	, peoi.IdDepartment AS PeIdDepartment
	, pooi.IdDepartment AS PoIdDepartment
	, f.IdCompany
	, a.IdCompletedForm
	, peoiz.IdZone
	, phl1.Name AS HierarchyLevel1
	, pooi.Address
	, d.Name AS Department
FROM CompletedForm (NOLOCK) cf
INNER JOIN Answer (NOLOCK) a ON cf.Id = a.IdCompletedForm AND a.QuestionType = 'CAM' AND a.ImageName IS NOT NULL AND a.ImageName <> '' AND a.ImageUrl IS NOT NULL
LEFT JOIN Form f (NOLOCK) ON cf.IdForm = f.Id
LEFT JOIN PersonOfInterest (NOLOCK) peoi ON cf.IdPersonOfInterest = peoi.Id
LEFT JOIN PersonOfInterestZone (NOLOCK) peoiz ON cf.IdPersonOfInterest = peoiz.IdPersonOfInterest
LEFT JOIN PointOfInterest (NOLOCK) pooi ON cf.IdPointOfInterest = pooi.Id
LEFT JOIN Question (NOLOCK) q ON a.IdQuestion = q.Id
LEFT JOIN POIHierarchyLevel1 (NOLOCK) phl1 ON pooi.GrandfatherId = phl1.Id
LEFT JOIN Department (NOLOCK) d ON pooi.IdDepartment = d.Id
