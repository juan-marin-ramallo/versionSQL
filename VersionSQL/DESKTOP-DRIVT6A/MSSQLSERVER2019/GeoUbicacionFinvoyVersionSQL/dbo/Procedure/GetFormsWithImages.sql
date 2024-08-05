/****** Object:  Procedure [dbo].[GetFormsWithImages]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:  Cbarbarini
-- Create date: 14/02/2022
-- Description: Get forms with images
-- =============================================
CREATE PROCEDURE [dbo].[GetFormsWithImages]
	
AS
	BEGIN
		;WITH Images(IdForm, IdPersonOfInterest, IdPointOfInterest) AS
	(
		SELECT cf.IdForm, cf.IdPersonOfInterest, cf.IdPointOfInterest
		FROM CompletedForm (NOLOCK) cf
		INNER JOIN Answer (NOLOCK) a ON cf.Id = a.IdCompletedForm AND a.QuestionType = 'CAM' AND a.ImageName IS NOT NULL AND a.ImageName <> '' AND a.ImageUrl IS NOT NULL
	)

	SELECT DISTINCT f.Id, UPPER(f.Name) AS Name, (CASE WHEN Tzdb.IsGreaterOrSameSystemDate(f.EndDate, GETUTCDATE()) = 1 THEN 0 ELSE 1 END) AS Inactive, 'Forms' AS Type
	FROM Images AS i
	INNER JOIN Form f (NOLOCK) ON i.IdForm = f.Id AND f.Deleted = 0
	UNION
	SELECT DISTINCT fc.Id, UPPER(fc.Name) AS Name, 0 AS Inactive, 'FormCategories' AS Type
	FROM Images AS i
	INNER JOIN Form f (NOLOCK) ON i.IdForm = f.Id AND f.Deleted = 0
	INNER JOIN FormCategory (NOLOCK) fc ON f.IdFormCategory = fc.Id
	UNION
	SELECT DISTINCT p.Id, UPPER(p.Name) AS Name, 0 AS Inactive, 'FormTypes' AS Type
	FROM Images AS i
	INNER JOIN Form f (NOLOCK) ON i.IdForm = f.Id AND f.Deleted = 0
	INNER JOIN Parameter (NOLOCK) p ON f.IdFormType = p.Id
ORDER BY 3, 2
END
