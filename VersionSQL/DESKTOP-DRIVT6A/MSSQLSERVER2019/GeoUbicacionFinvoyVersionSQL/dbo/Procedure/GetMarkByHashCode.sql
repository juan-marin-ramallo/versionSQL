/****** Object:  Procedure [dbo].[GetMarkByHashCode]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetMarkByHashCode]

	@HashCode [sys].[varchar](1000) = NULL
AS
BEGIN

	SELECT  [Id]
      ,[Type] as MarkType
      ,[Date]
      ,[Latitude]
      ,[Longitude]
      ,[IsOnline]
      ,[IdPersonOfInterest]
      ,[PersonOfInterestFullName]
      ,[PersonOfInterestIdentifier]
      ,[IdPointOfInterest]
      ,[PointOfInterestName]
      ,[PointOfInterestIdentifier]
      ,[HashCodeResult]
      ,[IdMark]
      ,[CompanyName]
      ,[CompanyRUT]
      ,[CompanyAddress]


	FROM dbo.MarkHashInformation M WITH(NOLOCK)
	WHERE [HashCodeResult] = @HashCode


END
