%  https://docs.google.com/document/d/1BE6MIKzMcQMh_D27sIM3JkcOaZRDjdqAMwqD_udM9ro/edit

%Todos los predicados que se piden a continuación deben ser completamente inversibles.

/*Se tiene la siguiente base de conocimiento en cuanto a los jugadores, con información de cada uno sobre su nombre, ítems que posee, y su nivel de hambre (0 a 10). 
También se tiene información sobre el mapa del juego, particularmente de las distintas secciones del mismo, los jugadores que se encuentran en cada uno, y su nivel de oscuridad (0 a 10).
Por último, se conoce cuáles son los ítems comestibles.*/

%jugador(Jugador,ListaItemns,NivelHambre).
jugador(stuart,[piedra,piedra,piedra,piedra,piedra,piedra,piedra,piedra],3).
jugador(tim,[madera,madera,madera,madera,madera,pan,carbon,carbon,carbon,pollo,pollo],8).
jugador(steve,[madera,carbon,carbon,diamante,panceta,panceta,panceta],2).
jugador(dario,[pollo,panceta],2).

%lugar(Lugar,ListaJugadoresEnElLugar,NivelOscuridad).
lugar(playa,[stuart,tim],2).
lugar(mina,[steve],8).
lugar(bosque,[],6).

comestible(pan).
comestible(panceta).
comestible(pollo).
comestible(pescado).



%a. Relacionar un jugador con un ítem que posee. tieneItem/2
tieneItem(Jugador,Item):-
    jugador(Jugador,ListaItems,_),
    member(Item,ListaItems).

%b. Saber si un jugador se preocupa por su salud, esto es si tiene entre sus ítems más de un tipo de comestible. (Tratar de resolver sin findall) sePreocupaPorSuSalud/1
sePreocupaPorSuSalud(Jugador):-
    jugador(Jugador,ListaItems,_),
    masDe1TipoComestible(ListaItems).
      

masDe1TipoComestible(ListaItems):-
    comestible(Item),
    comestible(OtroItem),
    Item \= OtroItem,
    member(Item, ListaItems),
    member(OtroItem, ListaItems).

%c. Relacionar un jugador con un ítem que existe (un ítem existe si lo tiene alguien), y la cantidad que tiene de ese ítem. Si no posee el ítem, la cantidad es 0. cantidadDeItem/3

cantidadDeItem(Jugador,Item,Cantidad):-
    tieneItem(_,Item),
    jugador(Jugador,_,_),
    findall(Item,tieneItem(Jugador,Item),CantidadItems),
    length(CantidadItems, Cantidad).
    
/*d. Relacionar un jugador con un ítem, si de entre todos los jugadores, es el que más cantidad tiene de ese ítem. tieneMasDe/2

?- tieneMasDe(steve, panceta).
true.
*/

tieneMasDe(Jugador,Item):-
    cantidadDeItem(Jugador,Item,CantidadGanadora),
    forall(cantidadDeItem(_,Item,OtraCantidad), CantidadGanadora>=OtraCantidad).
    
%a. Obtener los lugares en los que hay monstruos. Se sabe que los monstruos aparecen en los lugares cuyo nivel de oscuridad es más de 6. hayMonstruos/1

hayMonstruos(Lugar):-
    lugar(Lugar,_,Oscuridad),Oscuridad>6.

%lugar(bosque,[],6).

%b. Saber si un jugador corre peligro. Un jugador corre peligro si se encuentra en un lugar donde hay monstruos; o si está hambriento (hambre < 4) y no cuenta con ítems comestibles. correPeligro/1

tieneComestibles(ListaItems):-
    comestible(Item),
    member(Item, ListaItems).

correPeligro(Jugador):-
    jugador(Jugador,ListaItems,Hambre),
    not(tieneComestibles(ListaItems)),
    Hambre < 4.

correPeligro(Jugador):-
    lugar(Lugar,ListaJugadores,_),
    hayMonstruos(Lugar),
    member(Jugador,ListaJugadores).

