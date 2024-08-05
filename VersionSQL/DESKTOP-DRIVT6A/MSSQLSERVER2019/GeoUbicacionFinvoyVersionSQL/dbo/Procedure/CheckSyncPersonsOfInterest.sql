/****** Object:  Procedure [dbo].[CheckSyncPersonsOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 24/09/2018
-- Description:	SP para sincronizar lAS PERSONAS DE INTERES
-- =============================================
CREATE PROCEDURE [dbo].[CheckSyncPersonsOfInterest]
(
	 @SyncType [int]
	,@Data [PersonOfInterestTableType] READONLY
)
AS
BEGIN
	SET ANSI_WARNINGS  OFF;
	DECLARE @Add [int] = 0
	DECLARE @AddUpdate [int] = 1
	DECLARE @AddUpdateDelete [int] = 2
	DECLARE @MaxPICount [int] = (SELECT TOP 1 [Value] FROM dbo.PackageConfiguration where Id = 1)
	DECLARE @UsedPICount [int] = (SELECT COUNT(1) FROM dbo.AvailablePersonOfInterest)

	-- Update ingresados
	IF @SyncType <= @AddUpdate
	BEGIN
		SELECT	IIF(COUNT(P.[Id]) + @UsedPICount <= @MaxPICount, 1, 0) as CanInsert
		
		FROM    @Data P
			LEFT OUTER JOIN [PersonOfInterest] as PR ON 
				(PR.[Identifier] = P.[Id] OR PR.[MobileIMEI] = P.[MobileIMEI] OR PR.[MobilePhoneNumber] = P.[MobilePhoneNumber]) --NINGUNO DE LOS 3 SE PUEDE REPETIR
				AND PR.[Deleted] = 0				
			LEFT OUTER JOIN [dbo].[Department] D ON D.[Id] = P.[ProvinceId]
			INNER JOIN [dbo].[PersonOfInterestType] PT ON PT.[Code] = P.[ProfileCode]
		WHERE   PR.[Id] IS NULL AND
				(P.[ProvinceId] IS NULL OR D.[Id] IS NOT NULL) 
	END
	
	-- Delete faltantes
	IF @SyncType = @AddUpdateDelete
	BEGIN	
		SELECT	IIF(COUNT(P.[Id]) <= @MaxPICount, 1, 0) as CanInsert
		FROM    @Data P
			LEFT OUTER JOIN [dbo].[Department] D ON D.[Id] = P.[ProvinceId]
			INNER JOIN [dbo].[PersonOfInterestType] PT ON PT.[Code] = P.[ProfileCode]
		WHERE   P.[ProvinceId] IS NULL OR D.[Id] IS NOT NULL
	END

	SET ANSI_WARNINGS  ON;
END
