USE [Konferencje]
GO
/****** Object:  StoredProcedure [dbo].[PodliczRezerwacja]    Script Date: 2015-01-15 13:32:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[Podliczkonferencje] 
@konfID int



AS BEGIN
SET NOCOUNT ON; 

Declare @rezerwacjaID int


Declare cursor1 cursor for select id from [Rezerwacje konferencji] where KonferencjaDzienId=@konfID

open cursor1
FETCH NEXT FROM cursor1
into @rezerwacjaID
WHILE @@FETCH_STATUS = 0
begin
	EXEC [dbo].[PodliczRezerwacja] @rezerwacjaID
	FETCH NEXT FROM cursor1
	into @rezerwacjaID
end
close cursor1;
DEALLOCATE cursor1;
END
