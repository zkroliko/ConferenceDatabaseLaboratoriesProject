use Konferencje
go
alter view NajpopularniejszeKonferencje
-- Widok pokazuje posortowane konferencje po liczbie uczestnikow
as
select top 100 k.id, k.[Nazwa Konferencji], sum(rk.Normalne+rk.Studenci) as "Liczba zarezerwowanych miejsc" from Konferencje as k
inner join [Dni Konferencji] as dk
on dk.KonferencjaID = k.id
inner join [Rezerwacje konferencji] as rk
on rk.KonferencjaDzienId = dk.id
where rk.anulowano = 0 --Warunek na anulowanie
group by k.id, k.[Nazwa Konferencji]
order by sum(rk.Normalne+rk.Studenci) DESC
go