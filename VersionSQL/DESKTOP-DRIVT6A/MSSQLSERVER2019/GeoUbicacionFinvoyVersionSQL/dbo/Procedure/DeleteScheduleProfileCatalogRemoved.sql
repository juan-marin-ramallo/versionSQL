/****** Object:  Procedure [dbo].[DeleteScheduleProfileCatalogRemoved]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  Juan Marin 
-- Create date: 20/01/2024  
-- Description: SP para eliminar los catalogos planificados que fueron removidos al editar un Cronograma
-- A su vez inserto/actualizo en la tabla ProductPointOfInterestChangeLog los puntos de interes asociados a estos catalogos eliminados para que el servicio
-- GetPoiDifference alerte a la app. Este se fija si hay una diferencia en asignacion y si no hay se envia la lista vacia.
-- =============================================  
CREATE PROCEDURE [dbo].[DeleteScheduleProfileCatalogRemoved]  
( 
  @IdScheduleProfile [sys].[int], 
  @IdScheduleProfileCatalogs [sys].[varchar](max) 
)  
AS  
BEGIN  
	--Veo si el cronograma tiene activa la opcion de AllPointOfInterest
	DECLARE @AllPointOfInterest [sys].BIT = (SELECT AllPointOfInterest FROM dbo.ScheduleProfile WHERE Id = @IdScheduleProfile)

	--Obtener los catalogos planificados que fueron eliminados
	SELECT	DISTINCT IdCatalog
	INTO	#ScheduleCatalogsDeleted
	FROM	[dbo].[ScheduleProfileCatalog]  WITH (NOLOCK)
	WHERE	[Deleted] = 0
	AND		IdScheduleProfile = @IdScheduleProfile
	AND		(dbo.CheckValueInList([Id], @IdScheduleProfileCatalogs) = 0)	

	--De los catalogos planificados que se van a eliminar debo obtener TODOS los puntos asociados a estos
	SELECT	DISTINCT IdPointOfInterest 
	INTO	#AllPointOfInterestForScheduleCatalogsDeleted
	FROM	dbo.CatalogPointOfInterest 
	WHERE	IdCatalog IN (SELECT IdCatalog FROM #ScheduleCatalogsDeleted)

	CREATE TABLE #PointOfInterestSelectedForChangeLog (
		IdPointOfInterest INT PRIMARY KEY
	)

	 IF @AllPointOfInterest = 1
		 BEGIN  
			--Guardo todos los IdPointOfInterest asociados a los catalogos a eliminar que fueron planificados en el cronograma
			INSERT INTO	#PointOfInterestSelectedForChangeLog
			SELECT	APOISC.IdPointOfInterest
			FROM	#AllPointOfInterestForScheduleCatalogsDeleted AS APOISC
		 END
	 ELSE
		 BEGIN  
			--Guardo los IdPointOfInterest asociados a los catalogos a eliminar que fueron planificados y que coinciden con los puntos de interes que el usuario seleccionó en el Cronograma de Actividades
			INSERT INTO	#PointOfInterestSelectedForChangeLog
			SELECT	APOISC.IdPointOfInterest		
			FROM	#AllPointOfInterestForScheduleCatalogsDeleted AS APOISC
			INNER JOIN
					dbo.ScheduleProfileAssignation AS SPA WITH(NOLOCK) ON SPA.IdPointOfInterest = APOISC.IdPointOfInterest AND SPA.IdScheduleProfile = @IdScheduleProfile
		 END

	--Hago un merge en la tabla ProductPointOfInterestChangeLog con los IdPointOfInterest seleccionados de los catalogos planificados que se van a eliminar
	DECLARE @Today [sys].[DATETIME]
	SET @Today = GETUTCDATE()

	MERGE dbo.ProductPointOfInterestChangeLog T
	USING #PointOfInterestSelectedForChangeLog S
	ON (S.IdPointOfInterest = T.IdPointOfInterest)
	WHEN MATCHED
		THEN UPDATE SET
			T.LastUpdatedDate = @Today 
	WHEN NOT MATCHED BY TARGET 
		THEN INSERT (IdPointOfInterest, LastUpdatedDate)
			 VALUES (S.IdPointOfInterest,@Today);

	--Elimino las tablas temporales usadas
	DROP TABLE #ScheduleCatalogsDeleted
	DROP TABLE #AllPointOfInterestForScheduleCatalogsDeleted
	DROP TABLE #PointOfInterestSelectedForChangeLog



	--Marco como eliminado a los catalogos planificados que fueron removidos al editar un Cronograma 
	UPDATE [dbo].[ScheduleProfileCatalog]  
	SET  [Deleted] = 1  
	WHERE [Deleted] = 0
	AND IdScheduleProfile = @IdScheduleProfile
	AND (dbo.CheckValueInList([Id], @IdScheduleProfileCatalogs) = 0)	

	RETURN @@ROWCOUNT  
END
