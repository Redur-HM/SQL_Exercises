-- Nutzen Sie die Datenbank ProjektDB, 
-- um die folgenden Aufgaben zu lösen:
USE ProjektDB;

-- Aufgabe 7.1
-- Finden Sie alle Abteilungen, an deren Standorten 
-- sich weitere Abteilungen befinden. Geben Sie jeweils
-- die Ids, Namen und Städte der Abteilungen aus.
--
--      id  kuerzel bezeichnung  ort		id	kuerzel bezeichnung    ort
--       1  BE		Beratung     München	1	BE		Beratung     München
--       2  DI		Diagnose     München	1	BE		Beratung     München
--       4  EK		Einkauf      München	1	BE		Beratung     München
--       1  BE		Beratung     München	2	DI		Diagnose     München
--       2  DI		Diagnose     München	2	DI		Diagnose     München
--       4  EK		Einkauf      München	2	DI		Diagnose     München
--      ...
--      (11 Zeilen)
SELECT * FROM Abteilung ab 
CROSS JOIN Abteilung a
WHERE a.ort = ab.ort;
--oder
SELECT a1.*, a2.*
FROM Abteilung a1
	INNER JOIN Abteilung a2 ON a1.ort = a2.ort;

-- Aufgabe 7.2
-- Überarbeiten Sie die Abfrage aus Aufgabe 7.1.
-- Diesmal sollen nur Zeilen ins Ergebnis übernommen 
-- werden, bei denen die Abteilungen sich unterscheiden.
--
--      id  kuerzel	bezeichnung  ort		id	kuerzel		bezeichnung  ort
--      1	BE		Beratung     München	2	DI			Diagnose     München
--      1	BE		Beratung     München	4	EK			Einkauf      München
--      2	DI		Diagnose     München	1	BE			Beratung     München
--      2	DI		Diagnose     München	4	EK			Einkauf      München
--      4	EK		Einkauf      München	1	BE			Beratung     München
--      4	EK		Einkauf      München	2	DI			Diagnose     München
SELECT * FROM Abteilung ab 
CROSS JOIN Abteilung a
WHERE a.ort = ab.ort AND a.id != ab.id;
--oder
SELECT * FROM Abteilung ab 
	INNER JOIN Abteilung a ON  a.ort = ab.ort AND a.id != ab.id;

-- Aufgabe 7.3
-- Überarbeiten Sie die Abfrage aus Aufgabe 7.2.
-- Diesmal soll jede Kombination nur einmal angezeigt 
-- werden. D.h. A-B ist das gleiche wie B-A.
--
--      id	kuerzel	bezeichnung  ort		id	kuerzel	bezeichnung  ort
--      2	DI		Diagnose     München	1	BE		Beratung     München
--      4	EK		Einkauf      München	1	BE		Beratung     München
--      4	EK		Einkauf      München	2	DI		Diagnose     München
SELECT * FROM Abteilung ab 
CROSS JOIN Abteilung a
WHERE a.ort = ab.ort AND a.id != ab.id AND a.id <= ab.id ;
--oder
SELECT * FROM Abteilung ab 
	INNER JOIN Abteilung a ON  a.ort = ab.ort AND a.id != ab.id AND a.id <= ab.id;
--man kann hier die Bedingungen mit WHERE schreiben

-- Aufgabe 7.4
-- Finden Sie heraus, ob es Mitarbeiter gibt, die einen 
-- Kollegen oder eine Kollegin aus derselben Abteilung 
-- in ihrem Wohnort haben (Stichwort Fahrgemeinschaft).
--
--      id		vorname  nachname	abt_id  ort			chef_id
--      5765    Sabine	 Schäfer    3		Landshut	2581
--      10102   Petra	 Huber		3		Landshut	2581
--      12121   Ursula	 Richter	4		München		22222
--      22222   Anke	 Vogel		4		München		NULL
SELECT m.* FROM Mitarbeiter M 
	JOIN Mitarbeiter mi ON mi.id != m.id
WHERE mi.abt_id=m.abt_id AND mi.ort =m.ort;


