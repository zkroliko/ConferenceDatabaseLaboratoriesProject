use Konferencje
go
alter view NajczesciejKorzystajacy
-- Pokazuje klientów najczesciej korzystajacych z uslug, "najczesciej" oznacza posiadajacych jak najwieksza liczbe rezerwacji konferencji
as
--Najpierw dla firm
select top 100 k.id, f.[Nazwa Firmy] as "Nazwa", count(rk.id) as "Ilosc zarezerwowanych dni" from Klienci as k
inner join [Rezerwacje konferencji] as rk
on rk.KlientID = k.id
inner join Firmy as f
on f.KlientID = k.id
where k.CzyFirma = 1 and rk.anulowano = 0 --Warunek na anulowanie
group by k.id, f.[Nazwa Firmy]
--Teraz dla osob prywatynch
union
select top 100 k.id, (o.Imie + ' ' + o.Nazwisko) as Nazwa, count(rk.id) as "Ilosc zarezerwowanych dni" from Klienci as k
inner join [Rezerwacje konferencji] as rk
on rk.KlientID = k.id
inner join Osoby as o
on k.OsobaID = o.id
where k.CzyFirma = 0  and rk.anulowano = 0 --Warunek na anulowanie
group by k.id, (o.Imie + ' ' + o.Nazwisko)
go