/****** Object:  Procedure [dbo].[GetCustomAttributesGroupsForPerson]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetCustomAttributesGroupsForPerson](
	@IdPersonOfInterest [sys].[int]
)
AS
BEGIN
	DECLARE @Type [sys].[CHAR](1) = (SELECT TOP 1 [Type] FROM dbo.PersonOfInterest WITH (NOLOCK) WHERE Id = @IdPersonOfInterest)

	SELECT c.[Id],c.[Name],c.[CreatedDate],c.[IdUser],c.[Deleted], ct.[Order]
	FROM [dbo].[CustomAttributeGroup] c
		INNER JOIN [dbo].[CustomAttributeGroupPersonType] ct ON c.Id = ct.IdCustomAttributeGroup
	WHERE c.[Deleted] = 0 AND ct.PersonOfInterestType = @Type
	ORDER BY ct.[Order] asc
END
