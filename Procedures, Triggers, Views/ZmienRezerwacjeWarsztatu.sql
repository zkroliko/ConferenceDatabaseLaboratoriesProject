USE [Konferencje]
GO
/****** Object:  StoredProcedure [dbo].[DodajRezerwacjeWarsztatu]    Script Date: 2015-01-14 15:18:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[ZmienRezerwacjeWarsztatu] 
@WarsztatID int,
@RezerwacjaKonfID int,
@DataRezerwacji Date,
@LiczbaMiejsc int,
@anulowano bit


AS BEGIN
SET NOCOUNT ON; 

update [Rezerwacje warsztatow]set WarsztatID=@WarsztatID,KonferencjaID=@RezerwacjaKonfID,[Data rezerwacji]=@DataRezerwacji,[liczba miejsc]=@LiczbaMiejsc,anulowano=@anulowano
END
