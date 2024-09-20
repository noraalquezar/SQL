//Espectacle amb la zona de recinte m�s cara.

SELECT DISTINCT Es.Codi, Es.Nom, Pe.Zona
FROM Espectacles Es, Preus_Espectacles Pe
WHERE Es.Codi=Pe.Codi_Espectacle AND Pe.Preu>=ALL(SELECT Preu FROM Preus_Espectacles);

//Nom del recinte i zona amb m�s capacitat

SELECT DISTINCT r.Nom, z.Zona, z.Capacitat
FROM Recintes r, Zones_Recinte z
WHERE r.Codi=z.Codi_Recinte AND z.Capacitat>=ALL(SELECT Capacitat FROM Zones_Recinte);

//Nom de l'espectacle amb l'entrada m�s cara

SELECT DISTINCT Es.Nom, Pe.Preu
FROM Espectacles Es, Preus_Espectacles Pe
WHERE Es.Codi=Pe.Codi_Espectacle AND Pe.Preu>=ALL(SELECT Preu FROM Preus_Espectacles);

//Nom dels espectacles que s'han representat al mateix recinte que L'auca del senyor Esteve. 
//L'auca no s'ha de mostrar al registre
SELECT Ec.Nom
FROM Espectacles Ec
WHERE Ec.Codi_Recinte = (
    SELECT EC1.Codi_Recinte
    FROM Espectacles EC1
    WHERE EC1.Nom = 'L''auca del senyor Esteve'
)
AND Ec.Nom <> 'L''auca del senyor Esteve'
ORDER BY 1;

//Nom del recinte (o els recintes) amb una capacitat total m�s gran

SELECT DISTINCT r.Nom
FROM Recintes r, Zones_Recinte z
WHERE r.Codi=z.Codi_Recinte AND z.Capacitat>=ALL(SELECT Capacitat FROM Zones_Recinte)
ORDER BY 1;

//Codi, nom i ciutat del recinte amb m�s espectadors

SELECT e.Codi,e.Nom, e.Ciutat, COUNT(*)
FROM Recintes e, Entrades s
WHERE e.Codi=s.Codi_Recinte
GROUP BY  e.Codi, e.Nom, e.Ciutat
HAVING COUNT(*) >=ALL(SELECT COUNT (Numero)
                        FROM Entrades
                        GROUP BY Codi_Recinte)
ORDER BY 1,2,3;

//Codi i nom del recinte que ha venut m�s entrades. Tamb� mostra el nombre d'entrades venudes.

SELECT r.Codi, r.Nom, COUNT(*) AS NUM_REP
FROM Recintes r, Entrades s
WHERE s.Codi_Recinte=r.codi
GROUP BY r.codi, r.Nom
HAVING COUNT(*)>= ALL(SELECT COUNT(*) FROM Entrades GROUP BY Codi_Recinte)
ORDER BY 1,2;

//Zona m�s popular (de la qual se n'han venut m�s entrades, sense tenir en compte l'espectacle ni el recinte).
//Atributs de sortida: zona.

SELECT en.Zona
FROM Entrades en
WHERE COUNT(*)>=ALL(SELECT COUNT(*)
                FROM Entrades en)
ORDER BY 1;


-- Zona m�s popular (de la qual se n'han venut m�s entrades, sense tenir en compte l'espectacle ni el recinte).
-- Atributs de sortida: zona.

SELECT en.Zona
FROM Entrades en
GROUP BY en.Zona
HAVING COUNT(*) >= ALL (
    SELECT COUNT(*)
    FROM Entrades
    GROUP BY Zona
)
ORDER BY 1;





//DNI, nom i cognoms de l'espectador que ha adquirit m�s entrades per a qualsevol espectacle, ordenat per cognoms.

SELECT r.DNI, r.Nom, r.Cognoms
FROM Espectadors r, Entrades s
WHERE r.DNI=s.DNI_Client
GROUP BY r.DNI, r.Nom, r.Cognoms
HAVING COUNT(*)>= ALL(SELECT COUNT(*) FROM Entrades GROUP BY DNI_Client)
ORDER BY 3 ASC;

//Nom de l'int�rpret que ha fet m�s representacions. Tamb� mostra el nombre de representacions

SELECT Ec.Interpret, COUNT(*) AS NUM_REP
FROM Espectacles Ec, Representacions Rp
WHERE Ec.Codi=Rp.Codi_Espectacle
GROUP BY Ec.Interpret
HAVING COUNT(*)>= ALL(SELECT COUNT(*) FROM representacions GROUP BY Codi_Espectacle)
ORDER BY 1,2;

//Nom dels recintes de Barcelona que tenen una capacitat total m�s gran que el Teatre Vict�ria.

SELECT R.Nom
FROM Recintes R, Zones_Recinte Zr
WHERE R.Codi=Zr.Codi_Recinte And R.Ciutat='Barcelona' and Zr.Capacitat >= 
ALL(SELECT Zr2.Capacitat FROM Recintes R2, Zones_Recinte Zr2 WHERE R2.Codi=Zr2.Codi_Recinte and R2.Nom='Vict�ria')
AND R.Nom <> 'Vict�ria'
ORDER BY 1;

//Ciutat que no sigui Barcelona on es realitzen m�s espectacles. 

SELECT DISTINCT R.Ciutat 
FROM Recintes R, Espectacles e
WHERE R.Codi=e.Codi_Recinte And R.Ciutat<>'Barcelona' AND e.Codi>=ALL(SELECT Codi FROM Espectacles)
ORDER BY 1;

