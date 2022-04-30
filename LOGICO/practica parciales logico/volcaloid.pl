%https://docs.google.com/document/d/1xbXPZnhwyK5FSHR_oaXU4esfkTd2S-jf3rH1XLw864M/edit
% De cada vocaloid (o cantante) se conoce el nombre y
% además la canción que sabe cantar. De cada canción se conoce el nombre y 
%a cantidad de minutos de duración.

%vocaloid(nombre, cancion).
%cancion(nombre, duracion en minutos)

vocaloid(megurineLuka, cancion(nightFever, 4)).
vocaloid(megurineLuka, cancion(foreverYoung, 5)).

vocaloid(hatsuneMiku, cancion(tellYourWorld, 4)).

vocaloid(gumi, cancion(foreverYoung, 4)).
vocaloid(gumi, cancion(tellYourWorld, 5)).

vocaloid(seeU , cancion(novemberRain, 6)).
vocaloid(seeU, cancion(nightFever, 5)).


%Casos de prueba inventados ;)
vocaloid(lean, cancion(tellYourWorld, 2)).
vocaloid(lean, cancion(tellYourWorld, 3)).
vocaloid(lean, cancion(tellYourWorld, 2)).
vocaloid(lean, cancion(tellYourWorld, 1)).
vocaloid(lean, cancion(tellYourWorld, 5)).

vocaloid(villon, cancion(cantavillita, 1)).
vocaloid(villon, cancion(pluma, 2)).
vocaloid(villon, cancion(holabilinsky, 3)).

%kaito no sabe cantar nada.

%Punto 1 : novedoso

%novedoso(Nombre)
novedoso(Nombre):-
    %cantante(Nombre),          %es inversible igualmente sin usar esto por los subpredicados
    sabeAlMenosDosCanciones(Nombre),
    duracionTotal(Nombre, Total),
    Total < 15.


sabeAlMenosDosCanciones(Nombre):-
    vocaloid(Nombre, cancion(Cancion1, _)),
    vocaloid(Nombre, cancion(Cancion2, _)),
    Cancion1 \= Cancion2.

duracionTotal(Nombre, Total):-
    findall(Duracion, vocaloid(Nombre, cancion(_, Duracion)), Duraciones),
    sum_list(Duraciones, Total).

cantante(Nombre):- vocaloid(Nombre, _).


%Punto 2 : acelerado
%Todas sus duracions de canciones  <=  4 

acelerado(Nombre):-
    cantante(Nombre),
    not(
        (
            vocaloid(Nombre, cancion(_, Duracion)),
            Duracion > 4
        )
    ). 


%concierto(Nombre, PaisDondeSeRealizara, CantFama, TipoConcierto)
/*
TiposConcierto:
%gigante(CantMinCancionesQtieneUnParticipante, CantidadDada ), del cual DurTotal > CantidadDada.
%mediano(CantidadDada),           DurTotal < CantidadDada
%pequenio(CantidadDada),          Dur alguna de sus caciones > CantDada
*/
concierto(mikuExpo, estadosUnidos, 2000, gigante(2, 6)).
concierto(magicalMirai, japon,     3000, gigante(3, 10)).

concierto(vocalektVisions, estadosUnidos, 1000, mediano(9)).

concierto(mikuFest, argentina, 100, pequenio(4)).





%2 
puedeParticipar(Cantante, NombreConcierto):-
    cantante(Cantante),
    Cantante \= hatsuneMiku,                    % solucion para hatsuneMiku, pero capaz innecesario si lo arreglo seteando la lista
    concierto(NombreConcierto, _, _, TipoConcierto),
    cumpleExigencia(Cantante, TipoConcierto).

puedeParticipar(hatsuneMiku, NombreConcierto):-         %este puede participar en cualquier concierto.
    concierto(NombreConcierto, _, _, _).

