-- Nutzen Sie die Datenbank ProjektDB,
-- um die folgenden Aufgaben zu lösen.
USE ProjektDB;

-- Aufgabe 22.1
-- Schreiben Sie eine Abfrage, die Personalnummer,
-- Vorname, Nachname und den Name der Abteilung
-- der Mitarbeiter sortiert nach Personalnummer
-- ausgibt. Geben Sie nur die ersten drei Zeilen
-- aus.
 SELECT TOP(3)m.id ,m.vorname ,m.nachname , ab.bezeichnung 
 FROM Mitarbeiter m
	INNER JOIN Abteilung ab ON m.abt_id= ab.id
ORDER BY m.id ASC;
--ODER
 SELECT m.id ,m.vorname ,m.nachname , ab.bezeichnung 
 FROM Mitarbeiter m
	INNER JOIN Abteilung ab ON m.abt_id= ab.id
ORDER BY m.id ASC
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY; --0 ROWS vom Anfang springen und dann erste nächste 3 ROWS anzeigen.
--      id      vorname     nachname    bezeichnung
--      2581    Brigitte    Kaufmann    Diagnose
--      5765    Sabine      Schäfer     Freigabe
--      9031    Rainer      Meier       Diagnose



-- Aufgabe 22.2
-- Schreiben Sie eine Abfrage, die alle Projekt-Aufgaben 
-- mit den zugehörigen Projekten kombiniert. Geben Sie die
-- Felder pro_id, bezeichnung, mit_id und aufgabe aus. Sortieren 
-- Sie die Ausgabe nach pro_id aufsteigend und mit_id absteigend.
SELECT p.id AS pro_id , p.bezeichnung, a.mit_id, a.aufgabe
FROM Projekt p
	INNER JOIN Arbeit a ON a.pro_id= p.id
ORDER BY p.id ASC, a.mit_id DESC;

--      pro_id  bezeichnung mit_id  aufgabe
--      1       Apollo      29346   Sachbearbeiter
--      1       Apollo      28559   NULL
--      1       Apollo      17000   NULL
--      1       Apollo      10102   Projektleiter
--      1       Apollo      9031    Gruppenleiter 
--      ...
--      (20 Zeilen)



-- Aufgabe 22.3
-- Erweitern Sie die Abfrage aus Aufgabe 22.2, indem Sie
-- zusätzlich noch den Nachnamen des Mitarbeiters im
-- Ergebnis mit ausgeben.
SELECT p.id AS pro_id , p.bezeichnung, a.mit_id, m.nachname, a.aufgabe
FROM Projekt p
	 JOIN Arbeit a ON a.pro_id= p.id
	 JOIN Mitarbeiter m ON a.mit_id= m.id
ORDER BY p.id ASC, a.mit_id DESC;
--Geht LEFT auch hier einwandfrei

--      pro_id  bezeichnung mit_id  nachname    aufgabe
--      1       Apollo      29346   Probst      Sachbearbeiter
--      1       Apollo      28559   Mozer       NULL
--      1       Apollo      17000   Krüger      NULL
--      1       Apollo      10102   Huber       Projektleiter
--      1       Apollo      9031    Meier       Gruppenleiter
--      ...
--      (20 Zeilen)



-- Aufgabe 22.4
-- Erweitern Sie die Abfrage aus Augfgabe 2.3, indem Sie
-- zusätzlich noch den Namen der Abteilung des Mitarbeiters
-- im Ergebnis anzeigen.

SELECT p.id AS pro_id , p.bezeichnung, a.mit_id, m.nachname, a.aufgabe , ab.bezeichnung
FROM Projekt p
	 JOIN Arbeit a ON a.pro_id= p.id
	 JOIN Mitarbeiter m ON a.mit_id= m.id
	 JOIN Abteilung ab ON m.abt_id = ab.id
ORDER BY p.id ASC, a.mit_id DESC;
--Geht LEFT auch hier einwandfrei

