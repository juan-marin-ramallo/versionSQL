/****** Object:  Procedure [dbo].[GetProductsImagesFilteredById]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetProductsImagesFilteredById]
 
	@Ids varchar(max) = null
	 
AS 

    SET NOCOUNT ON;
    SELECT Id, ImageArray
    FROM dbo.Product
    WHERE ((@Ids is null) OR dbo.CheckVarcharInList (Id, @Ids)=1)  AND
		  Deleted=0
	