%gigante(CantMinCancionesQtieneUnParticipante, CantidadDada ), del cual DurTotal > CantidadDada.
cumpleExigencia(Nombre, gigante(CantMin, CantDada)):-     
    sabeTantasCanciones(Nombre, CantCancionesQSabe),
    CantCancionesQSabe >= CantMin,

    duracionTotal(Nombre, DurTotal),
    DurTotal > CantDada.

%mediano(TiempoMax),           DurTotal < TiempoMax
cumpleExigencia(Nombre, mediano(TiempoMax)):-
    duracionTotal(Nombre, DurTotal),
    DurTotal < TiempoMax.

%pequenio(CantidadDada),          Dur alguna de sus caciones > CantDada
cumpleExigencia(Nombre, pequenio(TiempoASuperar)):-
    vocaloid(Nombre, cancion(_, Duracion)),
    Duracion > TiempoASuperar.


sabeTantasCanciones(Nombre, CantCancionesQSabe):-
%    cantante(Nombre),
    findall(Cancion, vocaloid(Nombre, cancion(Cancion, _)), Canciones),
    length(Canciones, CantCancionesQSabe). 

%3
/*Conocer el vocaloid más famoso, es decir con mayor nivel de fama. 
El nivel de fama de un vocaloid se calcula como la fama total que le dan los conciertos en los cuales 
puede participar multiplicado por la cantidad de canciones que sabe cantar.
*/

masFamoso(Nombre):-
    cantante(Nombre),
    nivelFama(Nombre, NivelMax),
    forall(
        nivelFama(OtroNombre , OtroNivelFama),
        NivelMax >= OtroNivelFama
    ).

nivelFama(Nombre, Nivel):-
    famaTotal(Nombre, FamaTotal),
    sabeTantasCanciones(Nombre, CantCancionesQSabe),
    Nivel is CantCancionesQSabe * FamaTotal.


famaTotal(Nombre, FamaTotal):-  
    cantante(Nombre), %agrego para inversible
    findall(
        Fama,
        (puedeParticipar(Nombre, Concierto), concierto(Concierto, _, Fama, _)) ,
        Famas),
    list_to_set(Famas, FamasSinRepetir),
    sum_list(FamasSinRepetir, FamaTotal).

famaConcierto(Concierto, Fama):- concierto(Concierto, _, Fama, _).


/*
 famaTotal2(Nombre, FamaTotal):-  
    %cantante(Nombre), %agrego para inversible
    findall(Concierto,  (puedeParticipar(Nombre, Concierto), concierto(Concierto, _, Fama, _)),    Conciertos),
    list_to_set(Conciertos, ConciertosSinRepetir),
    sumaDeFamas(ConciertosSinRepetir, FamaTotal).
sumaDeFamas(Conciertos, FamaTotal):-
    member(Concierto, Conciertos),
    findall(Fama, famaConcierto(Concierto, Fama), Famas).
    sum_list(Famas, FamaTotal).
sumaDeFamas([], 0).
sumaDeFamas([_], 1).*/  

%----------------------------------PUNTO 4 ----------------------------------%
/*Sabemos que:
Queremos verificar si un vocaloid es el único que participa de un concierto, esto se cumple si ninguno de sus conocidos ya sea directo o indirectos (en cualquiera de los niveles) participa en el mismo concierto.*/
conoce(megurineLuka, hatsuneMiku).
conoce(megurineLuka, gumi).
conoce(gumi, seeU).
conoce(seeU, kaito).

unicoEnConcierto(Cantante, Concierto):-
    puedeParticipar(Cantante, Concierto),
    forall(
        conocidos(Cantante,OtroCantante),
        not(puedeParticipar(OtroCantante, Concierto))
    ).

%unicoEnConcierto2(Cantante, Concierto):-
%    puedeParticipar(Cantante, Concierto),
%    conocidos(Cantante, Conocido),
%    Conocido \= Cantante,
%    not(puedeParticipar(Conocido, Concierto)).




conocidos(Cantante,OtroCantante):-      %directos
    conoce(Cantante,OtroCantante).

conocidos(Cantante, OtroCantante):-     %indirectos
    conoce(Cantante,Tercero),
    conocidos(Tercero, OtroCantante).
