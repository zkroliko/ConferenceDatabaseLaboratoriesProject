USE [Konferencje]
GO

/****** Object:  StoredProcedure [dbo].[IdentyfikatoryKonferencji]    Script Date: 1/19/2015 7:55:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- Tworzy tabele danych z identyfikatorami dla danej konferencji
CREATE PROCEDURE [dbo].[IdentyfikatoryKonferencji]
    @param int --id konferencji
AS 
	set nocount on
select o.Imie, o.Nazwisko, isnull(f.[Nazwa Firmy], 'Osoba prywatna') as "Firma", o.Foto as "Sciezka do zdjecia" from [Uczestnicy konferencji] as uk
inner join Osoby as o
on o.id = uk.OsobaID
inner join Klienci as k
on k.id = uk.KlientID
inner join Firmy as f
on k.id = f.KlientID
-- Warunek na konferencje
where o.id in (
	select o.id from Osoby as o 
	inner join [Uczestnicy konferencji] as uk
	on uk.OsobaID = o.id
	inner join [Rezerwacje konferencji] as rk
	on rk.id = uk.RezerwacjaKonfID
	inner join [Dni Konferencji] as dk
	on dk.id = rk.id
	inner join Konferencje as k
	on k.id = dk.KonferencjaID
	where k.id = @param
)

GO