//Nom i tipus d'espectacle amb m�s espectadors.

SELECT e.Nom,e.Tipus
FROM Espectacles e, Entrades s
WHERE e.Codi=s.Codi_Espectacle
GROUP BY e.Nom, e.Tipus
HAVING COUNT(*) >=ALL(SELECT COUNT (*)
                        FROM Espectadors es, Entrades ep
                        WHERE es.DNI=ep.DNI_Client
                        GROUP BY ep.Codi_Espectacle)
ORDER BY 1,2;

//Nom, ciutat i capacitat del recinte amb m�s capacitat

SELECT DISTINCT r.Nom, r.Ciutat, SUM(z.Capacitat)
FROM Recintes r, Zones_Recinte z
WHERE r.Codi=z.Codi_Recinte 
GROUP BY r.Nom, r.Ciutat
HAVING SUM(z.Capacitat)>= ALL(SELECT SUM(Capacitat) FROM Recintes r1, Zones_Recinte r2
                                WHERE r1.Codi=r2.Codi_Recinte
                                GROUP BY r1.Codi)
ORDER BY 1,2,3;
//Nom, ciutat i capacitat del recinte amb menys capacitat.

SELECT DISTINCT r.Nom, r.Ciutat, SUM(z.Capacitat)
FROM Recintes r, Zones_Recinte z
WHERE r.Codi=z.Codi_Recinte 
GROUP BY r.Nom, r.Ciutat
HAVING SUM(z.Capacitat)<= ALL(SELECT SUM(Capacitat) FROM Recintes r1, Zones_Recinte r2
                                WHERE r1.Codi=r2.Codi_Recinte
                                GROUP BY r1.Codi)
ORDER BY 1,2,3;


// //Nom de l'espectacle teatral amb m�s espectadors.


SELECT e.Nom, SUM(s.Numero) AS NUM_ESPECT
FROM Espectacles e, Entrades s
WHERE e.Codi = s.Codi_Espectacle and e.Tipus='Teatre'
GROUP BY e.Nom
HAVING COUNT(*) >= ALL (
    SELECT COUNT (*)
    FROM Entrades ep, Espectacles p
    WHERE p.Tipus = 'Teatre'
      AND p.Codi = ep.Codi_Espectacle
    GROUP BY p.Codi
)
ORDER BY 1, 2;

select ES.Nom, sum(EN.Numero) as Num_Espectadors
from Espectacles ES, Entrades EN
where ES.Tipus='Teatre' and EN.Codi_Espectacle=ES.Codi
group by ES.Nom
having count(*) >= all (select count(*) as Total 
                        from  Espectacles ES2, Entrades EN2 
                        where   ES2.Tipus = 'Teatre' and 
                                EN2.Codi_Espectacle=ES2.Codi 
                        group by ES2.Codi)
order by 1;





//Nom de l'espectacle musical amb menys espectadors. 

SELECT e.Nom, SUM(s.Numero) AS NUM_ESPECT
FROM Espectacles e, Entrades s
WHERE e.Codi = s.Codi_Espectacle and e.Tipus='Musical'
GROUP BY e.Nom
HAVING COUNT(*) <= ALL (
    SELECT COUNT (*)
    FROM Espectadors es, Entrades ep, Espectacles p
    WHERE es.DNI = ep.DNI_Client 
      AND p.Tipus = 'Musical'
      AND p.Codi = ep.Codi_Espectacle
    GROUP BY ep.Codi_Espectacle
)
ORDER BY 1, 2;

select ES.Nom, sum(EN.Numero) as Num_Espectadors
from Espectacles ES, Entrades EN
where ES.Tipus='Musical' and EN.Codi_Espectacle=ES.Codi
group by ES.Nom
having count(*) <= all (select count(*) as Total 
                        from Espectacles ES2,Entrades EN2 
                        where   ES2.Tipus = 'Musical' and 
                                EN2.Codi_Espectacle=ES2.Codi 
                        group by ES2.Codi)
order by 1;


//Codi, nom i ciutat del recinte que ha tingut m�s representacions. Mostra tamb� el nombre de representacions. 

SELECT r.Codi, r.Nom, r.Ciutat, COUNT(*) AS NUM_REP
FROM Recintes r, Representacions Rp, Espectacles p
WHERE r.Codi=p.Codi_Recinte and p.Codi=Rp.Codi_Espectacle
GROUP BY r.Codi, r.Nom, r.Ciutat
HAVING COUNT(*)>= ALL(SELECT COUNT(*) FROM representacions GROUP BY Codi_Espectacle)
ORDER BY 1,2,3;

//Seient (zona, fila i n�mero) m�s venut del teatre Vict�ria.

SELECT en.Zona, en.Fila, en.Numero, COUNT(*)
FROM Entrades en, Recintes re
WHERE re.Nom='Vict�ria' and en.Codi_Recinte=re.Codi
GROUP BY en.Zona, en.Fila, en.Numero
HAVING COUNT(*)>=ALL(SELECT COUNT(*)
                FROM Entrades en, Recintes re
                WHERE en.Codi_Recinte=re.Codi and re.Nom='Vict�ria'
                GROUP BY en.Zona, en.Fila, en.Numero)
ORDER BY 1,2,3;


SELECT en.Zona
FROM Entrades en, Recintes re
WHERE en.Codi_Recinte=re.Codi
GROUP BY en.Zona
HAVING COUNT(*)>=ALL(SELECT COUNT(*)
                FROM Entrades en, Recintes re
                WHERE en.Codi_Recinte=re.Codi
                GROUP BY en.Zona)
