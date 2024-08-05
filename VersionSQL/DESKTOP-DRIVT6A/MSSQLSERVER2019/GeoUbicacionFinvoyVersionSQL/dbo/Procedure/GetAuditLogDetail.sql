/****** Object:  Procedure [dbo].[GetAuditLogDetail]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 13/03/20
-- Description:	SP para obtener reporte de auditoria
-- =============================================
CREATE PROCEDURE [dbo].[GetAuditLogDetail]
(
	@Id [sys].[int]
)
AS
BEGIN

	SELECT	a.[Id],a.[IdUser],a.[Date],a.[Entity], ae.[Name] as [EntityName],a.[Action], aa.[Name] as [ActionName],a.[ControllerName] ,a.[ActionName],a.[ResultData], u.[Name] as [UserName], u.[LastName] as [UserLastName]
		, a.RequestData, a.ResultData, af.Id as FileId, af.[FileName], af.[Url] as FileUrl
	FROM	[dbo].[AuditLog] a
			INNER JOIN [dbo].[AuditedEntityTranslated] ae  WITH (NOLOCK) ON a.[Entity] = ae.Id
			INNER JOIN [dbo].[AuditedActionTranslated] aa  WITH (NOLOCK) ON a.[Action] = aa.Id
			INNER JOIN [dbo].[User] u WITH(NOLOCK) on a.IdUser = u.Id
			LEFT OUTER JOIN [dbo].[AuditLogFile] af WITH(NOLOCK) ON a.Id = af.IdAuditLog
	WHERE	a.Id = @Id
	GROUP BY	a.[Id],a.[IdUser],a.[Date],a.[Entity], ae.[Name],a.[Action], aa.[Name],a.[ControllerName] ,a.[ActionName],a.[ResultData], u.[Name], u.[LastName]
		, a.RequestData, a.ResultData, af.Id, af.[FileName], af.[Url]
	ORDER BY af.[FileName] asc
END
