/****** Object:  Procedure [dbo].[GetProfileCustomAttributeGroups]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetProfileCustomAttributeGroups](
	@Code [char](1)
)
AS
BEGIN

	SELECT	C.[Id], C.[Name], CT.[Order]
	
	FROM	[dbo].[CustomAttributeGroup] C
			INNER JOIN [dbo].[CustomAttributeGroupPersonType] CT ON C.[Id] = CT.[IdCustomAttributeGroup]
	
	WHERE	C.[Deleted] = 0 AND CT.[PersonOfInterestType] = @Code
	
	ORDER BY CT.[Order] asc
END
