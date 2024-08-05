/****** Object:  Procedure [dbo].[GetCustomAttributeByPointAndProfile]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		gl
-- Create date: 25-03-2018
-- Description:	Devuelve grupos de atributos asignados a un punto y a un perfil
-- =============================================
CREATE PROCEDURE [dbo].[GetCustomAttributeByPointAndProfile](
	@IdPersonOfInterest [sys].[int],
	@IdPointOfInterest [sys].[int]
)
AS
BEGIN

	DECLARE @PersonOfInterestType [sys].[CHAR](1) = (SELECT TOP 1 [Type] FROM [dbo].PersonOfInterest WITH (NOLOCK) WHERE [Id] = @IdPersonOfInterest)

	SELECT		CA.[Id] CustomAttributeId, CA.[Name] AS CustomAttributeName, ISNULL(CAO.[Text], CAV.[Value]) AS CustomAttributeValue, CAV.[IdCustomAttributeOption], 
				CA.[IdValueType] AS CustomAttributeType, CAGPT.[IdCustomAttributeGroup], CA.[DefaultValue]
	
	FROM		[dbo].[CustomAttributeTranslated] CA 
				LEFT JOIN [dbo].[CustomAttributeValue] CAV ON CAV.[IdCustomAttribute] = CA.[Id] AND CAV.[IdPointOfInterest] = @IdPointOfInterest		 
				left outer join [dbo].[CustomAttributeOption] CAO with(nolock) on CAV.IdCustomAttributeOption = CAO.Id												
				LEFT JOIN [dbo].[CustomAttributeGroupCustomAttribute] CAGA ON CA.[Id] = CAGA.[IdCustomAttribute]
				LEFT JOIN [dbo].[CustomAttributeGroup] CAG ON CAGA.[IdCustomAttributeGroup] = CAG.[Id] AND CAG.[Deleted] = 0
				LEFT JOIN [dbo].[CustomAttributeGroupPersonType] CAGPT ON CAG.[Id] = CAGPT.[IdCustomAttributeGroup] 
				
	WHERE		CA.CanDelete = 1 AND CA.[Deleted] = 0  
				AND CAGPT.PersonOfInterestType = @PersonOfInterestType

	ORDER BY	CA.[Id], CAGPT.[IdCustomAttributeGroup]

END
