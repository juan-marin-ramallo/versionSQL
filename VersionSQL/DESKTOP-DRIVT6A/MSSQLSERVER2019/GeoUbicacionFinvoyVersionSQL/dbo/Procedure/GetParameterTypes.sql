/****** Object:  Procedure [dbo].[GetParameterTypes]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetParameterTypes]
	
AS
BEGIN

	SELECT		T.[Id], T.[Name], T.[Deleted], T.[Untouchable], T.[Invisible],
				(select count(1) from dbo.Parameter P where P.IdType = T.Id and P.Deleted = 0) as Total

	FROM		[dbo].ParameterType T
	
	WHERE		T.[Deleted] = 0 and T.Invisible = 0
	ORDER BY 	T.[Id]
END