--      pro_id  bezeichnung mit_id  nachname    aufgabe         bezeichnung
--      1       Apollo      29346   Probst      Sachbearbeiter  Diagnose
--      1       Apollo      28559   Mozer       NULL            Beratung
--      1       Apollo      17000   Krüger      NULL            Verkauf
--      1       Apollo      10102   Huber       Projektleiter   Freigabe
--      1       Apollo      9031    Meier       Gruppenleiter   Diagnose
--      ...
--      (20 Zeilen)



-- Aufgabe 22.5
-- Finden Sie Namen und Vornamen aller Mitarbeiter, 
-- die im Projekt Merkur arbeiten.
SELECT m.nachname , m.vorname
FROM Mitarbeiter m 
	 JOIN Arbeit a ON m.id = a .mit_id
	INNER JOIN Projekt p ON a.pro_id = p.id
WHERE p.bezeichnung ='Merkur';
--Geht LEFT auch hier einwandfrei

--      nachname    vorname
--      Kaufmann    Brigitte            
--      Meier       Rainer              
--      Huber       Petra 
--      Schubert    Rolf



-- Aufgabe 22.6
-- Nennen Sie Namen und Vornamen aller Projektleiter, deren 
-- Abteilung den Standort München hat.
SELECT m.nachname , m.vorname
FROM Mitarbeiter m 
	INNER JOIN Arbeit a ON m.id = a .mit_id
	INNER JOIN Abteilung ab ON m.abt_id=ab.id
WHERE ab.ort ='München' AND a.aufgabe='Projektleiter';
--      nachname    vorname
--      Kaufmann    Brigitte
--      Vogel       Anke            



-- Aufgabe 22.7
-- Nennen Sie einmalig die Namen der Projekte, in denen die 
-- Mitarbeiter arbeiten, die ein Gehalt von mindestens 
-- 5.000 € beziehen.
SELECT DISTINCT p.bezeichnung
FROM Projekt p
	INNER JOIN Arbeit a ON a.pro_id=p.id
	INNER JOIN Gehalt g ON g.mit_id = a.mit_id AND g.gehalt >= 5000;
--      bezeichnung
--      Apollo
--      Ariane
--      Gemini



-- Aufgabe 22.8
-- Finden Sie die Mitarbeiter, die das gleiche Gehalt
-- beziehen. Geben Sie die Personalnummer und das Gehalt
-- einmalig aus.
SELECT  DISTINCT g.mit_id,  g.gehalt
FROM Gehalt g
	INNER JOIN Gehalt ge ON g.gehalt = ge.gehalt
WHERE g.mit_id<> ge.mit_id
ORDER BY g.gehalt;
--oder 
SELECT  g.mit_id,  g.gehalt
FROM Gehalt g
WHERE g.gehalt IN(
	SELECT gehalt FROM Gehalt 
	GROUP BY gehalt HAVING COUNT (*) > 1)
ORDER BY gehalt;
--      mit_id  gehalt
--      2581    3000,00
--      12121   3000,00
--      18316   3000,00
--      24321   3000,00
--      20204   3500,00
--      9912    3500,00
--      10102   3500,00
--      ...
--      (11 Zeilen)



-- Aufgabe 22.9
-- Finden Sie die Personalnummer, die Projektnummer
-- und die Aufgabe von Mitarbeitern aus, die die gleiche 
-- Aufgabe im gleichen Projekt ausführen.
SELECT a.mit_id , a.pro_id , a.aufgabe
FROM Arbeit a 
	INNER JOIN Arbeit ar ON a.pro_id= ar.pro_id AND a.aufgabe=ar.aufgabe
WHERE a.mit_id<>ar.mit_id
ORDER BY a.pro_id;
--      mit_id  pro_id  aufgabe
--      25348   2       Sachbearbeiter
--      28559   2       Sachbearbeiter
--      20204   4       Sachbearbeiter
--      27365   4       Sachbearbeiter



