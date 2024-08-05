/****** Object:  Procedure [dbo].[InsertTimedNotification]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: NR
-- Create date: 12/07/2019
-- Description:	SP para dar de alta una nueva notificacion con timer en el sistema
-- =============================================
CREATE PROCEDURE [dbo].[InsertTimedNotification] (
	-- Add the parameters for the stored procedure here
	@NameConfiguration [sys].[VARCHAR](100),
	@DescriptionConfiguration [sys].[VARCHAR](250),
	@DescriptionConfigurationEN [sys].[VARCHAR](250),
	@ValueConfiguration [sys].[VARCHAR](250),

	@TemplateNotification [sys].[VARCHAR](100),
	@TemplateExcelNotification [sys].[VARCHAR](100),
	@NameNotification [sys].[VARCHAR](50),
	@SubjectNotification [sys].[VARCHAR](100),
	@DescriptionNotification [sys].[VARCHAR](500),
	@NameNotificationEn [sys].[VARCHAR](50),
	@SubjectNotificationEn [sys].[VARCHAR](100),
	@DescriptionNotificationEn [sys].[VARCHAR](500)
)
AS
BEGIN​
	Declare @IdConfig [sys].[INT]
    DECLARE @IdConfigGroup [sys].[INT] = 4
	DECLARE @OrderConfiguration [sys].[INT] = (SELECT (MAX([Order]) + 1) FROM dbo.[Configuration] WHERE IdConfigurationGroup = @IdConfigGroup)
	DECLARE @CodeNotification [sys].[INT] = (SELECT (MAX([Code]) + 1) FROM dbo.[Notification])
​
	--Agrego la configuracion
	INSERT INTO [dbo].[Configuration]
           ([Name]
           ,[Description]
           ,[Value]
           ,[DescriptionPT]
           ,[Visible]
           ,[Order]
           ,[IdConfigurationGroup]
           ,[Type])
     VALUES
           (@NameConfiguration
           ,@DescriptionConfiguration
           ,@ValueConfiguration --'14:00'
           ,''
           ,1
           ,@OrderConfiguration
           ,@IdConfigGroup
           ,3)
​
	set @IdConfig = SCOPE_IDENTITY();

	INSERT INTO Dbo.ConfigurationTranslation(IdConfiguration,IdLanguage,[Description])
	VALUES(@IdConfig,
	    1, -- 1esp, 2eng
	    @DescriptionConfiguration)

	INSERT INTO Dbo.ConfigurationTranslation(IdConfiguration,IdLanguage,[Description])
	VALUES(@IdConfig,
	    2, -- 1esp, 2eng
	    @DescriptionConfigurationEn)
​
​
	--Agrego Notification
	INSERT INTO [dbo].[Notification]([Code],[Name],[Subject],[Description],[Template], [TemplateExcel])
     VALUES
           (@CodeNotification
           ,@NameNotification
           ,@SubjectNotification
		   ,@DescriptionNotification,
		   @TemplateNotification,
		   @TemplateExcelNotification)

	INSERT INTO dbo.NotificationTranslation(CodeNotification,IdLanguage,Name,Subject,Description)
	VALUES (@CodeNotification, 
		1, --1esp 2eng
	    @NameNotification,@SubjectNotification, @DescriptionNotification)

	INSERT INTO dbo.NotificationTranslation(CodeNotification,IdLanguage,Name,Subject,Description)
	VALUES (@CodeNotification, 
		2, --1esp 2eng
	    @NameNotificationEn,@SubjectNotificationEn, @DescriptionNotificationEn)

END
