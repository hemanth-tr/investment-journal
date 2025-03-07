
CREATE TABLE [User]
(
	Id UNIQUEIDENTIFIER DEFAULT NEWID(),
	Username VARCHAR(30) UNIQUE NOT NULL,
	Fullname VARCHAR(100) NOT NULL,
	Birthdate DATE NOT NULL,
	Email VARCHAR(100) NOT NULL,
	Phone VARCHAR(10),
	CONSTRAINT User_PK_Id PRIMARY KEY (Id)
);

CREATE TABLE Trades (
	Id UNIQUEIDENTIFIER DEFAULT NEWID(),
	Stock VARCHAR(20) NOT NULL,
	Entryprice decimal NOT NULL,
	Exitprice decimal,
	Entrydatetime DATETIME DEFAULT CURRENT_TIMESTAMP,
	Exitdatetime DATETIME ,
	CONSTRAINT Trade_PK_Id PRIMARY KEY (Id)
);

CREATE TABLE Posts (
	Id UNIQUEIDENTIFIER DEFAULT NEWID(),
	Title VARCHAR(50) NOT NULL,
	Description VARCHAR(MAX) NOT NULL,
	CONSTRAINT Post_PK_Id PRIMARY KEY (Id)
);

CREATE TABLE AdminSettings (
	UserId UNIQUEIDENTIFIER NOT NULL,
	CanPost BIT DEFAULT 0,
	CanTrade BIT DEFAULT 0,
	CONSTRAINT AS_FK_UserId FOREIGN KEY (UserId) REFERENCES Users(Id)
);

CREATE TABLE UserSettings (
	UserId UNIQUEIDENTIFIER NOT NULL,
	IsTradesPublic BIT DEFAULT 0,
	CONSTRAINT US_FK_UserId FOREIGN KEY (UserId) REFERENCES Users(Id)
);

CREATE TABLE UserTradeMap (
	TradeId UNIQUEIDENTIFIER NOT NULL,
	UserId UNIQUEIDENTIFIER NOT NULL,
	CONSTRAINT UTM_FK_TradeId FOREIGN KEY (TradeId) REFERENCES Trades(Id),
	CONSTRAINT UTM_FK_UserId FOREIGN KEY (UserId) REFERENCES Users(Id)
);

CREATE TABLE UserPostMap (
	PostId UNIQUEIDENTIFIER NOT NULL,
	UserId UNIQUEIDENTIFIER NOT NULL,
	CONSTRAINT UPM_FK_PostId FOREIGN KEY (PostId) REFERENCES Posts(Id),
	CONSTRAINT UPM_FK_UserId FOREIGN KEY (UserId) REFERENCES Users(Id)
);

CREATE TABLE TradeLikes (
	TradeId UNIQUEIDENTIFIER NOT NULL,
	UserId UNIQUEIDENTIFIER NOT NULL,
	Liked BIT DEFAULT 0,
	CONSTRAINT TL_FK_TradeId FOREIGN KEY (TradeId) REFERENCES Trades(Id),
	CONSTRAINT TL_FK_UserId FOREIGN KEY (UserId) REFERENCES Users(Id)
);

CREATE TABLE PostLikes (
	PostId UNIQUEIDENTIFIER NOT NULL,
	UserId UNIQUEIDENTIFIER NOT NULL,
	Liked BIT DEFAULT 0,
	CONSTRAINT PL_FK_PostId FOREIGN KEY (PostId) REFERENCES Posts(Id),
	CONSTRAINT PL_FK_UserId FOREIGN KEY (UserId) REFERENCES Users(Id)
);