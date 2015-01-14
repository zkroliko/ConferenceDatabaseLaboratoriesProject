USE [Konferencje]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DodajRezerwacjeWarsztatu] 
@WarsztatID int,
@RezerwacjaKonfID int,
@DataRezerwacji Date,
@LiczbaMiejsc int



AS BEGIN
SET NOCOUNT ON; 

insert into [Rezerwacje warsztatow](WarsztatID,KonferencjaID,[Data rezerwacji],[liczba miejsc])Values(@WarsztatID,@RezerwacjaKonfID,@DataRezerwacji,@LiczbaMiejsc)
END
