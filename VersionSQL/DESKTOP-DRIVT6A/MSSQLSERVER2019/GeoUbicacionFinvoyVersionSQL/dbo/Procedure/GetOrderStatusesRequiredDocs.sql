/****** Object:  Procedure [dbo].[GetOrderStatusesRequiredDocs]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:        jgil
-- Create date: 15/08/23
-- Description:    
-- =============================================
CREATE PROCEDURE [dbo].[GetOrderStatusesRequiredDocs] 
    -- Add the parameters for the stored procedure here
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT OSD.[Id], OSD.[IdStatus], OSD.[IdType]
    FROM [OrderStatusDocument] OSD
 END
