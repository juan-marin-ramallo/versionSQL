/****** Object:  Procedure [dbo].[SaveOrUpdateProduct]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SaveOrUpdateProduct]
    @Id [sys].[int] OUTPUT,
	@Name varchar(50), 
	@Identifier varchar(50) = null,
    @BarCode varchar(100)
	
AS 
BEGIN
    SET NOCOUNT ON;
	
    SELECT	@Id = [Id]
    FROM	dbo.Product
    WHERE	BarCode=@BarCode And Deleted = 0

	IF @Id IS NULL
	 Begin
	   INSERT INTO dbo.Product (Name, Identifier, BarCode, ImageArray, Deleted)
	   VALUES (@Name, @Identifier, @BarCode, null,0)
	   SELECT @Id = SCOPE_IDENTITY()
	 End
	Else 
	BEGIN
		UPDATE	dbo.Product
		SET		Name = @Name
				,Identifier = @Identifier
				,BarCode = @BarCode
		WHERE	Id = @Id
	END
END	
