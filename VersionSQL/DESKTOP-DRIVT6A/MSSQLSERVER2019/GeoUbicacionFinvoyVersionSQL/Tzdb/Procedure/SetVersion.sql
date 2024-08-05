/****** Object:  Procedure [Tzdb].[SetVersion]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [Tzdb].[SetVersion]
	@Version char(5)
AS
DELETE FROM [Tzdb].[VersionInfo]
INSERT INTO [Tzdb].[VersionInfo] ([Version],[Loaded]) VALUES (@Version, GETUTCDATE())
