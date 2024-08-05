/****** Object:  Table [dbo].[PowerPointStyle]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PowerPointStyle](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[FontFamily] [varchar](50) NULL,
	[BackgroundColor] [varchar](10) NULL,
	[BackgroundImageName] [varchar](100) NULL,
	[BackgroundImageUrl] [varchar](2000) NULL,
	[FooterBackgroundColor] [varchar](10) NULL,
	[FooterLeftImageName] [varchar](100) NULL,
	[FooterLeftImageUrl] [varchar](2000) NULL,
	[FooterRightImageName] [varchar](100) NULL,
	[FooterRightImageUrl] [varchar](2000) NULL,
	[TitleBackgroundColor] [varchar](10) NULL,
	[TitleFontColor] [varchar](10) NULL,
	[TitleFontSize] [smallint] NULL,
	[SubtitleBackgroundColor] [varchar](10) NULL,
	[SubtitleFontColor] [varchar](10) NULL,
	[SubtitleFontSize] [smallint] NULL,
	[HeaderBackgroundColor] [varchar](10) NULL,
	[HeaderFontColor] [varchar](10) NULL,
	[HeaderFontSize] [smallint] NULL,
	[Deleted] [bit] NOT NULL,
	[DeletedDate] [datetime] NULL,
 CONSTRAINT [PK_PowerPointStyle] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
