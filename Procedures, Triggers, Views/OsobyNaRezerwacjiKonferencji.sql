USE [Konferencje]
GO

/****** Object:  StoredProcedure [dbo].[OsobyNaRezerwacjiKonferencji]    Script Date: 1/19/2015 8:08:08 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- Dla podanej rezerwacji konferencji podaje wszystkie zapisane osoby
CREATE PROCEDURE [dbo].[OsobyNaRezerwacjiKonferencji]
    @param int --id konferencji
AS 
	set nocount on
    SELECT o.id, o.Imie, o.Nazwisko, o.[Data urodzenia], o.Plec, o.[Legitymacja studencka nr]
	--Laczenie tabel
	from Osoby as o
	inner join [Uczestnicy konferencji] as uk
	on uk.OsobaID = o.id
	inner join [Rezerwacje konferencji] as rk
	on uk.RezerwacjaKonfID = rk.id
	where rk.id = @param and rk.anulowano = 0

GO


