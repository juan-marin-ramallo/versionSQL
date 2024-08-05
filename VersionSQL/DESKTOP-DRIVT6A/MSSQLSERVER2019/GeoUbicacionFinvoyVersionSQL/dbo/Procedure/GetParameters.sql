/****** Object:  Procedure [dbo].[GetParameters]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetParameters]
	 @TypeOptions  varchar(max) = NULL
	,@IncludeInvisibles bit = 0
  ,@IncludeDeleted bit = 0
AS
BEGIN

	SELECT		P.[Id], P.[Name], P.[Deleted], P.[CreatedDate], P.[IdUser], P.[IdType], P.[Description], P.[Value], P.[Order],
				U.[Name] as UserName, U.[LastName] as UserLastName,
				T.Name as TypeName, T.Untouchable

	FROM		[dbo].Parameter P
				INNER JOIN [dbo].[User] U ON U.[Id] = P.[IdUser]
				INNER JOIN dbo.ParameterType T on T.Id = P.IdType
	
	WHERE	(@IncludeDeleted = 1 OR P.[Deleted] = 0)
				AND	((@TypeOptions IS NULL) OR (dbo.CheckValueInList(P.[IdType], @TypeOptions) = 1))
				AND ((@IncludeInvisibles = 1) OR (T.Invisible = 0))
	
	ORDER BY 	TypeName ASC, P.CreatedDate DESC 
END
