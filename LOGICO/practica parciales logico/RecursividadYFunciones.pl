%%%%%%%%%%%%%%%%%%%%%%%%%%% RECURSIVIDAD %%%%%%%%%%%%%%%%%%%%%%%%%%%
controlaDirectaOIndirectamente(Capo,Persona):-
    controla(Capo,Persona).

controlaDirectaOIndirectamente(Capo,Persona):-
    controla(Capo,Tercero),controlaDirectaOIndirectamente(Tercero,Persona).

%%%%%%%%%%%%%%%%%%%%%%%%%%% RECURSIVIDAD %%%%%%%%%%%%%%%%%%%%%%%%%%%
capoDiTutiLiCapi(Capo):-
    not(controla(_,Capo)),
    forall(persona(Persona),controlaDirectaOIndirectamente(Capo,Persona)).



  average(Lista, Promedio):-
    length(Lista, Cantidad),
    sumlist(Lista, Sumatoria),
    Promedio is Sumatoria / Cantidad.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cadenaDeCasas(Magos):-
  forall(consecutivos(Mago1, Mago2, Magos),
         puedenQuedarEnLaMismaCasa(Mago1, Mago2, _)).


%ESTO me devuelve los elementos consecutivos de una lista
consecutivos(Anterior, Siguiente, Lista):-
  nth1(IndiceAnterior, Lista, Anterior),
  IndiceSiguiente is IndiceAnterior + 1,
  nth1(IndiceSiguiente, Lista, Siguiente).

puedenQuedarEnLaMismaCasa(Mago1, Mago2, Casa):-
  puedeQuedarSeleccionadoPara(Mago1, Casa),
  puedeQuedarSeleccionadoPara(Mago2, Casa),
  Mago1 \= Mago2.




/*Punto 4: posibilidades de atención (3 puntos / 1 punto)
Dado un día, queremos relacionar qué personas podrían estar atendiendo el kiosko en algún momento de ese día. Por ejemplo, si preguntamos por el miércoles, tiene que darnos esta combinatoria:
nadie
dodain solo
dodain y leoC
dodain, vale, martu y leoC
vale y martu
etc.

Queremos saber todas las posibilidades de atención de ese día. La única restricción es que la persona atienda ese día (no puede aparecer lucas, por ejemplo, porque no atiende el miércoles).

Punto extra: indique qué conceptos en conjunto permiten resolver este requerimiento, justificando su respuesta.
*/
    % Punto 4: posibilidades de atención (3 puntos / 1 punto)
% Dado un día, queremos relacionar qué personas podrían estar atendiendo el kiosko
% en algún momento de ese día.
posibilidadesAtencion(Dia, Personas):-
  findall(Persona, distinct(Persona, quienAtiende(Persona, Dia, _)), PersonasPosibles),
  combinar(PersonasPosibles, Personas).

combinar([], []).
combinar([Persona|PersonasPosibles], [Persona|Personas]):-combinar(PersonasPosibles, Personas).
combinar([_|PersonasPosibles], Personas):-combinar(PersonasPosibles, Personas).

% Qué conceptos en conjunto resuelven este requerimiento
% - findall como herramienta para poder generar un conjunto de soluciones que satisfacen un predicado
% - mecanismo de backtracking de Prolog permite encontrar todas las soluciones posibles


%%% Sacar repetidos de una lista. %%%
mymember(X,[X|_]) :- !.
mymember(X,[_|T]) :- mymember(X,T).

set([],[]).
set([H|T],[H|Out]) :-
    not(mymember(H,T)),
    set(T,Out).
set([H|T],Out) :-
    mymember(H,T),
    set(T,Out).


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
    
    
    
    
    
    
    





