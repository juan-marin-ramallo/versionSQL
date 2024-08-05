/****** Object:  Procedure [dbo].[SaveIncidentType]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Matias Corso
-- Create date: 18/10/2016
-- Description:	SP para guardar un tipo de observación
-- =============================================
CREATE PROCEDURE [dbo].[SaveIncidentType]
	 @Id [sys].[int] OUTPUT
	,@Name [sys].[varchar](50)
	,@Description [sys].[varchar](250)
	,@IdUser [sys].[int]
AS
BEGIN
	--IncidentType Name Duplicated
	IF EXISTS (SELECT 1 FROM IncidentType WITH (NOLOCK) WHERE [Name] = @Name AND Deleted = 0) SELECT @Id = -1;

	ELSE
	BEGIN
		DECLARE @Now [sys].[datetime]
		SET @Now = GETUTCDATE()

		INSERT INTO dbo.IncidentType
				( [Name] ,
				  [Description] ,
				  CreatedDate ,
				  IdUser ,
				  Deleted,
				  EditedDate
				)
		VALUES  ( @Name , -- Name - varchar(50)
				  @Description , -- Description - varchar(250)
				  @Now , -- CreatedDate - datetime
				  @IdUser , -- IdUser - int
				  0,  -- Deleted - bit
				  @Now
				)

		SELECT @Id = SCOPE_IDENTITY()
	END
	
END
