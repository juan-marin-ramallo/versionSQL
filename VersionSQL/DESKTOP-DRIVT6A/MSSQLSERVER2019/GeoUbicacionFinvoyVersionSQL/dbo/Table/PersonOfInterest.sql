/****** Object:  Table [dbo].[PersonOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PersonOfInterest](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NOT NULL,
	[Identifier] [varchar](20) NULL,
	[MobilePhoneNumber] [varchar](20) NULL,
	[MobileIMEI] [varchar](40) NOT NULL,
	[Status] [char](1) NOT NULL,
	[Type] [char](1) NULL,
	[IdDepartment] [int] NULL,
	[Deleted] [bit] NOT NULL,
	[Pending] [bit] NOT NULL,
	[DeviceId] [varchar](300) NULL,
	[Pin] [varchar](4) NULL,
	[PinDate] [datetime] NULL,
	[Avatar] [varbinary](max) NULL,
	[Email] [varchar](255) NULL,
	[DeviceBrand] [varchar](50) NULL,
	[DeviceModel] [varchar](50) NULL,
	[AndroidVersion] [varchar](50) NULL,
 CONSTRAINT [PK_Stocker] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[PersonOfInterest]  WITH NOCHECK ADD  CONSTRAINT [FK_PersonOfInterest_Department] FOREIGN KEY([IdDepartment])
REFERENCES [dbo].[Department] ([Id])
ALTER TABLE [dbo].[PersonOfInterest] CHECK CONSTRAINT [FK_PersonOfInterest_Department]
ALTER TABLE [dbo].[PersonOfInterest]  WITH CHECK ADD  CONSTRAINT [FK_PersonOfInterest_PersonOfInterestType] FOREIGN KEY([Type])
REFERENCES [dbo].[PersonOfInterestType] ([Code])
ALTER TABLE [dbo].[PersonOfInterest] CHECK CONSTRAINT [FK_PersonOfInterest_PersonOfInterestType]