ORDER BY 1;


//Codi i nom del recinte on s'han fet m�s representacions

SELECT r.Codi, r.Nom, COUNT(*) AS NUM_REP
FROM Espectacles Ec, Representacions Rp, Recintes r
WHERE Ec.Codi=Rp.Codi_Espectacle and r.Codi=Ec.Codi_Recinte
GROUP BY r.Codi, r.Nom
HAVING COUNT(*)>= ALL(SELECT COUNT(*) FROM representacions GROUP BY Codi_Espectacle)
ORDER BY 1,2;

//Representaci� amb m�s entrades venudes

SELECT e.Codi, 
       to_Char(s.Data, 'dd/mm/yyyy'), 
       to_Char(s.Hora, 'hh24:mi:ss'), 
       e.Interpret, r.Codi
FROM Espectacles e, Entrades s, Recintes r
WHERE e.Codi = s.Codi_Espectacle and r.Codi=s.Codi_Recinte
GROUP BY e.Codi, s.Data, s.Hora, e.Interpret, r.Codi
HAVING COUNT(*) >= ALL (
    SELECT COUNT (*)
    FROM Recintes r, Entrades ep, Espectacles p
    WHERE p.Codi_Recinte=r.Codi 
      AND p.Codi = ep.Codi_Espectacle
    GROUP BY p.Codi, ep.Data, ep.Hora, p.Interpret, r.Codi
)
ORDER BY 1, 2,3,4,5;

//Espectador que ha comprat m�s entrades del teatre La Far�ndula de Sabadell

SELECT r.DNI, r.Nom, r.Cognoms, COUNT(*) AS NUM_ENTRADES
FROM Espectadors r, Entrades s, Recintes p
WHERE r.DNI=s.DNI_Client and p.Nom='La Far?ndula' and p.Codi=s.Codi_Recinte and 
p.Ciutat='Sabadell'
GROUP BY r.DNI, r.Nom, r.Cognoms
HAVING COUNT(*)>= ALL(SELECT COUNT(*) 
                FROM Recintes r, Entrades e, Espectadors p
                WHERE r.Codi=e.Codi_Recinte and p.DNI=e.DNI_Client
                and r.Ciutat='Sabadell'and r.Nom='La Far?ndula'
                GROUP BY p.DNI, p.Nom, p.Cognoms)
ORDER BY 1,2,3,4;

//Espectador que ha comprat m�s entrades dels espectacles celebrats als recintes de Barcelona.

SELECT r.DNI, r.Nom, r.Cognoms, COUNT(*)
FROM Espectadors r, Entrades s, Recintes p
WHERE r.DNI = s.DNI_Client
  AND p.Codi = s.Codi_Recinte
  AND p.Ciutat = 'Barcelona' 
GROUP BY r.DNI, r.Nom, r.Cognoms
HAVING COUNT(*) >= ALL (
  SELECT COUNT(*) 
  FROM Recintes r1, Entrades s1, Espectadors p1
  WHERE r1.Codi = s1.Codi_Recinte
    AND p1.DNI = s1.DNI_Client
    AND r1.Ciutat = 'Barcelona'
  GROUP BY p1.DNI
)
ORDER BY 1, 2, 3, 4;

//Espectador que ha adquirit m�s entrades per a qualsevol espectacle

SELECT DISTINCT r.DNI, r.Nom, r.Cognoms, COUNT(*) AS NUM_ENTRADES
FROM Espectadors r, Entrades s
WHERE r.DNI=s.DNI_Client
GROUP BY r.DNI, r.Nom, r.Cognoms
HAVING COUNT(*)>= ALL(SELECT COUNT(*) FROM Entrades GROUP BY DNI_Client)
ORDER BY 1,2,3,4;


//Recaptaci� m�s gran per un espectacle.

SELECT DISTINCT SUM(P.Preu)
FROM Espectacles Es, Preus_Espectacles P, Entrades En
WHERE Es.Codi = P.Codi_Espectacle and En.Codi_Espectacle = Es.Codi
GROUP BY Es.Nom, Es.Interpret, P.Preu
HAVING SUM(P.Preu)>= ALL(SELECT SUM(P1.Preu)
                    FROM Espectacles Esl, Preus_Espectacles P1, Entrades Enl
                    WHERE P1.Codi_Espectacle = Esl.Codi and Enl.Codi_Espectacle= Esl.Codi
                    GROUP BY Esl.Nom, Esl.Interpret, P1.Preu)
ORDER BY 1;

//Espectacle amb la major recaptaci�

SELECT DISTINCT Es.Nom, Es.Interpret, SUM(P.Preu)
FROM Espectacles Es, Preus_Espectacles P, Entrades En
WHERE Es.Codi = P.Codi_Espectacle and En.Codi_Espectacle = Es.Codi
GROUP BY Es.Nom, Es.Interpret, P.Preu
HAVING SUM(P.Preu)>= ALL(SELECT SUM(P1.Preu)
                    FROM Espectacles Esl, Preus_Espectacles P1, Entrades Enl
                    WHERE P1.Codi_Espectacle = Esl.Codi and Enl.Codi_Espectacle= Esl.Codi
                    GROUP BY Esl.Nom, Esl.Interpret, P1.Preu)
ORDER BY 1,2,3;


//Recaptaci� m�s gran per a una representaci�

