/****** Object:  Procedure [dbo].[SaveCustomAttribute]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  <John Doe>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[SaveCustomAttribute]  
  @Id int OUTPUT  
 ,@Name varchar(100)  
 ,@IdValueType int  
 ,@DefaultValue varchar(MAX) = ''  
 ,@IsObligatory BIT = 0
 ,@IsVisible BIT = 0
 ,@Options [dbo].[OptionTableType] readonly
 ,@IdUser int  
AS  
BEGIN  
	DECLARE @Now [sys].[datetime]  
	SET @Now = GETUTCDATE()  
  
	IF EXISTS (SELECT 1 FROM  [dbo].[CustomAttribute] WITH (NOLOCK) WHERE [Name] = @Name AND [Deleted] = 0)   
		SELECT -1 AS Id;    
	ELSE BEGIN    
		DECLARE @IdCustomAttribute varchar(100) = (SELECT [Id] FROM  [dbo].[CustomAttribute] WITH (NOLOCK) WHERE [Name] = @Name)
  
		IF (@IdCustomAttribute IS NOT NULL) BEGIN   
			UPDATE  [dbo].[CustomAttribute]  
			SET [Deleted] = 0  
				,[IdValueType] = @IdValueType  
				,[DefaultValue] = @DefaultValue  
				,[IdUser] = @IdUser  
				,[CreatedDate] = @Now  
				,[IsObligatory] = @IsObligatory
				,[IsVisible] = @IsVisible
			WHERE [Id] = @IdCustomAttribute  
  
			SELECT @Id = @IdCustomAttribute  

   			-- delete options not in list
			UPDATE cao
			SET cao.Deleted = 1
			FROM CustomAttributeOption cao
				LEFT OUTER JOIN @Options o on cao.Id = o.Id
			WHERE cao.IdCustomAttribute = @Id AND o.Id IS NULL

			INSERT INTO [dbo].[CustomAttributeOption]([IdCustomAttribute], [Text], [IsDefault])
			SELECT @Id, o.[Text], o.[IsDefault]
			FROM @Options o
			WHERE o.Id IS NULL
  
			UPDATE  [dbo].[FormReportFormatOptions]  
			SET  [Name] = @Name, [Deleted] = 0  
			WHERE [IdCustomAttribute] = @IdCustomAttribute  
  
			UPDATE  [dbo].[Field]  
			SET  [Name] = @Name, [Deleted] = 0  
			WHERE [IdCustomAttribute] = @IdCustomAttribute  
  
		END ELSE BEGIN  
			INSERT INTO  [dbo].[CustomAttribute] ([Name], [IdValueType], [DefaultValue], [IdUser], [CreatedDate], [IsObligatory], [IsVisible])  
			VALUES (@Name, @IdValueType, @DefaultValue, @IdUser, @Now, @IsObligatory, @IsVisible)  
    
			SET @Id = SCOPE_IDENTITY()  

			INSERT INTO [dbo].[CustomAttributeOption]([IdCustomAttribute], [Text], [IsDefault])
			SELECT @Id, o.[Text], o.[IsDefault]
			FROM @Options o
  
			INSERT INTO [dbo].[FormReportFormatOptions]([Name], [IdCustomAttribute])  
			VALUES (@Name, @Id)  
  
			INSERT INTO [dbo].[Field]([Name], [IdFieldGroup], [Order], [IdCustomAttribute])  
			VALUES (@Name, 3, 100, @Id)    
		END  
	END  
END
