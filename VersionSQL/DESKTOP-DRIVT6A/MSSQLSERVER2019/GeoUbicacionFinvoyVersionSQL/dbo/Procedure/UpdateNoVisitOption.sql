/****** Object:  Procedure [dbo].[UpdateNoVisitOption]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 05/08/2016
-- Description:	SP para actualizar un motivo de no visita
-- =============================================
CREATE PROCEDURE [dbo].[UpdateNoVisitOption]
(
	 @Id [sys].[int]
	,@Description [sys].[varchar](50)
)
AS
BEGIN

	--RouteNoVisitOption Description Duplicated
	IF EXISTS (SELECT 1 FROM RouteNoVisitOption WITH (NOLOCK) WHERE [Description] = @Description AND Deleted = 0 AND @Id != Id) SELECT -1 AS Id;

	ELSE
	BEGIN 
		UPDATE	[dbo].[RouteNoVisitOption]
		
		SET		 [Description] = @Description,
				 [EditedDate] = GETUTCDATE()
		
		WHERE	 [Id] = @Id

		SELECT @Id as Id;
	END

END
