/****** Object:  Procedure [dbo].[SaveAuditLog]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveAuditLog]
(
	@IdUser [int],
	@Date [datetime],
	@Entity [int],
	@Action [int],
	@ControllerName [varchar](50),
	@ActionName [varchar](100),
	@RequestData [varchar](MAX) = NULL,
  @ResultData [varchar](MAX) = NULL
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO AuditLog ([IdUser],[Date],[Entity],[Action],[ControllerName],[ActionName],[RequestData],[ResultData])
	VALUES (@IdUser,@Date,@Entity,@Action,@ControllerName,@ActionName,@RequestData,@ResultData)

	SELECT SCOPE_IDENTITY()
	
END
