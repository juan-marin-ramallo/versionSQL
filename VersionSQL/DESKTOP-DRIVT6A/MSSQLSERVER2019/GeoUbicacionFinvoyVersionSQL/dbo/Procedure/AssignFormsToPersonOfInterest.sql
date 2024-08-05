/****** Object:  Procedure [dbo].[AssignFormsToPersonOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 02/02/2016
-- Description:	SP para ASIGNAR TODOS LOS FORMULARIOS QUE CORRESPONDAN A UNA PERSONA DE INTERES NUEVA
-- =============================================
CREATE PROCEDURE [dbo].[AssignFormsToPersonOfInterest]
 
	 @IdPersonOfInterest [sys].INT = NULL
	,@IdUser [sys].[INT] = NULL
AS
BEGIN
	DECLARE @Now [sys].[datetime]
    SET @Now = GETUTCDATE()

	DECLARE @IdAux  AS INT
	DECLARE @BitAux AS BIT
	DECLARE @NonPointAux AS BIT
	
	DECLARE cur CURSOR FOR SELECT F.[Id], F.[AllPointOfInterest], F.[NonPointOfInterest]
	FROM 	dbo.Form F
	WHERE	F.[Deleted] = 0
			AND (Tzdb.IsLowerOrSameSystemDate(F.[StartDate], @Now) = 1
				AND Tzdb.IsGreaterOrSameSystemDate(F.[EndDate], @Now) = 1) --Tiene que ser un formulario activo
			AND F.[AllPersonOfInterest] = 1 -- Formulario hecho para todas las personas de interes.
	
    
	OPEN cur

	FETCH NEXT FROM cur INTO @IdAux, @BitAux, @NonPointAux

	WHILE @@FETCH_STATUS = 0 
	BEGIN
		IF @BitAux = 1 OR @NonPointAux = 1 --El formulario esta hecho para todos los puntos de venta o para ninguno
		BEGIN
			INSERT INTO [dbo].[AssignedForm]([IdForm], [IdPointOfInterest], [IdPersonOfInterest], [Date], [Deleted]) 
			VALUES (@IdAux, NULL, @IdPersonOfInterest, @Now, 0)
		END
		ELSE
		BEGIN
			INSERT INTO [dbo].[AssignedForm]([IdForm], [IdPointOfInterest], [IdPersonOfInterest], [Date], [Deleted])
			(SELECT @IdAux, AF.[IdPointOfInterest], @IdPersonOfInterest, @Now AS [Date], 0 AS [Deleted]
	 		FROM	[dbo].[AssignedForm] AF
	 				INNER JOIN [dbo].[PointOfInterest] POI ON POI.[Id] = AF.[IdPointOfInterest]
			WHERE	 AF.[Deleted] = 0 AND AF.[IdForm] = @IdAux AND 
					((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(POI.[Id], @IdUser) = 1)) AND
					((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUser) = 1))
			GROUP BY AF.[IdPointOfInterest])
		END
	
	FETCH NEXT FROM cur INTO @IdAux, @BitAux, @NonPointAux
	END

	CLOSE cur    
	DEALLOCATE cur

END
