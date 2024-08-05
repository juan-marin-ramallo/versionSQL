/****** Object:  Procedure [dbo].[GetPersonOfInterestById]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Diego Cáceres
-- Create date: 24/12/2016
-- Description:	SP para obtener una Persona de Interes por Id
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonOfInterestById]
(
	 @IdPersonOfInterest [sys].[int] = NULL
	,@IncludeDeleted [sys].[bit] = 0
)
AS
BEGIN
	SELECT		AP.[Id], AP.[Name], [LastName], [Identifier], [MobilePhoneNumber], [MobileIMEI], [Email], 
				[Status], [Type], [IdDepartment], D.[Name] as DepartmentName
	FROM		[dbo].[PersonOfInterest] AP
	LEFT JOIN	[dbo].[Department] D ON D.[Id] = AP.[IdDepartment] 

	WHERE		AP.[Id] = @IdPersonOfInterest
				AND (@IncludeDeleted = 1 OR  ([Deleted] = 0 AND [Pending] = 0 AND [Status] = 'H'))
END
