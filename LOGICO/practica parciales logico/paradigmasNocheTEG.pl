%https://docs.google.com/document/d/157fVu--q-qQ3ANgypi9fErT_JqBJxAd8NfosblNjag0/edit#

/*T.E.G.
Nos piden modelar una herramienta para analizar el tablero de un juego de Táctica y Estratégia de Guerra. Para eso ya contamos con los siguientes predicados completamente inversibles en nuestra base de conocimiento:*/

% Se cumple para los jugadores.
jugador(Jugador).
jugador(rojo).

% Relaciona un pais con el continente en el que está ubicado,
ubicadoEn(Pais, Continente).
ubicadoEn(argentina, americaDelSur).

% Relaciona dos jugadores si son aliados.
aliados(UnJugador, OtroJugador).
aliados(rojo, amarillo).

% Relaciona un jugador con un pais en el que tiene ejércitos.
ocupa(Jugador, Pais).
ocupa(rojo, argentina).

% Relaciona dos paises si son limítrofes.
limitrofes(UnPais, OtroPais).
limitrofes(argentina, brasil).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Se pide modelar los siguientes predicados, de forma tal que sean completamente INVERSIBLES:




%tienePresenciaEn/2: Relaciona un jugador con un continente del cual ocupa, al menos, un pais.
tienePresenciaEn(Jugador,Pais):-
    ocupa(Jugador, Pais),
    ubicadoEn(Pais,Continente).


%puedenAtacarse/2: Relaciona dos jugadores si uno ocupa al menos un pais limítrofe a algún pais ocupado por el otro.

puedenAtacarse(Jugador1,Jugador2):-
    ocupa(UnJugador,UnPais),
    ocupa(UnJugador,OtroPais),
    limitrofes(UnPais, OtroPais).

%sinTensiones/2: Relaciona dos jugadores que, o bien no pueden atacarse, o son aliados.

sinTensiones(UnJugador,OtroJugador) :- aliados(UnJugador, OtroJugador).

sinTensiones(UnJugador,OtroJugador) :-
    jugador(UnJugador),jugador(OtroJugador),
    not(puedenAtacarse(UnJugador,OtroJugador)).

%perdió/1: Se cumple para un jugador que no ocupa ningún pais.

perdio(Jugador) :-
    jugador(Jugador),
    not(ocupa(Jugador,_)).

%controla/2: Relaciona un jugador con un continente si ocupa todos los paises del mismo.
controla(Jugador,Continente) :-
    jugador(Jugador), ubicadoEn(_,Continente),
    forall(ubicadoEn(Pais,Continente), ocupa(Jugador,Pais)).
    

%reñido/1: Se cumple para los continentes donde todos los jugadores ocupan algún pais.

renido(Continente):-
    ubicadoEn(_,Continente),
    forall( jugador(Jugador), ( ocupa(Jugador,Pais),ubicadoEn(Pais,Continente) ) ).
    

%atrincherado/1: Se cumple para los jugadores que ocupan paises en un único continente.

atrincherado(Jugador):-
    jugador(Jugador),ubicadoEn(_,Continente),
    forall( ocupa(Jugador,Pais) , ubicadoEn(Pais,Continente) ).
    
atrincherado1(Jugador):-
    jugador(Jugador),ubicadoEn(_,Continente),
    not((ocupa(Jugador,Pais), not(ubicadoEn(Pais,Continente)))).


%puedeConquistar/2: Relaciona un jugador con un continente si no lo controla, pero todos los paises del continente que le falta ocupar son limítrofes a alguno que sí ocupa y pertenecen a alguien que no es su aliado.

puedeConquistar(Jugador,Continente):-
    jugador(Jugador),ubicadoEn(_,Continente),
    not(controla(Jugador,Continente)),
    forall( ( ubicadoEn(Pais, Continente) , not(ocupa(Jugador,Pais) ) ) , puedeAtacar(Jugador,Pais) ).

puedeAtacar(Jugador,PaisAtacado):-
    ocupa(Jugador,PaisPropio),
    limitrofes(PaisAtacado,PaisPropio),
    not((aliados(Jugador,Aliado),ocupa(Aliado,PaisAtacado))).









