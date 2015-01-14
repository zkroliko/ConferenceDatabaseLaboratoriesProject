USE [Konferencje]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DodajKonferencje] 
@Nazwa varchar(80),
@Opis varchar(150),
@Startdate Date,
@EndDate Date,
@liczbaMiejsc int, 
@Cena money 
AS BEGIN
SET NOCOUNT ON; 

INSERT INTO Konferencje([Nazwa Konferencji],[Opis konferencji],[Data Rozpoczecia],[Data Zakonczenia],[Liczba miejsc],[Cena za dzien])
Values(@Nazwa,@Opis,@Startdate,@EndDate,@liczbaMiejsc,@Cena)
END
