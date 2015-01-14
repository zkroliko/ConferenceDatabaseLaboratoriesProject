USE [Konferencje]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DodajZnizke] 
@KonfID int,
@Startdate Date,
@EndDate Date,
@zniska float
AS BEGIN
SET NOCOUNT ON; 

INSERT INTO Znizki(KonferencjaID,[Obowiazuje od],[Obowiazuje do],Znizka)Values(@KonfID,@Startdate,@EndDate,@zniska)
END
