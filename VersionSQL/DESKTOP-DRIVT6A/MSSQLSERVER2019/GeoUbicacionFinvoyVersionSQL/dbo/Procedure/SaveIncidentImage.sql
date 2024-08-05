/****** Object:  Procedure [dbo].[SaveIncidentImage]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		FS
-- Create date: 02/05/22
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[SaveIncidentImage]
	@ImageName [sys].[varchar](100),
	@ImageUrl [sys].[varchar](5000) = NULL,
	@ImageEncoded [sys].[varbinary](MAX) = NULL,
	@Result [sys].[smallint] OUT

AS
BEGIN
	DECLARE @Id [sys].[int] = NULL
	DECLARE @ImageNumber [sys].[smallint]
	SET @Result = -1 
	
	SELECT @Id = [Id]
		  ,@ImageNumber = CASE WHEN @ImageName = [ImageName] THEN 1
								WHEN @ImageName = [ImageName2] THEN 2
								WHEN @ImageName = [ImageName3] THEN 3 END
	FROM [dbo].[Incident]
	WHERE @ImageName = [ImageName] OR @ImageName = [ImageName2] OR @ImageName = [ImageName3]


	IF @Id IS NOT NULL
	BEGIN
		IF @ImageNumber = 1
		BEGIN
			UPDATE[dbo].[Incident]
			SET [ImageUrl] = @ImageUrl, [ImageEncoded] = @ImageEncoded
			where [Id] = @Id
		END		
		ELSE IF @ImageNumber = 2
		BEGIN
			UPDATE[dbo].[Incident]
			SET [ImageUrl2] = @ImageUrl, [ImageEncoded2] = @ImageEncoded
			where [Id] = @Id
		END
		ELSE IF @ImageNumber = 3
		BEGIN
			UPDATE[dbo].[Incident]
			SET [ImageUrl3] = @ImageUrl, [ImageEncoded3] = @ImageEncoded
			where [Id] = @Id
		END
		SET @Result = 0
	END

END
