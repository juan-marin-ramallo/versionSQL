/****** Object:  Procedure [dbo].[GetIncidentById]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: <Create Date,,>
-- Description:	Obtener incidente/observacion segun id
-- =============================================
CREATE PROCEDURE [dbo].[GetIncidentById]
	 @IdIncident int
AS
BEGIN
	
	SELECT		I.[Id], I.[Description], I.[CreatedDate],I.[ImageEncoded], I.[ImageEncoded2], I.[ImageEncoded3],
            IIF ( I.[ImageUrl] IS NOT NULL, 1, IIF ( I.[ImageEncoded] IS NOT NULL, 1, 0 ) ) AS HasImage1,
      			IIF ( I.[ImageUrl2] IS NOT NULL, 1, IIF ( I.[ImageEncoded2] IS NOT NULL, 1, 0 ) ) AS HasImage2,
            IIF ( I.[ImageUrl3] IS NOT NULL, 1, IIF ( I.[ImageEncoded3] IS NOT NULL, 1, 0 ) ) AS HasImage3,
            I.[ImageUrl], I.[ImageUrl2], I.[ImageUrl3]
	
	FROM		[dbo].[Incident] I
	INNER JOIN	[dbo].[IncidentType] T ON T.[Id] = I.[IdIncidentType]
	
	WHERE		I.[Id] = @IdIncident

END