/*
c. Obtener el nivel de peligrosidad de un lugar, el cual es un número de 0 a 100 y se calcula:
- Si no hay monstruos, es el porcentaje de hambrientos sobre su población total.
- Si hay monstruos, es 100.
- Si el lugar no está poblado, sin importar la presencia de monstruos, es su nivel de oscuridad * 10. nivelPeligrosidad/2

?- nivelPeligrosidad(playa,Peligrosidad).
Peligrosidad = 50.
*/
nivelPeligrosidad(Lugar,100):- hayMonstruos(Lugar).

nivelPeligrosidad(Lugar,Peligrosidad):- lugar(Lugar,[],Oscuridad), Peligrosidad is Oscuridad * 10.

nivelPeligrosidad(Lugar,Peligrosidad):-
    lugar(Lugar,_,_),
    not(hayMonstruos(Lugar)),
    cuantosJugadoresEn(Lugar,CantidadJugadores),
    CantidadJugadores > 0,
    cuantosHambrientosEn(Lugar,CantidadHambrientos),
    Peligrosidad is (CantidadHambrientos*100/CantidadJugadores).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
seEncuentraEn(Jugador,Lugar):-
    lugar(Lugar,Jugadores,_),
    member(Jugador, Jugadores).

cuantosJugadoresEn(Lugar,Cantidad):-
    findall(Jugador,seEncuentraEn(Jugador,Lugar),Jugadores),
    list_to_set(Jugadores,JugadoresFilt),
    length(JugadoresFilt, Cantidad).

cuantosHambrientosEn(Lugar,Cantidad):-
    findall(Jugador,hambrientoEnLugar(Lugar,Jugador),Jugadores),
    list_to_set(Jugadores,JugadoresFilt),
    length(JugadoresFilt, Cantidad).

hambrientoEnLugar(Lugar,Jugador):-
    hambriento(Jugador),
    seEncuentraEn(Jugador,Lugar).

hambriento(Jugador):-
    jugador(Jugador,_,NivelHambre),
    NivelHambre < 4.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*3) A construir
El aspecto más popular del juego es la construcción. Se pueden construir nuevos ítems a partir de otros, cada uno tiene ciertos requisitos para poder construirse:
- Puede requerir una cierta cantidad de un ítem simple, que es aquel que el jugador tiene o puede recolectar. Por ejemplo, 8 unidades de piedra.
- Puede requerir un ítem compuesto, que se debe construir a partir de otros (una única unidad).
Con la siguiente información, se pide relacionar un jugador con un ítem que puede construir. puedeConstruir/2 */

item(horno, [ itemSimple(piedra, 8) ]).
item(placaDeMadera, [ itemSimple(madera, 1) ]).
item(palo, [ itemCompuesto(placaDeMadera) ]).
item(antorcha, [ itemCompuesto(palo), itemSimple(carbon, 1) ]).

puedeConstruir(Jugador,ItemElaborado):-
    jugador(Jugador,_,_),
    item(ItemElaborado,Requisitos),
    verificarSiCumple(Requisitos,Jugador).

verificarSiCumple(itemSimple(Elemento,CantidadNecesaria),Jugador):-
    cantidadDeItem(Jugador,Elemento,Cantidad),
    Cantidad>CantidadNecesaria.
%%%%%%%%%%%%%%%
puedeConstruir(Jugador,Item):-
    itemNecesario(itemSimple(ItemNecesario,Cantidad),Item),
    cantidadDeItem(Jugador,ItemNecesario,Cantidad).

puedeConstruir(Jugador,Item):-
    itemNecesario(itemCompuesto(ItemNecesario),Item),
    puedeConstruir(Jugador,ItemNecesario).
    
itemNecesario(ItemNecesario,Item):-
    item(Item,Items),
    member(ItemNecesario, Items).



/*?- puedeConstruir(stuart, horno).
true.
?- puedeConstruir(steve, antorcha).
true.*/

/*Aclaración: Considerar a los componentes de los ítems compuestos y a los ítems simples como excluyentes, es decir no puede haber más de un ítem que requiera el mismo elemento.

*/
