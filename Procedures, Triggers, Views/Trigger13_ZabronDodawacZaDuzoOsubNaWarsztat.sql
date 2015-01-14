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
CREATE TRIGGER [dbo].[ZabronDodawacZaDuzoOsubNaWarsztat]
   ON  [dbo].Uczestnicy
   AFTER INSERT,UPDATE
AS 

BEGIN
	DECLARE @RezerwId int = (SELECT RezerwacjaID FROM inserted)
    DECLARE @PlacesWanted int = (SELECT [liczba miejsc] FROM [Rezerwacje warsztatow] where id=@RezerwId)
    DECLARE @PlacesSet int = (SELECT COUNT(id) FROM Uczestnicy  WHERE RezerwacjaID=@RezerwId)
    IF (@PlacesSet > @PlacesWanted)
        BEGIN 
			DECLARE @message varchar(100) = 'There is too many participants assigned to this booking. Amount of participants: ' +CAST(@PlacesWanted as varchar(10))+'you can bok' 
			;THROW 52000,@message,1 
			ROLLBACK TRANSACTION 
		END

END
GO
