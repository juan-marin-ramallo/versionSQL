/****** Object:  Procedure [dbo].[SaveWebNoVisitOption]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston L.
-- Create date: 05/11/2018
-- Description:	SP para guardar un motivo de una no visita a la ruta en la web
-- =============================================
CREATE PROCEDURE [dbo].[SaveWebNoVisitOption]
	 @Id [sys].[int] OUTPUT
	,@Description [sys].[varchar](100)
	,@IdUser [sys].[int]
AS
BEGIN

	--[RouteWebNoVisitOption] Description Duplicated
	IF EXISTS (SELECT 1 FROM [dbo].[RouteWebNoVisitOption] WHERE [Description] = @Description AND [Deleted] = 0) SELECT @Id = -1;

	ELSE
	BEGIN 
		INSERT INTO [dbo].[RouteWebNoVisitOption]
				( [Description] ,
				  CreatedDate ,
				  IdUser ,
				  Deleted,
				  EditedDate
				)
		VALUES  ( @Description , -- Description - varchar(50)
				  GETUTCDATE() , -- CreatedDate - datetime
				  @IdUser , -- IdUser - int
				  0,  -- Deleted - bit
				  GETUTCDATE()
				)

		SELECT @Id = SCOPE_IDENTITY()
	END
	
END