SELECT DISTINCT SUM(P.Preu)
FROM Representacions R, Preus_Espectacles P, Entrades En
WHERE R.Codi_Espectacle = P.Codi_Espectacle 
    AND En.Codi_Espectacle = R.Codi_Espectacle
    AND R.Data = En.Data
    AND R.Hora = En.Hora
    AND P.Zona = En.Zona
GROUP BY R.Data, R.Hora
HAVING SUM(P.Preu) >= ALL(SELECT SUM(P1.Preu)
                    FROM Representacions R1, Preus_Espectacles P1, Entrades En1
                    WHERE P1.Codi_Espectacle = R1.Codi_Espectacle 
                        AND En1.Codi_Espectacle = R1.Codi_Espectacle
                        AND R1.Data = En1.Data
                        AND R1.Hora = En1.Hora
                        AND En1.Zona = P1.Zona
                    GROUP BY R1.Data, R1.Hora)
ORDER BY 1;


//Representaci� amb la major recaptaci�.

SELECT DISTINCT Es.Codi, to_Char(R.Data, 'dd/mm/yyyy'), to_Char(R.Hora, 'hh24:mi:ss'), Es.Interpret, Re.Nom, SUM(P.Preu)
FROM Representacions R, Preus_Espectacles P, Entrades En, Espectacles Es, Recintes Re
WHERE R.Codi_Espectacle = P.Codi_Espectacle 
    AND En.Codi_Espectacle=R.Codi_Espectacle
    AND Es.Codi=En.Codi_Espectacle
   AND Es.Codi_Recinte=Re.Codi
    AND R.Data=En.Data
    AND R.Hora=En.Hora
    AND P.Zona=En.Zona
GROUP BY Es.Codi, Es.Interpret, Re.Nom, R.Data, R.Hora
HAVING SUM(P.Preu)>= ALL(SELECT SUM(PL.PREU)
FROM Representacions r, Preus_Espectacles PL, Entrades en, Espectacles el, Recintes re
WHERE PL.Codi_Espectacle=r.Codi_Espectacle
AND en.Codi_Espectacle=r.Codi_Espectacle
AND el.Codi=en.Codi_Espectacle
AND el.Codi_Recinte=re.Codi
AND r.Data=en.Data
AND r.Hora=en.Hora
AND PL.Zona=en.Zona
GROUP BY el.Codi, el.Interpret, re.Nom, r.Data, r.Hora)
ORDER BY 1,2,3,4,5,6;
                     


//Nom, tipus d'espectacle, data i hora de la representaci� amb m�s espectadors.

SELECT DISTINCT e.Nom, e.Tipus, to_Char(s.Data, 'dd/mm/yyyy') AS Data, to_Char(s.Hora, 'hh24:mi:ss') AS Hora
FROM Espectacles e, Entrades s
WHERE e.Codi = s.Codi_Espectacle
GROUP BY e.Nom, e.Tipus, s.Data, s.Hora
HAVING COUNT(*) >= ALL (
    SELECT COUNT (*)
    FROM Entrades ep, Espectacles p
    WHERE p.Codi = ep.Codi_Espectacle
    GROUP BY p.Nom, p.Tipus, ep.Data, ep.Hora
)
ORDER BY 1, 2,3,4;

//Preu mitj� dels espectacles per nombre de representacions

SELECT T1.Sum_Preus/T2.Rep_Total
FROM (SELECT SUM( Preu) as Sum_Preus FROM Preus_Espectacles)T1, (SELECT DISTINCT COUNT(*) as Rep_Total FROM Representacions)T2;

//Mitjana d'ocupaci� de tots els espectacles. Es calcula dividint la suma de totes 
//les entrades venudes en el nombre total de seients disponibles a la base de dades

SELECT T2.Espectacle_Codi/T1.Total_Seients As mitjana
FROM (SELECT COUNT(Numero) as Total_Seients FROM Seients)T1, (SELECT Count(Codi_Espectacle) as Espectacle_Codi FROM Entrades)T2;

//Mitjana d'espectadors per representaci�
SELECT T2.Total_Espectadors/T1.Total_Espectacles As mitjana
FROM (SELECT COUNT( Codi_Espectacle) as Total_Espectacles FROM Representacions)T1, (SELECT COUNT(DNI_Client) as Total_espectadors FROM Entrades)T2;



//Espectadors (DNI, nom i cognoms) que no han vist cap espectacle de El Tricicle.
//be be
SELECT DISTINCT e.DNI, e.Nom, e.Cognoms
FROM Espectadors e
WHERE e.DNI NOT IN (
    SELECT EN2.DNI_Client
    FROM Entrades EN2, Espectacles ES
    WHERE ES.Interpret = 'El Tricicle' and EN2.Codi_Espectacle = ES.Codi 
)
ORDER BY 1, 2, 3;

//Intèrprets que van actuar al teatre Municipal però no van actuar mai al teatre Romea.
//no fer minus perque es el mateix interpret
//be be
SELECT DISTINCT e.Interpret
FROM Espectacles e, Recintes r 
WHERE e.Codi_Recinte = r.Codi and r.Nom = 'Municipal'
AND e.Interpret NOT IN (
    SELECT e2.Interpret
    FROM Espectacles e2, Recintes r2
    WHERE r2.Nom = 'Romea' and e2.Codi_Recinte = r2.Codi
)
ORDER BY 1;

//Recintes on ha actuat El Tricicle però on mai va actuar la Lola Herrera
//be be
SELECT DISTINCT r.Nom
FROM Recintes r, Espectacles s
WHERE s.Codi_Recinte = r.Codi and s.Interpret = 'El Tricicle'
AND r.Codi NOT IN (
    SELECT e2.Codi_Recinte
    FROM Espectacles e2, Recintes r2 
    WHERE e2.Codi_Recinte = r2.Codi and e2.Interpret = 'Lola Herrera'
)
ORDER BY 1;

