USE [Konferencje]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DodajOsobe] 
@Name varchar(50),
@LastName varchar(50),
@Phone varchar(12),
@DateOfBirth Date,
@Sex bit,
@NrLeg nvarchar(10),
@Country varchar(50),
@Miasto varchar(50),
@KodPocztowy varchar(12),
@Ulica varchar(35),
@NrBud int, 
@NrMiesz int  
AS BEGIN
SET NOCOUNT ON; 
DECLARE @AdresID int
EXEC dbo.DodajAdres @Country,@Miasto,@KodPocztowy,@Ulica,@NrBud,@NrMiesz

SET @AdresID =(select A.id from Adresy as A 
	inner join Miasta  as M on A.MiastoID=M.id
	inner join Kraje as K on K.id=M.KrajID
	Where  A.[Numer budynku]=@NrBud and isnull(A.[Numer mieszkania],0) = isnull(@NrMiesz,0) and A.Ulica=@Ulica and M.Miasto=@Miasto And M.[Kod Pocztowy]=@KodPocztowy and K.Nazwa=@Country)

Insert into Osoby (Imie,Nazwisko,Telefon,[Data urodzenia],Plec,[Legitymacja studencka nr],AdresID)Values(@Name,@LastName,@Phone,@DateOfBirth,@Sex,@NrLeg,@AdresID)

END
