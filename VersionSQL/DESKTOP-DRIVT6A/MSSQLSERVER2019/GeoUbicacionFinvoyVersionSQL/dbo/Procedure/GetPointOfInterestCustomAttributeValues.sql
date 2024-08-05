/****** Object:  Procedure [dbo].[GetPointOfInterestCustomAttributeValues]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetPointOfInterestCustomAttributeValues]
	@IdPointOfInterest int
AS
BEGIN
	
	SELECT cv.[Id], cv.[IdCustomAttribute], ISNULL(cao.[Text], cv.[Value]) as [Value], cv.IdCustomAttributeOption
		  ,CAT.[Name], CAT.[DefaultValue]
		  ,CAT.[IdValueType], ct.[Description] 
	FROM CustomAttributeValue cv WITH (NOLOCK)
		JOIN CustomAttributeTranslated CAT WITH (NOLOCK) ON CAT.Id = cv.IdCustomAttribute
		JOIN CustomAttributeValueTypeTranslated ct WITH (NOLOCK) ON ct.Code = CAT.IdValueType
		LEFT OUTER JOIN dbo.CustomAttributeOption cao WITH(NOLOCK) on cv.IdCustomAttributeOption = cao.Id
	WHERE cv.IdPointOfInterest = @IdPointOfInterest
END
