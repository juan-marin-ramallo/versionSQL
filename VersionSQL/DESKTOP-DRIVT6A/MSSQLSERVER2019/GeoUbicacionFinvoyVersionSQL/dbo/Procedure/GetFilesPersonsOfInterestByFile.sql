/****** Object:  Procedure [dbo].[GetFilesPersonsOfInterestByFile]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 01/09/2015
-- Description:	SP para obtener los stockers de un archivo
-- =============================================
CREATE PROCEDURE [dbo].[GetFilesPersonsOfInterestByFile]
(
	@IdFile [sys].[INT]
	,@IdPersonsOfInterest [sys].[varchar](max) = null
    ,@IdUser [sys].[INT]= NULL
)
AS
BEGIN
	SELECT		FP.[IdFile], FP.[IdPersonOfInterest], S.[Name] AS PersonOfInterestName, 
				S.[LastName] AS PersonOfInterestLastName, 
				FP.[Received], FP.[ReceivedDate], FP.[Read], FP.[ReadDate]
	FROM		[dbo].[FilePersonOfInterest] FP WITH (NOLOCK) INNER JOIN
				[dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = FP.[IdPersonOfInterest]
	WHERE		FP.[IdFile] = @IdFile AND
				((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1))	
	ORDER BY	S.[Name], S.[LastName]
END
