USE Konferencje;
GO
-- Dla podanej konferencji podaje wszystkie zapisane osoby
CREATE PROCEDURE OsobyNaKonferencji
    @param varchar(50) --id konferencji lub nazwa
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
	inner join Konferencje as k
	on k.id = dk.KonferencjaID
	where k.[Nazwa Konferencji] like @param or k.id like @param
GO