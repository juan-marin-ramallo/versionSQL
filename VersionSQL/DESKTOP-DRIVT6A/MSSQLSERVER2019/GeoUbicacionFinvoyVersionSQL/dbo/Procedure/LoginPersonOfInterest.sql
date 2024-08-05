/****** Object:  Procedure [dbo].[LoginPersonOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		FS
-- Create date: 09/10/2012
-- Description:	SP para login de Personas de Interes con usuario y pass
-- =============================================
CREATE PROCEDURE [dbo].[LoginPersonOfInterest]
(
	@Identifier [sys].[varchar](20),
	@Pin [sys].[varchar](4)
)
AS
BEGIN
	SELECT	[Id], [Name], [LastName], [Identifier], [MobilePhoneNumber], [MobileIMEI], [Status], [Type], [IdDepartment], [Email]
	FROM	[dbo].[AvailablePersonOfInterest]
	WHERE	Identifier = @Identifier AND Pin = @Pin
			AND NOT EXISTS (SELECT 1 FROM [dbo].[CustomerValidation] WITH (NOLOCK) WHERE [BlockedMobile] = 1)	
END
