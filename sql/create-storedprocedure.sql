
CREATE OR ALTER PROCEDURE [dbo].[CreateUser]
	-- Add the parameters for the stored procedure here
	@Username VARCHAR(30),
	@Fullname VARCHAR(100),
	@Birthdate DATE,
	@Email VARCHAR(100),
	@Phone VARCHAR(10) = NULL
AS
BEGIN

	IF NOT EXISTS (SELECT * FROM Users WHERE Username = @Username)
	BEGIN
		INSERT INTO Users (Username, Fullname, Birthdate, Email, Phone)
		VALUES (@Username, @Fullname, @Birthdate, @Email, @Phone);
	END

END

CREATE OR ALTER PROCEDURE CreateTrade
	-- Add the parameters for the stored procedure here
	@StockName VARCHAR(20),
	@EntryPrice INT,
	@Username VARCHAR(100)
AS
BEGIN

	DECLARE @UserGuid UNIQUEIDENTIFIER
	DECLARE @NewTradeId UNIQUEIDENTIFIER

	IF EXISTS (SELECT * FROM Users WHERE Username = @Username)
	BEGIN
		SELECT @UserGuid = Id FROM Users WHERE Username = @Username
		IF NOT EXISTS (SELECT * FROM Trades WHERE Id IN (SELECT TradeId FROM UserTradeMap WHERE UserId = @UserGuid) AND Stock = @StockName AND Entryprice = @EntryPrice AND Exitprice IS NULL)
		BEGIN
			SET @NewTradeId = NEWID()
			INSERT INTO Trades
			VALUES (@NewTradeId, @StockName, @EntryPrice, NULL, CURRENT_TIMESTAMP, NULL)

			INSERT INTO UserTradeMap
			VALUES (@NewTradeId, @UserGuid)
		END
		ELSE
		BEGIN
			RAISERROR('TRADE DONOT EXISTS',10,1) WITH NOWAIT;
		END
	END
	ELSE
	BEGIN
		RAISERROR('USER DONOT EXISTS',10,1) WITH NOWAIT;
	END

END
GO


CREATE OR ALTER PROCEDURE GetTrades
	-- Add the parameters for the stored procedure here
	@Username VARCHAR(30)
AS
BEGIN

	DECLARE @UserGuid UNIQUEIDENTIFIER

	IF EXISTS (SELECT * FROM Users WHERE Username = @Username)
	BEGIN
		SELECT @UserGuid = Id FROM Users WHERE Username = @Username
		SELECT * FROM Trades WHERE Id IN (SELECT TradeId FROM UserTradeMap WHERE UserId = @UserGuid)
	END
	ELSE
	BEGIN
		RAISERROR('USER DONOT EXISTS',10,1) WITH NOWAIT;
	END

END
GO