/****** Object:  Procedure [dbo].[SaveFormCategory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Matias Corso
-- Create date: 11/10/2016
-- Description:	SP para guardar una categoría de tarea
-- =============================================
CREATE PROCEDURE [dbo].[SaveFormCategory]
	 @Id [sys].[int] OUTPUT
	,@Name [sys].[varchar](50)
	,@Description [sys].[varchar](250)
	,@IdUser [sys].[int]
AS
BEGIN
	DECLARE @Now [sys].[datetime]
	SET @Now = GETUTCDATE()

	--FormCategory Name Duplicated
	IF EXISTS (SELECT 1 FROM FormCategory WHERE [Name] = @Name AND Deleted = 0) SELECT @Id = -1;

	ELSE
	BEGIN 
		INSERT INTO dbo.FormCategory
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
