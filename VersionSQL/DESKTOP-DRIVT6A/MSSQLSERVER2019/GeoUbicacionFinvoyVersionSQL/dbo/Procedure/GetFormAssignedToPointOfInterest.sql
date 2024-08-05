/****** Object:  Procedure [dbo].[GetFormAssignedToPointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Diego Cáceres
-- Create date: 06/10/2014
-- Description:	SP para obtener el formulario asociado a un Punto de interes
-- =============================================
CREATE PROCEDURE [dbo].[GetFormAssignedToPointOfInterest]
	@IdPointOfInterest	[sys].[int],
	@ResultCode			[sys].[smallint] out
AS
BEGIN	
	
	IF EXISTS (SELECT 1 FROM [dbo].[PointOfInterest] WITH(NOLOCK) WHERE [Deleted] = 0)
	BEGIN
		SELECT TOP (1) AF.[IdForm]
		FROM [dbo].[AssignedForm] AF WITH(NOLOCK)
		INNER JOIN [dbo].[Form] F WITH(NOLOCK) ON AF.[IdForm] = F.[Id]
		WHERE AF.[IdPointOfInterest] = @IdPointOfInterest AND AF.[Deleted] = 0 AND F.[Deleted] = 0
		ORDER BY AF.[DATE] desc
	END
	ELSE
	BEGIN
		SET @ResultCode = -1;
	END
END
