/****** Object:  Procedure [dbo].[UpdateMeetingMinute]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[UpdateMeetingMinute]
    @Id INT ,
    @Minute NVARCHAR(MAX) ,
    @MinuteFileName [sys].[VARCHAR](100) = NULL ,
    @MinuteRealFileName [sys].[VARCHAR](100) = NULL ,
    @MinuteFileEncoded [sys].[VARBINARY](MAX) = NULL ,
    @SignaturesFileName [sys].[VARCHAR](100) = NULL ,
    @SignaturesRealFileName [sys].[VARCHAR](100) = NULL ,
    @SignaturesFileEncoded [sys].[VARBINARY](MAX) = NULL
AS
    BEGIN
        SET NOCOUNT ON;
        UPDATE  [dbo].[Meeting]
        SET     [Minute] = @Minute
        WHERE   [Id] = @Id;

        UPDATE  [dbo].[Meeting]
        SET     MinuteFileName = @MinuteFileName ,
                MinuteRealFileName = @MinuteRealFileName ,
                MinuteFileEncoded = @MinuteFileEncoded
        WHERE   [Id] = @Id
                AND ( ( MinuteFileName IS NULL
                        AND @MinuteFileName IS NOT NULL
                      )
                      OR ( MinuteFileName != @MinuteFileName )
                    );

        UPDATE  [dbo].[Meeting]
        SET     SignaturesFileName = @SignaturesFileName ,
                SignaturesRealFileName = @SignaturesRealFileName ,
                SignaturesFileEncoded = @SignaturesFileEncoded
        WHERE   [Id] = @Id
                AND ( ( SignaturesFileName IS NULL
                        AND @SignaturesFileName IS NOT NULL
                      )
                      OR ( SignaturesFileName != @SignaturesFileName )
                    );
    END;
