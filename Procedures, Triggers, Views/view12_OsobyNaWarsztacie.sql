USE Konferencje;
GO
-- Dla podanego warsztatu podaje wszystkie zapisane osoby
CREATE PROCEDURE OsobyNaWarsztacie
    @param varchar(50) --id warsztatu lub nazwa
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
	inner join Warsztaty as w
	on w.id = rw.WarsztatID
	where w.[Nazwa warsztatu] like @param or w.id like @param
GO