//Seients que només s'han ocupat l'any 2021
(SELECT codi_recinte, zona, fila, numero
FROM ENTRADES 
WHERE to_char(data,'YYYY')='2021')
EXCEPT
(SELECT codi_recinte, zona, fila, numero
FROM ENTRADES 
WHERE to_char(data,'YYYY')<>'2021')
ORDER BY 1,2,3,4;


//Seients (zona, fila i número) que no s'han ocupat en cap de les representacions d'El país de les cent paraules.
//be be
(select distinct se.Zona, se.Fila, se.Numero
from Espectacles es, Seients se
where es.codi_recinte=se.codi_recinte and es.nom='El pa?s de les Cent Paraules')
minus
(select en2.Zona, en2.Fila, en2.Numero
from Entrades en2, Espectacles es2
where es2.codi=en2.codi_espectacle and es2.nom='El pa?s de les Cent Paraules')
ORDER BY 1,2,3;

///Seients lliures (zona, fila i número) per anar a veure Hamlet el dia 6 d'abril de 2022
//be be
(select distinct se.zona, se.fila, se.numero
from espectacles es, seients se, representacions rep
where es.codi_recinte=se.codi_recinte and rep.codi_espectacle=es.codi 
and to_char(rep.data,'dd/mm/yyyy')='06/04/2022' and es.nom='Hamlet')
minus
(select distinct en.zona, en.fila, en.numero
from entrades en, espectacles es
where es.codi=en.codi_espectacle and es.nom='Hamlet' and 
to_char(en.data,'dd/mm/yyyy')='06/04/2022')
ORDER BY 1,2,3;

//Nom i adreça dels recintes de Barcelona sense cap representació durant el gener del 2022. 
//be be
SELECT DISTINCT R.Nom, R.Adre�a
FROM Recintes R
WHERE R.Ciutat = 'Barcelona'
AND R.Codi NOT IN (
    SELECT DISTINCT e.Codi_Recinte
    FROM Espectacles e, Representacions p, Recintes r
    WHERE e.Codi_Recinte=r.Codi and p.Codi_Espectacle=e.Codi and to_Char(p.Data,'mm/yyyy') ='01/2022'
)
ORDER BY 1,2;

//Quantitat total de seients que mai han estat ocupats.
//be be
SELECT COUNT(*) AS Quantitat_Total_Seients
FROM Seients S
WHERE NOT EXISTS (
    SELECT 1
    FROM Entrades E
    WHERE E.Codi_Recinte = S.Codi_Recinte
      AND E.Zona = S.Zona
      AND E.Fila = S.Fila
      AND E.Numero = S.Numero
);

//Seients que mai van ser ocupats al mes de gener. Atributs de sortida: codi de recinte, zona, fila i n�mero.
SELECT DISTINCT r.Codi, s.Zona, s.Fila, s.Numero
FROM Seients S, Recintes r, Representacions p
WHERE to_Char(p.Data, 'mm')='01' and NOT EXISTS (
    SELECT 1
    FROM Entrades E, Representacions r
    WHERE E.Codi_Recinte = S.Codi_Recinte
      AND E.Zona = S.Zona
      AND E.Fila = S.Fila
      AND E.Numero = S.Numero
      AND to_Char(r.Data, 'mm')='01'
      AND r.Codi_Espectacle=E.Codi_Espectacle
)
ORDER BY 1,2,3,4;


//Representacions on no s'ha venut cap entrada.
//be be
SELECT DISTINCT Codi_Espectacle, to_Char(Data, 'dd/mm/yyyy'), to_Char(Hora, 'hh24:mi:ss')
FROM Representacions R
WHERE (Codi_Espectacle, Data, Hora) NOT IN (
    SELECT Codi_Espectacle, Data, Hora
    FROM Entrades E
)
ORDER BY 1,2,3;


//Recintes que han tingut alguna representació sense públic.
//be be
SELECT DISTINCT r.Nom
FROM (SELECT r.Codi_Espectacle as mycode FROM Representacions r WHERE (R.Codi_Espectacle, r.Data, r.Hora) 
not in (SELECT e.Codi_Espectacle, e.Data,e.Hora FROM Entrades e)) T1, Recintes r, Espectacles e
WHERE T1.mycode=e.Codi and e.Codi_Recinte=r.Codi
ORDER BY 1;


//Espectacles que han rebut espectadors tant de Sabadell com de Barcelona l'any 2021 (no necessàriament alhora).
//BE be
(select distinct ep.nom
from espectacles ep, entrades en, espectadors es, representacions r
where ep.codi = en.codi_espectacle and
      es.dni = en.dni_client and
      r.Codi_Espectacle=ep.Codi and 
      es.ciutat = 'Barcelona' and to_Char(r.Data, 'yyyy')='2021')
      
intersect      

(select distinct ep.nom
from espectacles ep, entrades en, espectadors es, representacions r
where ep.codi = en.codi_espectacle and
      es.dni = en.dni_client and
        r.Codi_Espectacle=ep.Codi and 
      es.ciutat = 'Sabadell' and to_Char(r.Data, 'yyyy')='2021')
      
ORDER BY 1;

