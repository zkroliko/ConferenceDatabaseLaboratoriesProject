use Konferencje
go
create view KlienciOsoby
-- Pokazuje tych klientów, którzy s¹ osobami prywatnymi
as
select k.id,(o.Imie + ' ' + o.Nazwisko) as "Imie i nazwisko", o.Telefon as "Numer telefonu", k.Email from Klienci as k
inner join Osoby as o
on k.OsobaID = o.id
where k.CzyFirma = 0
go