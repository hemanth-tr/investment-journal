
CREATE OR REPLACE PROCEDURE CreateUser (
	UserId VARCHAR(30),
	Fullname VARCHAR(100),
	Birthdate DATE,
	Email VARCHAR(100),
	Phone VARCHAR(10)
)
LANGUAGE plpgsql AS
$$
DECLARE
	IsUserExists BOOLEAN;
BEGIN
	SELECT EXISTS(SELECT * FROM "user" WHERE "Username" = UserId) INTO IsUserExists;

	IF IsUserExists THEN
    	RAISE EXCEPTION 'ALREADY EXISTS';
	ELSE
		INSERT INTO "user"
		VALUES (gen_random_uuid(), UserId, Fullname, Birthdate, Email, Phone);
		RAISE NOTICE 'CREATED';
	END IF;
END
$$;

CREATE OR REPLACE PROCEDURE CreateTrade(
	IN stockname character varying,
	IN ep numeric,
	IN username character varying)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE	
	IsUserExists BOOLEAN;
	IsTradeExists BOOLEAN;
	UId UUID;
	TId UUID;
BEGIN

	SELECT EXISTS(SELECT * FROM "user" WHERE "Username" = username) INTO IsUserExists;

	IF IsUserExists THEN

		SELECT Id INTO UId FROM "user" WHERE Username = username;
		
		SELECT EXISTS(SELECT * FROM Trade WHERE Id IN (SELECT TradeId FROM Trades WHERE UserId = UId) AND Stock = stockname AND Entryprice = ep AND Exitprice is null) INTO IsTradeExists;

		IF IsTradeExists <> 't' THEN

			TId = gen_random_uuid();
			INSERT INTO Trade
			VALUES (TId, Stockname, ep, null, CURRENT_TIMESTAMP, NULL);

			INSERT INTO Trades
			VALUES (TId, UId);
			RAISE NOTICE 'CREATED';

		ELSE

			RAISE EXCEPTION 'TRADE EXIST'
			
		END IF;
		
	ELSE
		RAISE EXCEPTION 'USER DOENST EXIST';
	END IF;
END
$$;

CREATE OR REPLACE FUNCTION GetTrades(
	Uname VARCHAR(30)
)
RETURNS TABLE ("Id" UUID, Stock VARCHAR, Entryprice DECIMAL, Exitprice DECIMAL, Entrydatetime TIMESTAMP, Exitdatetime TIMESTAMP) AS $$
DECLARE
	IsUserExists BOOLEAN;
	UId UUID;
BEGIN
	SELECT EXISTS(SELECT * FROM "user" WHERE "Username" = Uname) INTO IsUserExists;
	IF IsUserExists THEN
		SELECT Id INTO UId FROM "user" WHERE "Username" = Uname;
		RAISE NOTICE '%', UId;
    	RETURN QUERY 
    	SELECT * FROM TRADE WHERE Id IN (SELECT Id FROM TRADES WHERE UserId = UId);
	END IF;
END;
$$ LANGUAGE plpgsql;