//Espectacles que entre els preus inclouen seients de 15 euros i també de 21 euros.
//be be
(SELECT Es.Nom
FROM Espectacles Es, Preus_Espectacles P
WHERE Es.Codi = P.Codi_Espectacle AND P.Preu = '15')
INTERSECT
(SELECT Es.Nom
FROM Espectacles Es, Preus_Espectacles P
WHERE Es.Codi = P.Codi_Espectacle AND P.Preu = '21')
ORDER BY 1;

//Espectadors que han comprat entrades de 15 euros i també de 21 euros
//be be
(SELECT Es.Nom, Es.Cognoms
FROM Entrades En, Preus_Espectacles P, Espectadors Es
WHERE En.Codi_Espectacle = P.Codi_Espectacle AND En.DNI_Client = Es.DNI AND P.Preu = '15')
INTERSECT
(SELECT Es.Nom, Es.Cognoms
FROM Entrades En, Preus_Espectacles P, Espectadors Es
WHERE En.Codi_Espectacle = P.Codi_Espectacle AND En.DNI_Client = Es.DNI AND P.Preu = '21')
ORDER BY 1, 2;

//CORRECTA
(select distinct es.nom, es.cognoms
from espectadors es, entrades en, preus_espectacles pe
where es.dni = en.dni_client and
      en.codi_espectacle = pe.codi_espectacle and
      en.codi_recinte = pe.codi_recinte and
      en.zona = pe.zona and
      pe.preu = 15)
intersect     
(select distinct es.nom, es.cognoms
from espectadors es, entrades en, preus_espectacles pe
where es.dni = en.dni_client and
      en.codi_espectacle = pe.codi_espectacle and
      en.codi_recinte = pe.codi_recinte and
      en.zona = pe.zona and
      pe.preu = 21)
order by 1,2;

//Recintes que han venut més de 30 entrades a l'any 2021, però menys de 15 a l'any 2022.
//be be
(SELECT R.Nom
FROM Recintes R, Entrades En
WHERE R.Codi = En.Codi_Recinte AND to_char(En.Data,'yyyy') = '2021'
GROUP BY R.Nom
HAVING COUNT(*) > '30')
INTERSECT
(SELECT R.Nom
FROM Recintes R, Entrades En
WHERE R.Codi = En.Codi_Recinte AND to_char(En.Data,'yyyy') = '2022'
GROUP BY R.Nom
HAVING COUNT(*) < '15')
ORDER BY 1;

//Els recintes tenen zones amb diferents capacitats
//inclouen zones amb capacitat tant de 10 com de 20 persones, a més de recintes que inclouen zones amb capacitat tant de 10 com de 30 persones.
(SELECT re.nom
FROM RECINTES re, ZONES_RECINTE z
WHERE re.codi=z.Codi_Recinte AND z.Capacitat=10)
INTERSECT
(SELECT re.nom
FROM RECINTES re, ZONES_RECINTE zo
WHERE re.codi=zo.codi_recinte AND 
(zo.capacitat=20 OR zo.capacitat=30))
ORDER BY 1;

//Espectacles que hagin rebut espectadors tant de Barcelona com de Sabadell 
//(no necessàriament alhora), però que mai han rebut ningú de Cerdanyola.
//BE be
(select distinct ep.nom
from espectacles ep, entrades en, espectadors es
where ep.codi = en.codi_espectacle and
      es.dni = en.dni_client and
      es.ciutat = 'Barcelona')
      
intersect      

(select distinct ep.nom
from espectacles ep, entrades en, espectadors es
where ep.codi = en.codi_espectacle and
      es.dni = en.dni_client and
      es.ciutat = 'Sabadell')
      
MINUS

(select distinct ep.nom
from espectacles ep, entrades en, espectadors es
where ep.codi = en.codi_espectacle and
      es.dni = en.dni_client and
      es.ciutat = 'Cerdanyola')
order by 1;


//Seients que van ser comprats per tots dos, espectadors de Sabadell i de Barcelona, 
//però mai van ser comprats per espectadors de Cerdanyola.
//be be
(select distinct en.codi_recinte, en.zona, en.fila, en.numero
from entrades en, espectadors es
where es.dni = en.dni_client and
      es.ciutat = 'Barcelona')
      
intersect

(select distinct en.codi_recinte, en.zona, en.fila, en.numero
from entrades en, espectadors es
where es.dni = en.dni_client and
      es.ciutat in ('Sabadell'))    
      
minus 

(select distinct en.codi_recinte, en.zona, en.fila, en.numero
from entrades en, espectadors es
where es.dni = en.dni_client and
      es.ciutat in ('Cerdanyola')) 


order by 1,2,3,4;


//Seients que mai van ser ocupats al mes de gener. Atributs de sortida: codi de recinte, zona, fila i n�mero.
(select distinct en.codi_recinte, en.zona, en.fila, en.numero
from Entrades en, Espectadors es
where es.DNI = en.DNI_Client) 
minus
(select distinct en.codi_recinte, en.zona, en.fila, en.numero
from Entrades en, Espectadors es
where es.DNI = en.DNI_Client and to_Char(en.Data, 'mm')='01') 
ORDER BY 1,2,3,4;

-- Seients que mai van ser ocupats al mes de gener. 
-- Atributs de sortida: codi de recinte, zona, fila i n�mero.

SELECT DISTINCT en.codi_recinte, en.zona, en.fila, en.numero
FROM Entrades en
JOIN Espectadors es ON es.DNI = en.DNI_Client
WHERE NOT EXISTS (
    SELECT 1
    FROM Entrades en_jan
    WHERE en_jan.DNI_Client = en.DNI_Client AND to_Char(en_jan.Data, 'mm') = '01'
)
ORDER BY 1, 2, 3, 4;

