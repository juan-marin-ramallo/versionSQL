/****** Object:  View [dbo].[Tag]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE   VIEW [dbo].[Tag] 
AS SELECT        Id, Name, Deleted, CreatedDate, IdUser
FROM            dbo.Parameter
WHERE        (IdType = 6)
