/****** Object:  Procedure [dbo].[GetCustomAttributesByGroup]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		gl
-- Create date: 25-03-2018
-- Description:	Devuelve atributos personalizados de una agrupaci[on
-- =============================================
CREATE PROCEDURE [dbo].[GetCustomAttributesByGroup](
	@IdGroup [sys].[int]
)
AS
BEGIN

	SELECT  CAT.[Id], CAT.[Name], CT.[Order], CAT.[IdValueType], T.[Description]
	
	FROM    [dbo].[CustomAttributeTranslated] CAT WITH (NOLOCK)
			INNER JOIN  [dbo].[CustomAttributeGroupCustomAttribute] CT WITH (NOLOCK) ON CAT.Id = CT.IdCustomAttribute
			INNER JOIN	[dbo].[CustomAttributeValueTypeTranslated] T WITH (NOLOCK) ON T.[Code] = CAT.[IdValueType]
	
	WHERE	CT.[IdCustomAttributeGroup] = @IdGroup
	
	ORDER BY CT.[Order] asc

END