-- Recintes amb capacitat entre 60 i 80 espectadors.
-- Atributs de sortida: nom del recinte.

SELECT r.Nom
FROM Recintes r
JOIN Zones_Recinte z ON r.Codi = z.Codi_Recinte
WHERE z.Capacitat BETWEEN 60 AND 80
ORDER BY r.Nom;




//Representacions d'espectacles (nom de l'espectacle, data i hora) en qu� s'han venut totes les entrades
//BE BE
SELECT Es.Nom, to_char(R.Data,'dd/mm/yyyy'), to_char(R.Hora,'hh24:mi:ss')
FROM Espectacles Es, Representacions R, Recintes Re
WHERE Es.Codi = R.Codi_Espectacle AND Re.Codi = Es.Codi_Recinte
    AND Re.Codi NOT IN (SELECT S.Codi_Recinte
                    FROM Seients S
                    WHERE S.Codi_Recinte = Re.Codi
                        AND S.Codi_Recinte NOT IN (SELECT En.Codi_Recinte
                                        FROM Entrades En
                                        WHERE En.Codi_Recinte = Re.Codi
                                            AND En.data = R.data
                                            AND En.hora = R.hora
                                            AND En.fila = S.fila
                                            AND En.numero = S.numero))
ORDER BY 1,2,3;

//DNI, nom i cognoms dels espectadors que han assistit a tots els espectacles que 
//s'han realitzat al teatre Municipal de Girona l'any 2021.
//be be
SELECT es.DNI, es.Nom, es.Cognoms
FROM Espectadors es
WHERE es.DNI IN (
    SELECT en.DNI_Client
    FROM Entrades en
    WHERE en.Codi_Espectacle IN (
        SELECT ep.Codi
        FROM Espectacles ep
        WHERE ep.Codi_Recinte = (
            SELECT re.Codi
            FROM Recintes re
            WHERE re.Nom = 'Municipal'
        )
    )
    GROUP BY en.DNI_Client
    HAVING COUNT(DISTINCT en.Codi_Espectacle) = (
        SELECT COUNT(DISTINCT ep.Codi)
        FROM Espectacles ep
        WHERE ep.Codi_Recinte = (
            SELECT re.Codi
            FROM Recintes re
            WHERE re.Nom = 'Municipal'
        )
    )
)
ORDER BY 1,2,3;

//Zona, fila i número dels seients que s'han ocupat sempre en totes les representacions de l'espectacle Els Pastorets.
//be be
SELECT DISTINCT S.Zona, S.Fila, S.Numero
FROM Seients S, Espectacles P
WHERE P.Nom = 'Els Pastorets'
AND NOT EXISTS (
    SELECT 1
    FROM Representacions R
    WHERE R.Codi_Espectacle = P.Codi
      AND NOT EXISTS (
          SELECT 1
          FROM Entrades E
          WHERE E.Codi_Recinte = S.Codi_Recinte
            AND E.Zona = S.Zona
            AND E.Fila = S.Fila
            AND E.Numero = S.Numero
            AND E.Data = R.Data
            AND E.Hora = R.Hora
      )
)
ORDER BY 1, 2, 3;


//Zones del recinte on es representa l'espectacle Mar i Cel amb tots els seients ocupats 
//per a la representació del dia 2 de març del 2022
//be be
SELECT DISTINCT Z.Zona
FROM Zones_Recinte Z
WHERE Z.Zona NOT IN (
    SELECT S.Zona
    FROM Seients S
    WHERE S.Codi_Recinte = Z.Codi_Recinte
      AND S.Zona = Z.Zona
      AND S.Zona NOT IN (
          SELECT E.Zona
          FROM Entrades E, Espectacles p
          WHERE E.Codi_Recinte = S.Codi_Recinte
          and p.Nom='Mar i Cel'
            AND E.Zona = S.Zona
            AND E.Fila = S.Fila
            AND E.Numero = S.Numero
            AND to_char(E.Data,'dd/mm/yyyy') = '02/03/2022'))
ORDER BY 1;

//Espectadors (DNI, nom i cognoms) que han vist tots els espectacles del teatre Victòria.
//be be
SELECT es.DNI, es.Nom, es.Cognoms
FROM Espectadors es
WHERE es.DNI IN (
    SELECT en.DNI_Client
    FROM Entrades en
    WHERE en.Codi_Espectacle IN (
        SELECT ep.Codi
        FROM Espectacles ep
        WHERE ep.Codi_Recinte = (
            SELECT re.Codi
            FROM Recintes re
            WHERE re.Nom = 'Vict�ria'
        )
    )
    GROUP BY en.DNI_Client
    HAVING COUNT(DISTINCT en.Codi_Espectacle) = (
        SELECT COUNT(DISTINCT ep.Codi)
        FROM Espectacles ep
        WHERE ep.Codi_Recinte = (
            SELECT re.Codi
            FROM Recintes re
            WHERE re.Nom = 'Vict�ria'
        )
    )
)
ORDER BY es.DNI, es.Nom, es.Cognoms;

//DNI, Nom i cognoms dels espectadors que han comprat entrades per a tots els recintes del Vallès i el Pirineu 
//(Sant Cugat del Vallès, Sabadell, La Seu d'Urgell).
//be be
SELECT DISTINCT es.DNI, es.Nom, es.Cognoms
FROM Espectadors es
WHERE NOT EXISTS (
    SELECT re.Codi
    FROM Recintes re
    WHERE re.Ciutat IN ('Sant Cugat del Vall�s', 'Sabadell', 'La Seu d''Urgell')
    EXCEPT
    SELECT en.Codi_Recinte
    FROM Entrades en
    WHERE en.DNI_Client = es.DNI
)
ORDER BY 1, 2, 3;








