USE [Konferencje]
GO

/****** Object:  StoredProcedure [dbo].[OsobyNaRezerwacjiWarsztatu]    Script Date: 1/19/2015 8:09:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Dla podanej rezerwacji warsztatu podaje wszystkie zapisane osoby
CREATE PROCEDURE [dbo].[OsobyNaRezerwacjiWarsztatu]
    @param int --id warsztatu
AS 
	set nocount on
    SELECT o.id, o.Imie, o.Nazwisko, o.[Data urodzenia], o.Plec, o.[Legitymacja studencka nr]
	--Laczenie tabel
	from Osoby as o
	inner join [Uczestnicy konferencji] as uk
	on uk.OsobaID = o.id
	inner join [Uczestnicy] as u
	on u.UczestnikKonfID = uk.id
	inner join [Rezerwacje warsztatow] as rw
	on rw.id = u.RezerwacjaID
	where rw.id like @param and rw.anulowano = 0

GO


