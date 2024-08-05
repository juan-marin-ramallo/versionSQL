/****** Object:  Procedure [dbo].[SaveNoVisitOption]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston L.
-- Create date: 05/08/2016
-- Description:	SP para guardar un motivo de una no visita a la ruta
-- =============================================
CREATE PROCEDURE [dbo].[SaveNoVisitOption]
	 @Id [sys].[int] OUTPUT
	,@Description [sys].[varchar](50)
	,@IdUser [sys].[int]
AS
BEGIN

	--RouteNoVisitOption Description Duplicated
	IF EXISTS (SELECT 1 FROM RouteNoVisitOption WITH (NOLOCK) WHERE [Description] = @Description AND Deleted = 0) SELECT @Id = -1;

	ELSE
	BEGIN
		DECLARE @Now [sys].[datetime]
		SET @Now = GETUTCDATE()

		INSERT INTO dbo.RouteNoVisitOption
				( Description ,
				  CreatedDate ,
				  IdUser ,
				  Deleted,
				  EditedDate
				)
		VALUES  ( @Description , -- Description - varchar(50)
				  @Now , -- CreatedDate - datetime
				  @IdUser , -- IdUser - int
				  0,  -- Deleted - bit
				  @Now
				)

		SELECT @Id = SCOPE_IDENTITY()
	END
	
END
