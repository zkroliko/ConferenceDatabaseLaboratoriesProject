use Konferencje
go
alter view NajpopularniejszeWarsztaty
-- Widok pokazuje posortowane warsztaty po liczbie uczestnikow
as
select top 100 w.id, w.[Nazwa warsztatu], sum(rw.[Liczba miejsc]) as "Liczba zarezerwowanych miejsc"
from Warsztaty as w
inner join [Rezerwacje warsztatow] as rw
on rw.WarsztatID = w.id
where rw.anulowano = 0 --Warunek na anulowanie
group by w.id, w.[Nazwa warsztatu]
order by sum(rw.[Liczba miejsc]) DESC
go