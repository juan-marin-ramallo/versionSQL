/****** Object:  Procedure [dbo].[GetAuditLog]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 22/08/2016
-- Description:	SP para obtener reporte de auditoria
-- Change: Matias Corso	- 27/10/2016 - no devuelvo si es de superadmin
-- =============================================
CREATE PROCEDURE [dbo].[GetAuditLog]
(
	@DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@IdEntities [sys].[varchar](max) = NULL
	,@IdActions [sys].[varchar](max) = NULL
	,@IdUsers [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] 
)
AS
BEGIN

	DECLARE @UserType [sys].[varchar](1) = (SELECT [Type] FROM [dbo].[User] WHERE Id = @IdUser)
	--DECLARE @UserSuperAdmin

	SELECT	a.[Id],a.[IdUser],a.[Date],a.[Entity], ae.[Name] as [EntityName],a.[Action], aa.[Name] as [ActionName],a.[ControllerName] ,a.[ActionName],a.[ResultData], u.[Name] as [UserName], u.[LastName] as [UserLastName]
		, af.Id as FileId, af.[FileName], af.[Url] as FileUrl
	FROM	[dbo].[AuditLog] a
			INNER JOIN [dbo].[AuditedEntityTranslated] ae  WITH (NOLOCK) ON a.[Entity] = ae.Id
			INNER JOIN [dbo].[AuditedActionTranslated] aa  WITH (NOLOCK) ON a.[Action] = aa.Id
			INNER JOIN [dbo].[User] u on a.IdUser = u.Id
			LEFT OUTER JOIN [dbo].[AuditLogFile] af WITH(NOLOCK) ON a.Id = af.IdAuditLog
	WHERE	(u.[SuperAdmin] = 0 OR (u.[Id] = @IdUser AND u.[SuperAdmin] = 1)) AND 
			a.[Date] BETWEEN @DateFrom AND @DateTo AND
			(@IdEntities IS NULL OR (dbo.CheckValueInList(a.[Entity], @IdEntities) = 1)) AND
			(@IdActions IS NULL OR (dbo.CheckValueInList(a.[Action], @IdActions) = 1)) AND
			(@IdUsers IS NULL OR (dbo.CheckValueInList(a.[IdUser], @IdUsers) = 1)) 
	GROUP BY	a.[Id],a.[IdUser],a.[Date],a.[Entity], ae.[Name],a.[Action], aa.[Name],a.[ControllerName] ,a.[ActionName],a.[ResultData], u.[Name], u.[LastName]
	, af.Id, af.[FileName], af.[Url]
	ORDER BY a.[Date] desc
END
