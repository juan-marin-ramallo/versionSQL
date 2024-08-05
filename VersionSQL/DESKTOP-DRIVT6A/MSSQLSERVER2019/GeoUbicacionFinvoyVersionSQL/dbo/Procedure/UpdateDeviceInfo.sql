/****** Object:  Procedure [dbo].[UpdateDeviceInfo]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		FS
-- Create date: 05/03/20
-- Description:	SP para actualizar la info del dispositivo de un repositor
-- =============================================
CREATE PROCEDURE [dbo].[UpdateDeviceInfo]
(
	 @Id [sys].[int]
	,@DeviceBrand [sys].[varchar](50)
	,@DeviceModel [sys].[varchar](50)
	,@AndroidVersion [sys].[varchar](50)
)
AS
BEGIN
	
	UPDATE	[dbo].[PersonOfInterest]
	SET		 [DeviceBrand] = @DeviceBrand
			,[DeviceModel] = @DeviceModel
			,[AndroidVersion] = @AndroidVersion
	WHERE	[Id] = @Id
	
END
