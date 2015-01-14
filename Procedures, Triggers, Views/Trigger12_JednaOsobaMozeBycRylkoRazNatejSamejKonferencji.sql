-- ================================================
-- Template generated from Template Explorer using:
-- Create Trigger (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- See additional Create Trigger templates for more
-- examples of different Trigger statements.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MJ
-- Create date: 
-- Description:	
-- =============================================
CREATE TRIGGER [dbo].[JednaOsobaMozeBycRylkoRazNatejSamejKonferencji]
   ON  [dbo].[Uczestnicy konferencji]
   AFTER INSERT,UPDATE
AS 

BEGIN
	DECLARE @confId int = (SELECT RezerwacjaKonfID FROM inserted)
	DECLARE @osobaID int = (SELECT OsobaID FROM inserted)
    DECLARE @HowMany int = (SELECT COUNT(id) FROM [Uczestnicy konferencji] WHERE RezerwacjaKonfID=@confId and OsobaID=@osobaID)
    IF (@HowMany>1)
        BEGIN 
			DECLARE @message varchar(100) = 'You can asign One person only once fore the same boking' 
			;THROW 52000,@message,1 
			ROLLBACK TRANSACTION 
		END

END
GO
