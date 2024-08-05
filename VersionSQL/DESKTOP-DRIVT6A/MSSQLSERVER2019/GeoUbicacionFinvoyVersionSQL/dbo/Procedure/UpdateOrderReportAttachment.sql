/****** Object:  Procedure [dbo].[UpdateOrderReportAttachment]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  GL  
-- Create date: <Create Date,,>  
-- Description: GUARDA PEDIDOS ENVIADOS DESDE LA APP  
-- =============================================  
CREATE PROCEDURE [dbo].[UpdateOrderReportAttachment]  
  @Id [sys].[int]  
 ,@AttachmentUniqueName [sys].[varchar](256) = NULL  
 ,@AttachementUrl [sys].[varchar](2048) = NULL  
 ,@TypeId [sys].[int] = NULL  
 ,@Comment [sys].[varchar](250) = NULL  
 ,@Status [sys].[smallint] = NULL  
AS  
BEGIN   
 INSERT INTO [dbo].[OrderReportDocumentTrazability] VALUES(@Id, @TypeId, @Status, @Comment, @AttachmentUniqueName, @AttachementUrl)
END
