USE [Konferencje]
GO
/****** Object:  StoredProcedure [dbo].[ZmienAdres]    Script Date: 1/12/2015 6:22:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Zmienia adres o danym id. Nowy adres bedzie posiadal nowe dane, oraz wstawi nowy kraj oraz miasto jezeli bedzie to potrzebne.
--Stary kraj i miasto zostanie w bazie.
ALTER PROCEDURE [dbo].[ZmienAdres] 
@id int,
@Country varchar(50),
@Miasto varchar(50),
@KodPocztowy varchar(12),
@Ulica varchar(35),
@NrBud int, 
@NrMiesz int 
AS BEGIN
SET NOCOUNT ON; 
DECLARE @KrajID int
DECLARE @MiastoID int
DECLARE @AdresID int
SET @KrajID=(select id from Kraje where Nazwa=@Country)
if @KrajID is null
begin
    Insert INTO Kraje (Nazwa) Values (@Country)
	SET @KrajID=@@IDENTITY
end
SET @MiastoID=(select id from Miasta where Miasto=@Miasto And [Kod Pocztowy]=@KodPocztowy and KrajID=@KrajID)
if @MiastoID is null
begin
	Insert INTO Miasta(Miasto,[Kod Pocztowy],KrajID) Values (@Miasto,@KodPocztowy,@KrajID)
	SET @MiastoID=@@IDENTITY
end
SET @AdresID=(select id from Adresy where id = @id)
if @AdresID is not null
begin
	update Adresy
	set MiastoID = @MiastoID,	
	[Numer Budynku] = @NrBud,
	[Numer mieszkania] = @NrMiesz,
	Ulica = @Ulica
	where @AdresID=id
end
END