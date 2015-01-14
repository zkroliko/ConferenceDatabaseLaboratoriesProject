USE Konferencje;
GO
-- To dla danej osoby wypisuje na co by³ i jest zapisany
alter PROCEDURE NaCoZapisany 
    @param varchar(50) --id lub imie nazwisko z tabeli osoby
AS 
    set nocount on
    SELECT w.[Nazwa warsztatu], dk.Data, dw.[Godzina rozpoczecia], dw.[Godzina zakonczenia]
	from Osoby as o
	inner join 	[Uczestnicy konferencji] as uk
	on o.id = uk.OsobaID
	inner join  Uczestnicy as u
	on u.UczestnikKonfID = uk.id
	inner join [Rezerwacje warsztatow] as rw
	on u.RezerwacjaID = rw.id
	inner join Warsztaty as w
	on w.id = rw.WarsztatID
	inner join [Dni warsztatu] as dw
	on dw.WarsztatID = w.id
	inner join [Dni Konferencji] as dk
	on dw.DzienID = dk.id
	where (o.id like @param or (o.Imie + o.Nazwisko) like @param) and rw.anulowano = 0 --Warunek na anulowanie
	--sortowanie po dacie
	order by dk.Data
GO