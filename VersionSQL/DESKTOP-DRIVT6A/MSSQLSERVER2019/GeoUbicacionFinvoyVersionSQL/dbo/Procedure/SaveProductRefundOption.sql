/****** Object:  Procedure [dbo].[SaveProductRefundOption]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston L.
-- Create date: 30/08/2016
-- Description:	SP para guardar un motivo de una devolucion de stock
-- =============================================
CREATE PROCEDURE [dbo].[SaveProductRefundOption]
	 @Id [sys].[int] OUTPUT
	,@Description [sys].[varchar](50)
	,@IdUser [sys].[int]
AS
BEGIN

	--ProductRefundOptions Description Duplicated
	IF EXISTS (SELECT 1 FROM ProductRefundOptions WITH (NOLOCK) WHERE [Description] = @Description AND Deleted = 0) SELECT @Id = -1;

	ELSE
	BEGIN
		DECLARE @Now [sys].[datetime]
		SET @Now = GETUTCDATE()

		INSERT INTO dbo.ProductRefundOptions
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
