USE [Konferencje]
GO

/****** Object:  StoredProcedure [dbo].[OsobyNaKonferencji]    Script Date: 1/19/2015 7:58:01 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Dla podanego dnia konferencji podaje wszystkie zapisane osoby
CREATE PROCEDURE [dbo].[OsobyNaDniuKonferencji]
    @param int --id dnia konferencji
AS 
	set nocount on
    SELECT o.id, o.Imie, o.Nazwisko, o.[Data urodzenia], o.Plec, o.[Legitymacja studencka nr]
	--Laczenie tabel
	from Osoby as o
	inner join [Uczestnicy konferencji] as uk
	on uk.OsobaID = o.id
	inner join [Rezerwacje konferencji] as rk
	on uk.RezerwacjaKonfID = rk.id
	inner join [Dni Konferencji] as dk
	on rk.KonferencjaDzienId = dk.id
	where dk.id = @param and rk.anulowano = 0
GO


