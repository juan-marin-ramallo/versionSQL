/****** Object:  Procedure [dbo].[DeleteCompany]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		FS
-- Create date: 18/03/19
-- Description:	SP para eliminar una compania
-- =============================================
CREATE PROCEDURE [dbo].[DeleteCompany]
	 @Id [sys].[INT]
AS
BEGIN
	
	UPDATE [dbo].[Company]
    SET  [Deleted] = 1
	WHERE [Id] = @Id
	
	UPDATE [dbo].[ProductBrand]
    SET [Deleted] = 1
	WHERE [IdCompany] = @Id

	UPDATE P
	SET P.[IdProductBrand] = NULL
	FROM  [dbo].[Product] P 
		INNER JOIN [dbo].[ProductBrand] B ON P.IdProductBrand = B.Id
	WHERE B.[IdCompany] = @Id

	UPDATE [dbo].[Asset]
	SET [IdCompany] = NULL
	WHERE [IdCompany] = @Id
	
	UPDATE [dbo].[Form]
	SET [IdCompany] = NULL
	WHERE [IdCompany] = @Id
	
	UPDATE U
	SET U.[Status] = 'D'
	FROM dbo.[User]	u
		INNER JOIN (
		SELECT U2.Id
			FROM dbo.[User]	u2
			INNER JOIN dbo.[UserCompany] UC ON u2.[Id] = uc.[IdUser]
			INNER JOIN dbo.[UserCompany] UC2 ON u2.[Id] = uc2.[IdUser]
		WHERE U2.SuperAdmin = 0 AND u2.[Status] = 'H' AND uc.[IdCompany] = @Id
		GROUP BY u2.[Id]
		HAVING COUNT(uc2.IdUser) = 1
	) u3 ON u.Id = u3.Id
	WHERE U.SuperAdmin = 0 AND u.[Status] = 'H' 
	    
	DELETE dbo.[UserCompany]
	WHERE [IdCompany] = @Id

END
