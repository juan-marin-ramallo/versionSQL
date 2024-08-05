/****** Object:  Procedure [dbo].[GetMessagePersonsOfInterestByMessage]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 31/01/2013
-- Description:	SP para obtener los reponedores de un mensaje
-- =============================================
CREATE PROCEDURE [dbo].[GetMessagePersonsOfInterestByMessage]
(
	@IdMessage [sys].[INT]
	,@IdPersonsOfInterest [sys].[varchar](max) = null
    ,@IdUser [sys].[INT] = NULL
)
AS
BEGIN
	SELECT		MS.[IdMessage], MS.[IdPersonOfInterest], S.[Name] AS PersonOfInterestName, S.[LastName] AS PersonOfInterestLastName, MS.[Received], MS.[ReceivedDate], MS.[Read], MS.[ReadDate]
	FROM		[dbo].[MessagePersonOfInterest] MS INNER JOIN
				[dbo].[PersonOfInterest] S ON S.[Id] = MS.[IdPersonOfInterest]
	WHERE		MS.[IdMessage] = @IdMessage AND
				((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1))	
	ORDER BY	S.[Name], S.[LastName]
END
