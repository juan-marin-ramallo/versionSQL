/****** Object:  Procedure [dbo].[SaveMeeting]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SaveMeeting]
    @Id [sys].[INT] OUTPUT ,
    @IdUser [sys].[INT] ,
    @StartDate [sys].[DATETIME] ,
    @EndDate [sys].[DATETIME] = NULL,
    @Subject [sys].NVARCHAR(50) ,
	@Description [sys].NVARCHAR(MAX),
    @Guests [sys].NVARCHAR(MAX),
	@IsFixed [sys].[BIT]
AS
    BEGIN

        BEGIN 
            INSERT  INTO [dbo].Meeting
                    ( [Subject],
					[Description],
                      [Start],
                      [End],
                      UserId,
                      ActualStart,
                      ActualEnd,
                      [Minute],
                      Deleted,
                      CreatedDate,
					  Synced,
					  SyncType,
					  IsFixed
                    )
                    SELECT  @Subject,
							@Description,
                            @StartDate,
                            @EndDate,
                            @IdUser,
                            NULL,
                            NULL,
                            NULL,
                            0,
                            GETUTCDATE(),
							0,
							1,
							@IsFixed; -- Outlook Event

            SELECT  @Id = SCOPE_IDENTITY();


            INSERT  INTO dbo.MeetingGuest
                    ( MeetingId ,
                      UserId ,
                      Attended ,
                      CanEdit ,
                      Deleted ,
                      CreatedDate
			        )
                    SELECT  @Id ,
                            U.[Id] ,
                            NULL ,
                            0 ,
                            0 ,
                            GETUTCDATE()
                    FROM    dbo.[User] U
                    WHERE   dbo.CheckValueInList(U.[Id], @Guests) > 0;

        END;
    END;
