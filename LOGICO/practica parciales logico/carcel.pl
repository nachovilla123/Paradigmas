% https://docs.google.com/document/d/12zUNFV4K7Iofc47FN-b7O-gXjTrqgP4dQh47yJVlvw0/edit

% guardia(Nombre)
guardia(bennett).
guardia(mendez).
guardia(george).

% prisionero(Nombre, Crimen)
prisionero(piper, narcotrafico([metanfetaminas])).
prisionero(alex, narcotrafico([heroina])).
prisionero(alex, homicidio(george)).
prisionero(red, homicidio(rusoMafioso)).
prisionero(suzanne, robo(450000)).
prisionero(suzanne, robo(250000)).
prisionero(suzanne, robo(2500)).
prisionero(dayanara, narcotrafico([heroina, opio])).
prisionero(dayanara, narcotrafico([metanfetaminas])).

% controla(Controlador, Controlado)
controla(piper, alex).
controla(bennett, dayanara).

controla(george, dayanara).
controla(mendez, dayanara).

controla(Guardia, Otro):- 
    prisionero(Otro,_),guardia(Guardia), not(controla(Otro, Guardia)).

% con el codigo inicial controla solamente es inversible para su segundo parametro
%agregando guardia(Guardia), se hace totalmente inversible pero bennet es un prisionero y controla a otro. raro

/*conflictoDeIntereses/2: relaciona a dos personas distintas (ya sean guardias o prisioneros) si no se controlan mutuamente y existe algún tercero al cual ambos controlan.*/

conflictoDeIntereses(Uno,Otro):-
    controla(Uno,Tercero),
    controla(Otro,Tercero),
    not(controla(Uno,Otro)),
    not(controla(Otro,Uno)),
    Uno \= Otro.

/*peligroso/1: Se cumple para un preso que sólo cometió crímenes graves.
Un robo nunca es grave.
Un homicidio siempre es grave.
Un delito de narcotráfico es grave cuando incluye al menos 5 drogas a la vez, o incluye metanfetaminas.
*/

peligroso(Preso):-
    prisionero(Preso, _),
   forall(prisionero(Preso, Crimen), grave(Crimen)).

grave(homicidio(_)).
grave(narcotrafico(Drogas)):-
    member(metanfetaminas, Drogas).

grave(narcotrafico(Drogas)):-
    length(Drogas, Cantidad),
    Cantidad >= 5.


%ladronDeGuanteBlanco/1: Aplica a un prisionero si sólo cometió robos y todos fueron por más de $100.000.
monto(robo(Monto),Monto).

ladronDeGuanteBlanco(Preso):-
    prisionero(Preso,_),
    forall(prisionero(Preso,Crimen) ,(monto(Crimen,Monto), Monto>100000)).
    

/*condena/2: Relaciona a un prisionero con la cantidad de años de condena que debe cumplir. Esto se calcula como la suma de los años que le aporte cada crimen cometido, que se obtienen de la siguiente forma:
La cantidad de dinero robado dividido 10.000.
7 años por cada homicidio cometido, más 2 años extra si la víctima era un guardia.
2 años por cada droga que haya traficado.*/

pena(robo(Monto), Pena):-
    Pena is Monto / 10000.
pena(homicidio(Persona), 9):-
    guardia(Persona).
pena(homicidio(Persona), 7):-
    not(guardia(Persona)).
pena(narcotrafico(Drogas),Pena):-
    length(Drogas, Cantidad),
    Pena is Cantidad * 2.

condena(Preso,Condena):-
    prisionero(Preso,_),
    findall(Pena, (prisionero(Preso,Crimen), pena(Crimen,Pena)),Penas),
    sumlist(Penas, Condena).
    
/*capoDiTutiLiCapi/1: Se dice que un preso es el capo de todos los capos cuando nadie lo controla, pero todas las personas de la cárcel (guardias o prisioneros) son controlados por él, o por alguien a quien él controla (directa o indirectamente).*/

persona(Persona):- prisionero(Persona,_).
persona(Persona):- guardia(Persona).

%%%%%%%%%%%%%%%%%%%%%%%%%%% RECURSIVIDAD %%%%%%%%%%%%%%%%%%%%%%%%%%%
controlaDirectaOIndirectamente(Capo,Persona):-
    controla(Capo,Persona).

controlaDirectaOIndirectamente(Capo,Persona):-
    controla(Capo,Tercero),controlaDirectaOIndirectamente(Tercero,Otro).

%%%%%%%%%%%%%%%%%%%%%%%%%%% RECURSIVIDAD %%%%%%%%%%%%%%%%%%%%%%%%%%%
capoDiTutiLiCapi(Capo):-
    not(controla(_,Capo)),
    forall(persona(Persona),controlaDirectaOIndirectamente(Capo,Persona)).
