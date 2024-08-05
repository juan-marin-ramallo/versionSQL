/****** Object:  Procedure [dbo].[GetWorkActivitiesOptionList]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetWorkActivitiesOptionList]  ( @TypeId [sys].[INT] )
AS
BEGIN
	SELECT		P.[Value] AS WorkActivityTypeId, P.[Name] AS WorkActivityName
	FROM		[dbo].[Parameter] P
	WHERE		p.IdType = @TypeId
	ORDER BY	P.[Order]
END
