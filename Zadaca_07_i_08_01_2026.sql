-- ZADACA

--07.01

--Ispišite sve potkategorije i za svaku ispišite broj proizvoda u njoj.

SELECT Naziv AS Potkategorija,
       (SELECT COUNT(*) FROM Proizvod p WHERE p.PotkategorijaID = pk.IDPotkategorija) AS BrojProizvoda
FROM Potkategorija pk;


--Riješite prethodni zadatak pomoću spajanja.

SELECT pk.Naziv AS NazivPotkategorije, COUNT(*) AS BrojProizvoda
FROM Proizvod p
INNER JOIN Potkategorija pk ON p.PotkategorijaID = pk.IDPotkategorija
GROUP BY pk.Naziv
ORDER BY BrojProizvoda DESC;


--Ispišite sve kategorije i za svaku ispišite broj proizvoda u njoj.

SELECT Naziv AS Kategorija,
       (SELECT COUNT(*)
        FROM Proizvod p
        INNER JOIN Potkategorija pk ON p.PotkategorijaID = pk.IDPotkategorija
        WHERE pk.KategorijaID = k.IDKategorija) AS BrojProizvoda
FROM Kategorija k
ORDER BY BrojProizvoda DESC;


--Ispišite sve proizvode i pokraj svakog ispišite zarađeni iznos, od najboljih prema lošijim.

SELECT Naziv,
       (SELECT SUM(UkupnaCijena) FROM Stavka st WHERE pr.IDProizvod = st.ProizvodID) AS ZaradjeniIznos
FROM Proizvod pr
ORDER BY ZaradjeniIznos DESC;


--Dohvatite sve proizvode, uz svaki proizvod ispišite prosječnu cijenu svih proizvoda te razliku prosječne cijene svih proizvoda i cijene tog proizvoda. U obzir uzmite samo proizvode s cijenom većom od nule.

SELECT *,
       (SELECT AVG(CijenaBezPDV) FROM Proizvod WHERE CijenaBezPDV > 0) AS ProsjecnaCijenaSvihProizvoda,
       (SELECT AVG(CijenaBezPDV) FROM Proizvod WHERE CijenaBezPDV > 0) - pr.CijenaBezPDV AS RazlikaCijena
FROM Proizvod pr
WHERE CijenaBezPDV > 0;


--Dohvatite imena i prezimena 5 komercijalista koji su izdali najviše računa.

SELECT TOP (5) Ime, Prezime,
       (SELECT COUNT(*) FROM Racun r WHERE r.KomercijalistID = kom.IDKomercijalist) AS BrojIzdanihRacuna
FROM Komercijalist kom
ORDER BY BrojIzdanihRacuna DESC;


--Dohvatite imena i prezimena 5 najboljih komercijalista po broju realiziranih računa te uz svakog dohvatite i iznos prodane robe.

SELECT TOP (5) Ime, Prezime,
       (SELECT COUNT(*) FROM Racun r WHERE r.KomercijalistID = kom.IDKomercijalist) AS BrojIzdanihRacuna,
       (SELECT SUM(st.UkupnaCijena)
        FROM Stavka st
        INNER JOIN Racun r ON st.RacunID = r.IDRacun
        WHERE r.KomercijalistID = kom.IDKomercijalist) AS VrijednostIzdaneRobe
FROM Komercijalist kom
ORDER BY BrojIzdanihRacuna DESC;


--Dohvatite sve boje proizvoda. Uz svaku boju pomoću podupita dohvatite broj proizvoda u toj boji.

SELECT Boja,
       (SELECT COUNT(*) FROM Proizvod pro WHERE pro.Boja = pr.Boja) AS BrojProizvoda
FROM Proizvod pr
WHERE Boja IS NOT NULL
GROUP BY Boja
ORDER BY BrojProizvoda DESC;


--Dohvatite imena i prezimena svih kupaca iz Frankfurta i uz svakog ispišite broj računa koje je platio karticom, od višeg prema nižem.

SELECT Ime, Prezime,
       (SELECT COUNT(*)
        FROM Racun r
        WHERE ku.IDKupac = r.KupacID
          AND r.KreditnaKarticaID IS NOT NULL) AS BrojRacunaPlaceniKarticom
