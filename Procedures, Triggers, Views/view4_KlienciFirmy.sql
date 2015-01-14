use Konferencje
go
create view KlienciFirmy
-- Pokazuje tych klientów, którzy s¹ firmami
as
select k.id, f.[Nazwa Firmy], f.[Telefon Kontaktowy], (o.Imie + ' ' + o.Nazwisko) as "Osoba do kontaktu", k.Email from Klienci as k
inner join Osoby as o
on k.OsobaID = o.id
inner join Firmy as f
on k.id = f.KlientID
where k.CzyFirma = 1
go