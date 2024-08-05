/****** Object:  Table [dbo].[Form]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[Form](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NULL,
	[IdUser] [int] NULL,
	[Name] [varchar](100) NOT NULL,
	[Deleted] [bit] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[IdFormCategory] [int] NULL,
	[AllPointOfInterest] [bit] NULL,
	[AllPersonOfInterest] [bit] NULL,
	[NonPointOfInterest] [bit] NULL,
	[Description] [varchar](1000) NULL,
	[OneTimeAnswer] [bit] NOT NULL,
	[IsWeighted] [bit] NOT NULL,
	[AllowWebComplete] [bit] NOT NULL,
	[IdCompany] [int] NULL,
	[IdFormType] [int] NULL,
	[CompleteMultipleTimes] [bit] NOT NULL,
	[EditedDate] [datetime] NULL,
	[IsFormPlus] [bit] NOT NULL,
 CONSTRAINT [PK_Form] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Form] ADD  CONSTRAINT [DF_Form_OneTimeAnswer]  DEFAULT ((0)) FOR [OneTimeAnswer]
ALTER TABLE [dbo].[Form] ADD  CONSTRAINT [DF_Form_IsWeighted]  DEFAULT ((0)) FOR [IsWeighted]
ALTER TABLE [dbo].[Form] ADD  CONSTRAINT [DF_Form_AllowWebComplete]  DEFAULT ((1)) FOR [AllowWebComplete]
ALTER TABLE [dbo].[Form] ADD  CONSTRAINT [DF_Form_CompleteMultipleTimes]  DEFAULT ((0)) FOR [CompleteMultipleTimes]
ALTER TABLE [dbo].[Form] ADD  CONSTRAINT [DF_Form_IsFormPlus]  DEFAULT ((0)) FOR [IsFormPlus]
ALTER TABLE [dbo].[Form]  WITH CHECK ADD  CONSTRAINT [FK_Form_Company] FOREIGN KEY([IdCompany])
REFERENCES [dbo].[Company] ([Id])
ALTER TABLE [dbo].[Form] CHECK CONSTRAINT [FK_Form_Company]
ALTER TABLE [dbo].[Form]  WITH CHECK ADD  CONSTRAINT [FK_Form_FormCategory] FOREIGN KEY([IdFormCategory])
REFERENCES [dbo].[FormCategory] ([Id])
ALTER TABLE [dbo].[Form] CHECK CONSTRAINT [FK_Form_FormCategory]
ALTER TABLE [dbo].[Form]  WITH CHECK ADD  CONSTRAINT [FK_Form_Parameter] FOREIGN KEY([IdFormType])
REFERENCES [dbo].[Parameter] ([Id])
ALTER TABLE [dbo].[Form] CHECK CONSTRAINT [FK_Form_Parameter]
ALTER TABLE [dbo].[Form]  WITH CHECK ADD  CONSTRAINT [FK_Form_User] FOREIGN KEY([IdUser])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[Form] CHECK CONSTRAINT [FK_Form_User]
