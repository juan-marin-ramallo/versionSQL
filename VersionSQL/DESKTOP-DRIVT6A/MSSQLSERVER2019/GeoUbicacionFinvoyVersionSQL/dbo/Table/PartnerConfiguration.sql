/****** Object:  Table [dbo].[PartnerConfiguration]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PartnerConfiguration](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[UrlWeb] [varchar](100) NULL,
	[ImageName] [varchar](100) NULL,
	[ImageEncoded] [varbinary](max) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_PartnerConfiguration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
