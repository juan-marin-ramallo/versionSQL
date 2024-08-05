/****** Object:  Procedure [dbo].[SaveOrderStatus]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================          
-- Author: Cristian Barbarini          
-- Create date: 16/08/2023          
-- Description: Guarda estado de pedidos          
-- =============================================          
CREATE PROCEDURE [dbo].[SaveOrderStatus]          
 @Id INT,          
 @Name VARCHAR(100),          
 @Description VARCHAR(100),          
 @Abbreviation VARCHAR(3),          
 @IsInitial BIT,          
 @IsFinal BIT,          
 @CanEdit BIT,          
 @NextStatuses IdTableType READONLY,          
 @Documents IdTableType READONLY,          
 @CanEditPrice BIT          
AS          
BEGIN          
          
 IF EXISTS(SELECT 1 FROM OrderStatus WHERE Id = @Id)          
 BEGIN          
  UPDATE OrderStatus SET [Name] = @Name, [Description] = @Description, [Abbreviation] = @Abbreviation,          
   [IsFinal] = @IsFinal, [IsInitial] = @IsInitial, [CanEdit] = @CanEdit, [CanEditPrice] = @CanEditPrice          
  WHERE Id = @Id          
          
  DELETE FROM OrderNextStatus WHERE IdStatus = @Id          
  DELETE FROM OrderStatusDocument WHERE IdStatus = @Id          
 END ELSE          
 BEGIN          
  INSERT INTO OrderStatus VALUES(@Name, @Description, @Abbreviation, @IsFinal, @IsInitial, @CanEdit, @CanEditPrice, 0)          
  SELECT @Id = SCOPE_IDENTITY()          
 END          
          
 INSERT INTO OrderNextStatus          
 SELECT @Id, ns.Id          
 FROM @NextStatuses ns          
          
 INSERT INTO OrderStatusDocument          
 SELECT @Id, ns.Id          
 FROM @Documents ns          
END
