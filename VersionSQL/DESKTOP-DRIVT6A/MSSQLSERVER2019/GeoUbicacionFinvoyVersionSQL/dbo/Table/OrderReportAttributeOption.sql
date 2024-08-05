/****** Object:  Table [dbo].[OrderReportAttributeOption]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[OrderReportAttributeOption](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdOrderReportAttribute] [int] NOT NULL,
	[Text] [varchar](100) NOT NULL,
	[IsDefault] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_OrderReportAttributeOption] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[OrderReportAttributeOption] ADD  CONSTRAINT [DF_OrderReportAttributeOption_Default]  DEFAULT ((0)) FOR [IsDefault]
ALTER TABLE [dbo].[OrderReportAttributeOption] ADD  CONSTRAINT [DF_OrderReportAttributeOption_Deleted]  DEFAULT ((0)) FOR [Deleted]
