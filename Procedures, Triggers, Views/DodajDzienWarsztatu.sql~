USE [Konferencje]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DodajDzienWarsztatu] 
@DzienID int,
@warsztatID int,
@GodzRozp time(7),
@GodzZak time(7)



AS BEGIN
SET NOCOUNT ON; 

insert into [Dni warsztatu](DzienID,WarsztatID,[Godzina rozpoczecia],[Godzina zakonczenia])Values(@DzienID,@warsztatID,@GodzRozp,@GodzZak)
END
