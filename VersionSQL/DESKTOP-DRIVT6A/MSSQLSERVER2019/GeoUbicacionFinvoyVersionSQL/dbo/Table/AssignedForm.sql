/****** Object:  Table [dbo].[AssignedForm]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[AssignedForm](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdForm] [int] NOT NULL,
	[IdPointOfInterest] [int] NULL,
	[Date] [datetime] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[IdPersonOfInterest] [int] NULL,
 CONSTRAINT [PK_AssignedForm] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [NCL_IX_AssignedForm_Deleted] ON [dbo].[AssignedForm]
(
	[Deleted] ASC
)
INCLUDE([IdForm],[IdPointOfInterest]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [NCL_IX_AssignedForm_IdForm_Deleted] ON [dbo].[AssignedForm]
(
	[IdForm] ASC,
	[Deleted] ASC
)
INCLUDE([IdPersonOfInterest],[IdPointOfInterest]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[AssignedForm]  WITH CHECK ADD  CONSTRAINT [FK_AssignedForm_Form] FOREIGN KEY([IdForm])
REFERENCES [dbo].[Form] ([Id])
ALTER TABLE [dbo].[AssignedForm] CHECK CONSTRAINT [FK_AssignedForm_Form]
ALTER TABLE [dbo].[AssignedForm]  WITH CHECK ADD  CONSTRAINT [FK_AssignedForm_IdPersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[AssignedForm] CHECK CONSTRAINT [FK_AssignedForm_IdPersonOfInterest]
ALTER TABLE [dbo].[AssignedForm]  WITH CHECK ADD  CONSTRAINT [FK_AssignedForm_PointOfInterest] FOREIGN KEY([IdPointOfInterest])
REFERENCES [dbo].[PointOfInterest] ([Id])
ALTER TABLE [dbo].[AssignedForm] CHECK CONSTRAINT [FK_AssignedForm_PointOfInterest]
