/****** Object:  Procedure [dbo].[GetCustomAttributeValues]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetCustomAttributeValues]
	@IdPointOfInterest int
AS
BEGIN
	SELECT v.[Id], v.[IdCustomAttribute], ISNULL(cao.[Text], v.[Value]) as [Value], v.[IdCustomAttributeOption],
		CAT.[Name], CAT.[DefaultValue], CAT.[IdValueType]
	FROM CustomAttributeValue v
		JOIN CustomAttributeTranslated CAT with(nolock) ON CAT.Id = v.IdCustomAttribute
		LEFT OUTER JOIN dbo.CustomAttributeOption cao with(nolock) on v.IdCustomAttributeOption = cao.Id
	WHERE v.IdPointOfInterest = @IdPointOfInterest
	  AND CAT.[Deleted] = 0
END