-- Aufgabe 7.5
-- Geben Sie die Mitarbeiter-Id, die Projektnummer und 
-- die Aufgabe der Mitarbeiter aus, die im gleichen 
-- Projekt die gleiche Aufgabe ausführen. Sortieren Sie
-- die Ausgabe ggf. sinnvoll.
--
--      mit_id  pro_id  aufgabe
--      25348   2      Sachbearbeiter
--      28559   2      Sachbearbeiter
--      20204   4      Sachbearbeiter
--      27365   4      Sachbearbeiter
SELECT a.mit_id, a.pro_id, a.aufgabe FROM Arbeit a 
	JOIN Arbeit ar ON a.mit_id != ar.mit_id
WHERE a.pro_id=ar.pro_id AND ar.aufgabe =a.aufgabe
ORDER BY a.pro_id , mit_id;



-- Aufgabe 7.6
-- Ermitteln Sie die Mitarbeiter mit Id, Vorname, Nachname
-- und dem Nachnamen des Vorgesetzten.
SELECT m.id, m.vorname, m.nachname,
		(SELECT nachname FROM Mitarbeiter mi WHERE  m.chef_id = mi.id ) chef
FROM Mitarbeiter m
	join Mitarbeiter mi ON m.id=mi.id
WHERE m.chef_id IS NOT NULL;
-- leider nicht meine Lösung aber besser als meine
SELECT m.id, m.vorname, m.nachname, mi.nachname as chef
FROM Mitarbeiter m
	join Mitarbeiter mi ON m.chef_id = mi.id;
--
--      id     vorname   nachname  chef
--      5765   Sabine    Schäfer   Kaufmann
--      9031   Rainer    Meier     Kaufmann
--      9912   Klaus     Wolf      Vogel
--      10102  Petra     Huber     Kaufmann
--      12121  Ursula    Richter   Vogel
--      ...
--      (13 Zeilen)



-- Aufgabe 7.7
-- Finden Sie die Abteilungen, in denen die beiden Vorgesetzten
-- Mitarbeiter arbeiten
SELECT ab.*
FROM Abteilung ab
	INNER JOIN Mitarbeiter m ON ab.id= m.abt_id
WHERE m.chef_id IS NULL;
--oder und besser
SELECT DISTINCT a.*
FROM Mitarbeiter m1
	INNER JOIN Mitarbeiter m2 ON m2.id = m1.chef_id
	INNER JOIN Abteilung a ON a.id = m2.abt_id
--      id  kuerzel  bezeichnung  ort
--      2   DI       Diagnose     München
--      4   EK       Einkauf      München
Select* from Mitarbeiter


-- Aufgabe 7.8
-- Ermitteln Sie, welche Mitarbeiter in der gleichen
-- Stadt wohnen wie ihre Vorgesetzten.

SELECT m.vorname, m.nachname,m.ort,
		(SELECT ort FROM Mitarbeiter mi WHERE  m.chef_id = mi.id AND mi.ort IS NoT NULL ) chef_ort
FROM Mitarbeiter m
	join Mitarbeiter mi ON m.ort = mi.ort
WHERE m.ort IS NOT NULL AND mi.ort IS NoT NULL ;
--      vorname  nachname  ort      chef_ort
--      Ursula   Richter   München  München
--      Rolf     Schubert  München  München


-- Aufgabe 7.9
-- Ermitteln Sie, welche Mitarbeiter im gleichen Projekt
-- arbeiten wie ihre Vorgesetzten.
SELECT m1.nachname, a1.pro_id, m2.nachname as chef_name, a2.pro_id as  chef_pro_id
FROM Mitarbeiter m1 
	INNER JOIN Mitarbeiter m2 ON m2.id = m1.chef_id
	INNER JOIN Arbeit a1 ON  a1.mit_id= m1.id
	INNER JOIN Arbeit a2 ON a2.mit_id = m2.id
WHERE a1.pro_id = a2.pro_id;
--      nachname  pro_id  chef_name  chef_pro_id
--      Huber     3       Kaufmann   3
--      Meier     3       Kaufmann   3
--      Krüger    5       Vogel      5
--      Wolf      5       Vogel      5
