/****** Object:  Table [dbo].[CustomAttributeOption]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[CustomAttributeOption](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdCustomAttribute] [int] NOT NULL,
	[Text] [varchar](100) NOT NULL,
	[IsDefault] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_CustomAttributeOption] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CustomAttributeOption] ADD  CONSTRAINT [DF_CustomAttributeOption_IsDefault]  DEFAULT ((0)) FOR [IsDefault]
ALTER TABLE [dbo].[CustomAttributeOption] ADD  CONSTRAINT [DF_CustomAttributeOption_Deleted]  DEFAULT ((0)) FOR [Deleted]