FROM Kupac ku
WHERE GradID = (
    SELECT gr.IDGrad
    FROM Grad gr
    WHERE Naziv = 'Frankfurt'
)
ORDER BY BrojRacunaPlaceniKarticom DESC;


--Vratite sve proizvode čija je cijena pet ili više puta veća od prosjeka.

SELECT * 
FROM Proizvod
WHERE CijenaBezPDV >= 5 * (
	SELECT AVG(CijenaBezPDV)
	FROM Proizvod
);


--Vratite sve proizvode koji su prodavani, ali u količini manjoj od 5.

SELECT 
    p.IDProizvod,
    p.Naziv,
    SUM(s.Kolicina) AS UkupnoProdano
FROM Proizvod p
INNER JOIN Stavka s ON p.IDProizvod = s.ProizvodID
GROUP BY p.IDProizvod, p.Naziv
HAVING SUM(s.Kolicina) < 5;


--Vratite sve proizvode koji nikad nisu prodani:
	--Pomoću IN ili NOT IN
	--Pomoću EXISTS ili NOT EXISTS
	--Pomoću spajanja

SELECT * 
FROM Proizvod 
WHERE IDProizvod NOT IN (
	SELECT ProizvodID
	FROM Stavka
)

SELECT *
FROM Proizvod p
WHERE NOT EXISTS (
	SELECT 1
	FROM Stavka s
	WHERE s.ProizvodID = p.IDProizvod
)

SELECT p.*
FROM Proizvod p
LEFT JOIN Stavka s ON p.IDProizvod = s.ProizvodID
WHERE s.ProizvodID IS NULL


--Vratite količinu zarađenog novca za svaku boju proizvoda.

SELECT p.Boja, SUM(s.UkupnaCijena) AS UkupniIznos
FROM Proizvod p
INNER JOIN Stavka s ON p.IDProizvod = s.ProizvodID
WHERE p.Boja IS NOT NULL
GROUP BY p.Boja
ORDER BY UkupniIznos DESC


--Vratite količinu zarađenog novca za svaku boju proizvoda, ali samo za one boje koje su zaradile više od 20.000.000.

SELECT p.Boja, SUM(s.UkupnaCijena) AS UkupniIznos
FROM Proizvod p
INNER JOIN Stavka s ON p.IDProizvod = s.ProizvodID
WHERE p.Boja IS NOT NULL
GROUP BY p.Boja
HAVING SUM(s.UkupnaCijena) > 20000000
ORDER BY UkupniIznos DESC

--Vratiti sve proizvode koji imaju dodijeljenu potkategoriju i koji su prodani u količini većoj od 5000. Uz svaki proizvod vratiti prodanu količinu i naziv kategorije.
SELECT 
    p.IDProizvod,
    p.Naziv AS NazivProizvoda,
    SUM(s.Kolicina) AS ProdanaKolicina,
    k.Naziv AS NazivKategorije
FROM Proizvod p
INNER JOIN Stavka s ON p.IDProizvod = s.ProizvodID
INNER JOIN Potkategorija pk ON p.PotkategorijaID = pk.IDPotkategorija
INNER JOIN Kategorija k ON pk.KategorijaID = k.IDKategorija
GROUP BY 
    p.IDProizvod,
    p.Naziv,
    k.Naziv
HAVING SUM(s.Kolicina) > 5000;



--********************************************************************************************************************************************

-- 08.01

/* 2. Napišite proceduru koja dohvaća prvih 10 redaka iz tablice Proizvod, prvih 5 redaka iz tablice KreditnaKartica i 
	zadnja 3 retka iz tablice Racun. 
Pozovite proceduru. Uklonite proceduru.
*/

GO
CREATE PROC DohvatiProizvode
AS
BEGIN
	SELECT TOP 10 * FROM Proizvod ;
	SELECT TOP 5 * FROM KreditnaKartica;
	SELECT TOP 3 * FROM Racun;
END
GO

EXEC DohvatiProizvode

DROP PROC DohvatiProizvode


--4. Napišite proceduru koja prima dvije cijene i vraća nazive i cijene svih proizvoda čija cijena je u zadanom rasponu. 
	--Pozovite proceduru na oba načina. Uklonite proceduru.

GO 
CREATE PROC NaziviCijeneProizvoda 
	@Cijena1 int,
	@Cijena2 int
