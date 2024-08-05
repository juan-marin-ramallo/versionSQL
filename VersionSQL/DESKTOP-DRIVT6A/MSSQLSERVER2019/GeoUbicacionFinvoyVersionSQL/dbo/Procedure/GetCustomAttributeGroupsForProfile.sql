/****** Object:  Procedure [dbo].[GetCustomAttributeGroupsForProfile]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		gl
-- Create date: 25-03-2018
-- Description:	Devuelve grupos de atributos asignados a un perfil
-- =============================================
CREATE PROCEDURE [dbo].[GetCustomAttributeGroupsForProfile](
	@CodeProfile [sys].[char]
)
AS
BEGIN

	SELECT  CG.[Id], CG.[Name], CP.[Order]
	
	FROM    [dbo].[CustomAttributeGroup] CG
			INNER JOIN [dbo].[CustomAttributeGroupPersonType] CP ON CG.Id = CP.[IdCustomAttributeGroup]
	
	WHERE	CP.[PersonOfInterestType] = @CodeProfile
	
	ORDER BY CP.[Order] asc

END
