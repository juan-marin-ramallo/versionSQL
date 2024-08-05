/****** Object:  Procedure [dbo].[UpdateCustomAttribute]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:<John Doe>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateCustomAttribute]
	  @Id INT
	, @Name VARCHAR(100)
	, @IdValueType INT
	, @DefaultValue VARCHAR(MAX) = ''
	, @IsObligatory BIT = 0
	, @IsVisible BIT = 0
	, @Options [dbo].[OptionTableType] readonly
AS
BEGIN
	IF EXISTS (SELECT 1 FROM CustomAttribute WHERE Name = @Name AND Deleted = 0 AND @Id <> Id) 
		SELECT -1 AS Id;

	ELSE BEGIN
		UPDATE CustomAttribute
		SET Name = @Name, IdValueType = @IdValueType, DefaultValue = @DefaultValue, IsObligatory = @IsObligatory, IsVisible = @IsVisible
		WHERE Id = @Id

		UPDATE FormReportFormatOptions
		SET Name = @Name
		WHERE IdCustomAttribute = @Id

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

		SELECT @Id AS Id;
	END
END