AS
BEGIN
	SELECT Naziv, CijenaBezPDV FROM Proizvod WHERE CijenaBezPDV > @Cijena1 AND CijenaBezPDV < @Cijena2
END
GO

EXEC NaziviCijeneProizvoda 20, 1000
GO

DROP PROC NaziviCijeneProizvoda


--5. Napišite proceduru koja prima četiri parametra potrebna za unos nove kreditne kartice. 
	--Neka procedura napravi novi zapis u KreditnaKartica. Neka procedura prije i nakon umetanja dohvati broj zapisa u tablici. 
	--Pozovite proceduru na oba načina. Uklonite proceduru.

GO
CREATE PROC NovaKreditnaKartica 
	@TipKartice nvarchar(25),
	@BrojKartice nvarchar(20),
	@IstekMjesecKartice int,
	@IstekGodinaKartice int
AS
BEGIN
	SELECT COUNT(*) AS PrijeUnosa FROM KreditnaKartica;
	INSERT INTO KreditnaKartica(Tip, Broj, IstekMjesec, IstekGodina) VALUES (@TipKartice, @BrojKartice, @IstekMjesecKartice, @IstekGodinaKartice)
	SELECT COUNT(*) AS NakonUnosa FROM KreditnaKartica;
END
GO

EXEC NovaKreditnaKartica 'Diners', '99993846775564', 2, 2007

EXEC NovaKreditnaKartica
	@TipKartice = 'Diners',
	@BrojKartice = '99993846775564',
	@IstekMjesecKartice = 2,
	@IstekGodinaKartice = 2007

GO
DROP PROC NovaKreditnaKartica


--8. Napišite proceduru koja prima kriterij po kojemu ćete filtrirati prezimena iz tablice Kupac. 
	--Neka procedura pomoću izlaznog parametra vrati broj zapisa koji zadovoljavaju zadani kriterij. 
	--Neka procedura vrati i sve zapise koji zadovoljavaju kriterij. Pozovite proceduru i ispišite vraćenu vrijednost. Uklonite proceduru.

GO
CREATE PROC FilterPrezimena
    @Kriterij nvarchar(50),
    @BrojZapisa int OUTPUT
AS
BEGIN
    SELECT @BrojZapisa = COUNT(*)
    FROM Kupac
    WHERE Prezime LIKE @Kriterij;

    SELECT *
    FROM Kupac
    WHERE Prezime LIKE @Kriterij;
END
GO

DECLARE @Ukupno int;

EXEC FilterPrezimena
	@Kriterij = 'A%', 
    @BrojZapisa = @Ukupno OUTPUT;

SELECT @Ukupno AS BrojZapisa;

DROP PROC FilterPrezimena;


--9. Napišite proceduru koja za zadanog komercijalista pomoću izlaznih parametara vraća njegovo ime i prezime te ukupnu količinu izdanih računa.

GO
CREATE PROC KomercijalistRacuni
    @KomercijalistID int,
    @Ime nvarchar(25) OUTPUT,
    @Prezime nvarchar(25) OUTPUT,
    @KolicinaRacuna int OUTPUT
AS
BEGIN
    SELECT 
        @Ime = k.Ime,
        @Prezime = k.Prezime,
        @KolicinaRacuna = COUNT(r.IDRacun)
    FROM Komercijalist k
    LEFT JOIN Racun r 
        ON k.IDKomercijalist = r.KomercijalistID
    WHERE k.IDKomercijalist = @KomercijalistID
    GROUP BY k.Ime, k.Prezime;
END
GO

DECLARE 
    @ImeKomercijalista nvarchar(25),
    @PrezimeKomercijalista nvarchar(25),
    @BrojRacuna int;

EXEC KomercijalistRacuni
    @KomercijalistID = 280,
    @Ime = @ImeKomercijalista OUTPUT,
    @Prezime = @PrezimeKomercijalista OUTPUT,
    @KolicinaRacuna = @BrojRacuna OUTPUT;


SELECT 
    @ImeKomercijalista AS Ime,
    @PrezimeKomercijalista AS Prezime,
    @BrojRacuna AS UkupnoRacuna;

DROP PROC KomercijalistRacuni

SELECT * FROM Komercijalist