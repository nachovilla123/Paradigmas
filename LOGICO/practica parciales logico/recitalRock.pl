%https://docs.google.com/document/d/17rWNL8rdNc-eu7VTuCPgptLhSnRD6FyBZNhYNZ7Hekc/edit

% festival(NombreDelFestival, Bandas, Lugar).
% Relaciona el nombre de un festival con la lista de los nombres de bandas que tocan en él y el lugar dónde se realiza.
festival(lollapalooza, [gunsAndRoses, theStrokes, ..., littoNebbia], hipodromoSanIsidro).

% lugar(nombre, capacidad, precioBase).
% Relaciona un lugar con su capacidad y el precio base que se cobran las entradas ahí.
lugar(hipodromoSanIsidro, 85000, 3000).

% banda(nombre, nacionalidad, popularidad).
% Relaciona una banda con su nacionalidad y su popularidad.
banda(gunsAndRoses, eeuu, 69420).

% entradaVendida(NombreDelFestival, TipoDeEntrada).
% Indica la venta de una entrada de cierto tipo para el festival 
% indicado.
% Los tipos de entrada pueden ser alguno de los siguientes: 
%     - campo
%     - plateaNumerada(Fila)
%     - plateaGeneral(Zona).
entradaVendida(lollapalooza, campo).
entradaVendida(lollapalooza, plateaNumerada(1)).
entradaVendida(lollapalooza, plateaGeneral(zona2)).

% plusZona(Lugar, Zona, Recargo)
% Relacion una zona de un lugar con el recargo que le aplica al precio de las plateas generales.
plusZona(hipodromoSanIsidro, zona1, 1500).

%Itinerante/1: Se cumple para los festivales que ocurren en más de un lugar, pero con el mismo nombre y las mismas bandas en el mismo orden.

itinerante(Festival):-
    festival(Festival,Bandas, Lugar1),
    festival(Festival,Bandas, Lugar2),
    Lugar1 \= Lugar2.


%careta/1: Decimos que un festival es careta si no tiene campo o si es el personalFest.

careta(personalFest).
careta(Festival):-
    festival(Festival,_,_),
    not(entradaVendida(Festival, _)).


%nacAndPop/1: Un festival es nac&pop si no es careta y todas las bandas que tocan en él son de nacionalidad argentina y tienen popularidad mayor a 1000.

%-------------- VERSION 2 -----------%
nacAndPop2(Festival):-
    festival(Festival,Bandas,_),
    not(careta(Festival)),
    forall(
        member(Banda,Bandas),
        (banda(Banda,argentina,Popularidad),Popularidad>1000)
    ).

%sobrevendido/1: Se cumple para los festivales que vendieron más entradas que la capacidad del lugar donde se realizan.
%Nota: no hace falta contemplar si es un festival itinerante.

sobrevendido(Festival):-
    festival(Festival,_,Lugar),
    lugar(Lugar,Capacidad,_),
    findall(Entrada,(entradaVendida(Festival,Entrada)),Entradas).
    length(Entradas, CantidadVentas),
    CantidadVentas>Capacidad.


  
/*recaudaciónTotal/2: Relaciona un festival con el total recaudado con la venta de entradas. Cada tipo de entrada se vende a un precio diferente:
   - El precio del campo es el precio base del lugar donde se realiza el festival.
   - La platea general es el precio base del lugar más el plus que se aplica a la zona. 
   - Las plateas numeradas salen el triple del precio base para las filas de atrás (>10) y 6 veces el precio base para las 10 primeras filas.

Nota: no hace falta contemplar si es un festival itinerante.*/
recaudacionTotal(Festival,TotalRecaudado):-
    festival(Festival,_,Lugar),    
    findall(Precio,(entradaVendida(Festival,Entrada),calculoRecaudacion(Lugar,Entrada,Precio)),Precios),
    sum_list(Precios,TotalRecaudado).

calculoRecaudacion(Lugar,campo,CostoBase):-
    lugar(Lugar,_,CostoBase).

calculoRecaudacion(Lugar,plateaGeneral(Zona),Precio):-
    lugar(Lugar,_,CostoBase),
    plusZona(Lugar, Zona, Plus),
    Precio is CostoBase + Plus.

calculoRecaudacion(Lugar,plateaNumerada(Fila),Precio):-
    lugar(Lugar,_,CostoBase),
    Fila>10,
    Precio is CostoBase * 3.
 
calculoRecaudacion(Lugar,plateaNumerada(Fila),Precio):-
    lugar(Lugar,_,CostoBase),
    Fila =< 10,
    Precio is CostoBase * 6.

entradaVendida1(lollapalooza, campo).
entradaVendida1(lollapalooza, plateaNumerada(1)).
entradaVendida1(lollapalooza, plateaGeneral(zona2)).

%delMismoPalo/2: Relaciona dos bandas si tocaron juntas en algún recital o si una de ellas tocó con una banda del mismo palo que la otra, pero más popular.

tocoCon(Banda,OtraBanda):-
    festival(_,Bandas,_),
    member(Banda,Bandas),
    member(OtraBanda,Bandas),
    OtraBanda \= Banda.

delMismoPalo(Banda,OtraBanda):-tocoCon(Banda,OtraBanda).

delMismoPalo(Banda,OtraBanda):-
    tocoCon(Banda,Tercero),
    masPopular(Tercero,OtraBanda),
    delMismoPalo(Tercero,OtraBanda).

masPopular(Banda,Tercero):-
    banda(Banda,_,PopularidadBanda),
    banda(Tercero,_,PopularidadTercero),
    PopularidadTercero > PopularidadBanda.

