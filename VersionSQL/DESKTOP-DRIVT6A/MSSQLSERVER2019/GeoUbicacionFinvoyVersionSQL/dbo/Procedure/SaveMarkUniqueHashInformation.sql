/****** Object:  Procedure [dbo].[SaveMarkUniqueHashInformation]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 20/09/2012
-- Description:	SP para guardar una marca
-- =============================================
CREATE PROCEDURE [dbo].[SaveMarkUniqueHashInformation]
(
	 @Id [sys].[int] OUTPUT
	,@IdMark [sys].[int]
	,@IdPersonOfInterest [sys].[int]
	,@Type [sys].[varchar](5)
	,@Date [sys].[datetime]
	,@Latitude [sys].[decimal](25, 20)
	,@Longitude [sys].[decimal](25, 20)
	,@IdPointOfInterest [sys].[int] = NULL
	,@IsOnline [sys].[bit] = NULL
	,@HashCodeResult  [sys].[varchar](1000)
	,@CompanyName [sys].[varchar](250)
	,@CompanyRUT  [sys].[varchar](250)
    ,@CompanyAddress  [sys].[varchar](250)
	,@PersonOfInterestFullName  [sys].[varchar](100)
	,@PersonOfInterestIdentifier [sys].[varchar](20)
	,@PointOfInterestName [sys].[varchar](100) = NULL
	,@PointOfInterestIdentifier [sys].[varchar](50) = NULL
)
AS
BEGIN


	insert into [dbo].[MarkHashInformation]
	([Type], [Date],[Latitude], [Longitude], [IsOnline], [IdPersonOfInterest], [PersonOfInterestFullName],
	[PersonOfInterestIdentifier], [IdPointOfInterest], [PointOfInterestName], 
	[PointOfInterestIdentifier], [HashCodeResult], [IdMark], [CompanyName], [CompanyRUT], [CompanyAddress])
	VALUES (@Type, @Date,@Latitude,@Longitude,@IsOnline,@IdPersonOfInterest,@PersonOfInterestFullName,@PersonOfInterestIdentifier,@IdPointOfInterest,
	@PointOfInterestName,@PointOfInterestIdentifier,@HashCodeResult,@IdMark,@CompanyName, @CompanyRUT, @CompanyAddress)

	SELECT @Id = SCOPE_IDENTITY()
	
END
