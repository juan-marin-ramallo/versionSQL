/****** Object:  Procedure [dbo].[GetCustomAttributeWithValues]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetCustomAttributeWithValues]
	@IdPointOfInterest int
AS
BEGIN
	
	SELECT		CAT.[Id], ISNULL(cao.[Text], cv.[Value]) as [Value], cv.IdCustomAttributeOption, CAT.[Name], CAT.[DefaultValue], CAT.[IdValueType], ct.[Description] 
	
	FROM		[dbo].[CustomAttributeTranslated] CAT WITH (NOLOCK)
				JOIN [dbo].[CustomAttributeValueTypeTranslated] ct WITH (NOLOCK) ON ct.Code = CAT.IdValueType
				LEFT JOIN [dbo].[CustomAttributeValue] cv WITH (NOLOCK) ON CAT.Id = cv.IdCustomAttribute and cv.[IdPointOfInterest] = @IdPointOfInterest
				LEFT OUTER JOIN dbo.CustomAttributeOption cao with(nolock) on cv.IdCustomAttributeOption = cao.Id

	WHERE		CAT.[CanDelete] = 1 AND CAT.[Deleted] = 0
END
