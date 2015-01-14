USE Konferencje;
GO
-- Dla podanej firmy wypisuje wszystkich uczestników
alter PROCEDURE UczestnicyOdFirmy
    @param varchar(50) --id firmy lub nazwa firmy
AS 
    set nocount on
    SELECT o.id, o.Imie, o.Nazwisko, o.[Data urodzenia], o.Plec, o.[Legitymacja studencka nr] from [Uczestnicy konferencji] as uk
	inner join Osoby as o
	on uk.OsobaID = o.id
	inner join Klienci as k
	on k.id = uk.KlientID
	inner join Firmy as f
	on f.KlientID = k.id
	where (k.CzyFirma = 1) and (f.[Nazwa Firmy] like @param or f.KlientID like @param)
	 and (select anulowano from [Rezerwacje konferencji] as rk where rk.id = uk.id) = 0 --Warunek na anulowanie
GO