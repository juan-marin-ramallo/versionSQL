/****** Object:  Table [dbo].[CompletedForm]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[CompletedForm](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdForm] [int] NOT NULL,
	[IdPersonOfInterest] [int] NOT NULL,
	[IdPointOfInterest] [int] NULL,
	[Latitude] [decimal](25, 20) NULL,
	[Longitude] [decimal](25, 20) NULL,
	[LatLong] [geography] NULL,
	[Date] [datetime] NOT NULL,
	[ReceivedDate] [datetime] NULL,
	[StartDate] [datetime] NULL,
	[InitLatitude] [decimal](25, 20) NULL,
	[InitLongitude] [decimal](25, 20) NULL,
	[CompletedFromWeb] [bit] NULL,
	[IdProduct] [int] NULL,
 CONSTRAINT [PK_CompletedForm] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

CREATE NONCLUSTERED INDEX [NCL_IX_CompletedForm_IdForm] ON [dbo].[CompletedForm]
(
	[IdForm] ASC
)
INCLUDE([Date],[IdPersonOfInterest],[IdPointOfInterest],[StartDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [NCL_IX_CompletedForm_IdPersonOfInterest] ON [dbo].[CompletedForm]
(
	[IdPersonOfInterest] ASC
)
INCLUDE([Date],[IdForm],[IdPointOfInterest],[Latitude],[Longitude]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[CompletedForm] ADD  CONSTRAINT [DF_CompletedForm_CompletedFromWeb]  DEFAULT ((0)) FOR [CompletedFromWeb]
ALTER TABLE [dbo].[CompletedForm]  WITH CHECK ADD  CONSTRAINT [FK_CompletedForm_Form] FOREIGN KEY([IdForm])
REFERENCES [dbo].[Form] ([Id])
ALTER TABLE [dbo].[CompletedForm] CHECK CONSTRAINT [FK_CompletedForm_Form]
ALTER TABLE [dbo].[CompletedForm]  WITH CHECK ADD  CONSTRAINT [FK_CompletedForm_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[CompletedForm] CHECK CONSTRAINT [FK_CompletedForm_PersonOfInterest]
ALTER TABLE [dbo].[CompletedForm]  WITH CHECK ADD  CONSTRAINT [FK_CompletedForm_PointOfInterest] FOREIGN KEY([IdPointOfInterest])
REFERENCES [dbo].[PointOfInterest] ([Id])
ALTER TABLE [dbo].[CompletedForm] CHECK CONSTRAINT [FK_CompletedForm_PointOfInterest]
