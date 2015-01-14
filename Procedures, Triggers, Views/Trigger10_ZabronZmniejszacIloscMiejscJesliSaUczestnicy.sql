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
CREATE TRIGGER [dbo].[ZabronZmniejszacIloscMiejscJesliSaUczestnicy]
   ON  [dbo].[Rezerwacje konferencji]
   AFTER UPDATE
AS 

BEGIN
	DECLARE @ConferenceDayBookingId int = (SELECT id FROM inserted)
	DECLARE @PlacesWanted int = (SELECT Normalne+Studenci FROM inserted)
    DECLARE @PlacesSet int = (SELECT COUNT(id) FROM [Uczestnicy konferencji] WHERE RezerwacjaKonfID=@ConferenceDayBookingId)
    IF (@PlacesSet > @PlacesWanted)
        BEGIN 
			DECLARE @message varchar(100) = 'There is too many participants assigned to this booking. Amount of participants: ' +CAST(@PlacesSet as varchar(10)) 
			;THROW 52000,@message,1 
			ROLLBACK TRANSACTION 
		END

END
GO