-- Aufgabe 22.10
-- Zeigen Sie alle Mitarbeiter der Abteilung 2 mit 
-- Personalnummer und Name an und geben Sie dazu die vom 
-- Mitarbeiter getätigten Umsätze aus. Hat der Mitarbeiter 
-- noch keine Umsätze getätigt, soll in der Spalte Umsatz 
-- eine 0 angezeigt werden.
SELECT m.id, m.nachname , ISNULL(SUM(u.umsatz),0) AS umsatz --SUM(ISNULL(u.umsatz,0))
FROM Mitarbeiter m
	LEFT JOIN Umsatz u ON u.mit_id=m.id
WHERE m.abt_id= 2 
GROUP BY m.id, m.nachname;
--      id      nachname    umsatz
--      2581    Kaufmann    100000,00
--      9031    Meier       0,00
--      29346   Probst      0,00



-- Aufgabe 22.11
-- Verändern Sie die Abfrage aus Aufgabe 22.10, indem Sie
-- jetzt alle Mitarbeiter anzeigen. Gruppieren Sie über
-- die Personalnummer und den Namen und geben Sie die Summe
-- der getätigten Umsätze aus. Wenn keine Umsätze getätigt
-- wurden, soll weiterhin eine 0 erscheinen.
SELECT m.id, m.nachname , ISNULL(SUM(u.umsatz),0) AS umsatz
FROM Mitarbeiter m
	LEFT JOIN Umsatz u ON u.mit_id=m.id
GROUP BY m.id, m.nachname;
--      id      nachname    umsatz
--      2581    Kaufmann    100000,00
--      5765    Schäfer     0,00
--      9031    Meier       0,00
--      9912    Wolf        0,00
--      10102   Huber       18000,00
--      12121   Richter     0,00
--      17000   Krüger      20000,00
--      18316   Müller      0,00
--      ...
--      (15 Zeilen)



-- Aufgabe 22.12
-- Verändern Sie die Abfrage aus Aufgabe 22.11, indem Sie
-- nur die Mitarbeiter anzeigen, die noch keine Umsätze 
-- getätigt haben.
SELECT m.id, m.nachname , ISNULL(SUM(u.umsatz),0) AS umsatz
FROM Mitarbeiter m
	LEFT JOIN Umsatz u ON u.mit_id=m.id
GROUP BY m.id, m.nachname
HAVING SUM(u.umsatz) IS NULL;
--es geht auch soo HAVING SUM(COALESCE(u.umsatz,0) = 0;

--      id      nachname    umsatz
--      5765    Schäfer     0,00
--      9031    Meier       0,00
--      9912    Wolf        0,00
--      12121   Richter     0,00
--      18316   Müller      0,00
--      20204   Fuchs       0,00
--      22222   Vogel       0,00
--      24321   Schubert    0,00
--      27365   Albrecht    0,00
--      28559   Mozer       0,00
--      29346   Probst      0,00



-- Aufgabe 22.13
-- Finden Sie alle Mitarbeiter mit Personalnummer und
-- Namen, die in keinem Projekt als Sachbearbeiter tätig sind.
SELECT  DISTiNCT m.id, m.nachname 
FROM Mitarbeiter m
	INNER JOIN Arbeit a ON a.mit_id=m.id 
WHERE a.mit_id NOT IN( SELECT mit_id FROM Arbeit WHERE aufgabe ='Sachbearbeiter')
--oder nehmen wir erst mal was wir nicht sehen wollen und dann werfen wir die weg
SELECT  DISTiNCT m.id, m.nachname 
FROM Mitarbeiter m
	LEFT JOIN Arbeit a ON a.mit_id=m.id AND aufgabe ='Sachbearbeiter'
WHERE a.mit_id IS NULL;
--oder wie meine aber besser
SELECT  DISTiNCT m.id, m.nachname 
FROM Mitarbeiter m
WHERE m.id NOT IN ( SELECT mit_id FROM Arbeit WHERE aufgabe ='Sachbearbeiter');
--      id      nachname
--      2581    Kaufmann
--      5765    Schäfer
--      10102   Huber
--      12121   Richter
--      17000   Krüger
--      18316   Müller
--      22222   Vogel
--      24321   Schubert
SELECT * FROM Arbeit
SELECT * FROM Mitarbeiter