//Quantitat total d'entrades comprades pels espectadors de Barcelona. Atributs de sortida: num_entradas.
SELECT COUNT(*) AS num_entradas
 FROM Entrades e, Espectadors p
 WHERE e.DNI_Client= p.DNI and p.Ciutat='Barcelona'
 ORDER BY 1
 
 //Nom dels espectacles que s'han representat a Barcelona, amb els respectius totals d'entrades venudes. Atributs de sortida: nom de l'espectacle, n�mero d'entrades.
 SELECT DISTINCT c.Nom, count(e.Numero) as Num_Entrades
FROM Espectacles c, Recintes r, Entrades e
WHERE r.Ciutat='Barcelona' AND c.Codi_Recinte=r.Codi and e.Codi_Espectacle= c.Codi and e.Codi_Recinte=r.Codi
GROUP BY c.Nom
ORDER BY 1,2

//Recintes amb capacitat entre 60 i 80 espectadors (capacitat m�s gran o igual que 60 i menor o igual que 80). Atributs de sortida: nom del recinte.
(SELECT r.Nom
FROM Recintes r, Zones_Recinte z
WHERE r.Codi=z.Codi_Recinte and z.Capacitat>='60')
intersect
(SELECT r.Nom
FROM Recintes r, Zones_Recinte z
WHERE r.Codi=z.Codi_Recinte and z.Capacitat<='80')
ORDER BY 1

//Espectadors que han assistit a alguna de les representacions a qu� ha assistit Luis Mar�n Badia (no necess�riament alhora). Atributs de sortida: nom, cognoms.
SELECT DISTINCT e.Nom, e.Cognoms
FROM Espectadors e
JOIN Entrades s ON e.DNI = s.DNI_Client
JOIN Representacions r ON r.Codi_Espectacle = s.Codi_Espectacle
WHERE r.Codi_Espectacle IN (
    SELECT DISTINCT r.Codi_Espectacle
    FROM Espectadors e, Representacions r
    WHERE e.Nom = 'Luis' AND e.Cognoms = 'Mar�n Badia'
)
ORDER BY 1, 2

//Zona m�s popular (de la qual se n'han venut m�s entrades, sense tenir en compte l'espectacle ni el recinte). Atributs de sortida: zona.
SELECT en.Zona
FROM Entrades en
GROUP BY en.Zona
HAVING COUNT(*) >= ALL (
    SELECT COUNT(*)
    FROM Entrades
    GROUP BY Zona
)
ORDER BY 1

//Mitjana d'espectadors per espectacle a Barcelona. Es calcula dividint el nombre total d'entrades venudes al nombre total d'espectacles, considerant nom�s la ciutat de Barcelona. Atributs de sortida: Mitjana d'espectadors.

SELECT T1.Tot_Entrada/T2.tot_Espect as mitjana
FROM (SELECT COUNT(*) AS Tot_Entrada FROM Entrades)T1, (SELECT COUNT(*) AS Tot_Espect FROM Espectacles e, Recintes r WHERE r.Ciutat='Barcelona' and r.Codi=e.Codi_Recinte)T2


//Espectadors que hagin comprat entrades de Pis i de Platea (no necess�riament del mateix recinte o espectacle). Atributs de sortida: Nom i cognoms dels espectadors.
(SELECT DISTINCT e.Nom, e.Cognoms 
FROM Espectadors e, Entrades en, Zones_Recinte z
WHERE e.DNI=en.DNI_Client and z.Zona='Platea')
intersect
(SELECT DISTINCT e.Nom, e.Cognoms 
FROM Espectadors e, Entrades en, Zones_Recinte z
WHERE e.DNI=en.DNI_Client and z.Zona='Pis')
ORDER BY 1,2

//Seients que mai van ser ocupats al mes de gener. Atributs de sortida: codi de recinte, zona, fila i n�mero.
SELECT DISTINCT en.codi_recinte, en.zona, en.fila, en.numero
FROM Entrades en
JOIN Espectadors es ON es.DNI = en.DNI_Client
WHERE NOT EXISTS (
    SELECT 1
    FROM Entrades en_jan
    WHERE en_jan.DNI_Client = en.DNI_Client AND to_Char(en_jan.Data, 'mm') = '01'
)
ORDER BY 1, 2, 3, 4

//Zones del recinte on es representa l'espectacle Mar i Cel amb tots els seients ocupats per a la representaci� del dia 2 de mar� del 2022. Atributs de sortida: Zona.

SELECT DISTINCT Z.Zona
FROM Zones_Recinte Z
WHERE Z.Zona NOT IN (
    SELECT S.Zona
    FROM Seients S
    WHERE S.Codi_Recinte = Z.Codi_Recinte
      AND S.Zona = Z.Zona
      AND S.Zona NOT IN (
          SELECT E.Zona
          FROM Entrades E, Espectacles p
          WHERE E.Codi_Recinte = S.Codi_Recinte
          and p.Nom='Mar i Cel'
            AND E.Zona = S.Zona
            AND E.Fila = S.Fila
            AND E.Numero = S.Numero
            AND to_char(E.Data,'dd/mm/yyyy') = '02/03/2022'))
ORDER BY 1


