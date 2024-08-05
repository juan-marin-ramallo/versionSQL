/****** Object:  Procedure [dbo].[SaveFile]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 01/09/2015
-- Description:	SP para guardar un mensaje
-- =============================================
CREATE PROCEDURE [dbo].[SaveFile]
(
	 @Name [sys].[varchar](500)
	 ,@Title [sys].[varchar](100)
	 ,@Url [sys].[varchar](500)
	,@IdPersonsOfInterest [sys].[varchar](max)
	,@IdUser [sys].[INT]
	,@Size [sys].[INT]
    
)
AS
BEGIN
	DECLARE @Id [sys].[int]

	INSERT INTO dbo.[File]
	        ( FileName, Url, Date, Deleted, IdUser,Title, Size )
	VALUES  ( @Name, -- Name - varchar(100)
	          @Url, -- Url - varchar(500)
	          GETUTCDATE(), -- Date - datetime
	          0, -- Deleted - bit
	          @IdUser,  -- IdUser - int
			  @Title,
			  @Size
	          )
	
	SELECT @Id = SCOPE_IDENTITY()

	INSERT INTO [dbo].[FilePersonOfInterest]([IdFile], [IdPersonOfInterest], [Received], [Read])
	(SELECT @Id AS IdFile, S.[Id] AS IdPersonOfInterest, 0 AS Received, 0 AS [Read]
	 FROM	[dbo].[PersonOfInterest] S WITH (NOLOCK)
	 WHERE	dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1
	)

	SELECT [DeviceId] FROM [dbo].[PersonOfInterest] WITH (NOLOCK) WHERE	dbo.CheckValueInList([Id], @IdPersonsOfInterest) = 1
													 AND [DeviceId] IS NOT NULL
END
