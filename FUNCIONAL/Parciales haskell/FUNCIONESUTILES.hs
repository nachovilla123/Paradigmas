--un valor cumple una lista de condiciones
cumpleLasSiguientes :: [a -> Bool] -> a -> Bool
cumpleLasSiguientes listaDeCondiciones unValor = all ($ unValor) listaDeCondiciones

-- si al menos un valor cumple con toda la lista de condiciones
algunaCumpleLasSiguientes :: [a -> Bool] -> [a] -> Bool
algunaCumpleLasSiguientes listaDeCondiciones listaDeValores = any (cumpleLasSiguientes listaDeCondiciones) listaDeValores

-- hace :
maximoSegun :: Ord b => (a -> b) -> [a] -> a
maximoSegun f = foldl1 (mayorSegun f)

-- dada una funcion y 2 elementos, aplica la funcion y se fija que resultado es mayor o menor          , el resultado de aplicar la funcion debe ser ordenable
mayorSegun :: Ord x => (t -> x) -> (t -> t -> t)
mayorSegun f a b
  | f a > f b = a
  | otherwise = b

-- dice si  un elemento esta entre un minimo y un maximo
between :: (Eq a, Enum a) => a -> a -> a -> Bool
between n m x = elem x [n .. m]

-- ejemplo de como aplicar (tour es una lista de funciones seria : [(Turista->Turista)] a un turista
completarTour ::  Tour -> Turista -> Turista
completarTour tour turista = foldl (flip ($)) turista tour 

--obtener la diferencia entre aplicar la funcion a "algo mas grande" vs "algo mas chico"
deltaSegun :: (a -> Int) -> a -> a -> Int
deltaSegun f algo1 algo2 = f algo1 - f algo2

-- " sacar 10% con numeros enteros de un campo de turista
sacardiezporciento :: Turista -> Turista
sacardiezporciento turista = modificarEstres (subtract (div ( 10* estres turista) 100)) turista

-- dado un criterio, un efecto y una lista modifica a los elementos de esa lista aplicando el efecto a los que cumplen el criterio
afectarALosQueCumplen :: (a -> Bool) -> (a -> a) -> [a] -> [a]
afectarALosQueCumplen criterio efecto lista
  = (map efecto . filter criterio) lista ++ filter (not.criterio) lista

-- repetir infinitamente una funcion
infinitasPlayas :: Tour
infinitasPlayas = repeat irALaPlaya



-- DADAS EN MUMUKI y recordatorios
--concat, que recibe una lista de listas y me da una lista con todos los elementos concatenados;
--reverse, que me devuelve la lista dada vuelta.
{- concat [[1,2],[3],[4,5,6]]
[1,2,3,4,5,6]
 concat ["ar","gent","ina"]
"argentina"
 reverse "waldo"
"odlaw"
 reverse [1,2,3,4]
[4,3,2,1]-}

esMultiploDe numero otronumero = mod numero otronumero == 0

esMultiploDe :: Int -> Int -> Bool  
esMultiploDe num1 = (==0).( rem num1)



-- cuantos cumplen una condicion de una lista
cuantosCumplen :: (a -> Bool) -> [a] -> Int
cuantosCumplen condicion = (length.filter condicion)

-- lista con los que no cumplen condicion
rechazar :: (a->Bool)->[a]->[a]
rechazar condicion lista = filter (not.condicion) lista

-- elemento en una lista?
contiene :: Eq a => a -> [a] -> Bool
contiene elemento lista = elem elemento lista

aplicarAValor val func = func val

--Definí la función pam, que es... como el map pero al revés  : le pasás una lista de funciones y un valor y te devuelve los resultados de aplicar cada una al valor. Ejemplos:
--pam [(+3), (*2)] 2 
--[5, 4]
 --pam [id, not, not] True 
--[True, False, False]
pam :: [(a -> b)] -> a -> [b]
pam listafunciones val = map (aplicarAValor val) funciones


--Definir la función aparearCon usando foldr, que aparea 2 listas segun una función

{-Main> aparearCon (+) [1,2,3] [4,5,6]
[5,7,9]
Main> aparearCon (++) ["Hola", "Chau"] ["Homero", "Bart"]
["HolaHomero", "ChauBart"]           -}
aparearCon :: (a->a->a) -> [a] -> [a] -> [a]
aparearCon funcion lista1 lista2 = foldr (\(x,y) semilla -> funcion x y : semilla) [] (zip lista1 lista2)



minimoSegun :: Ord b => (a -> b) -> [a] -> a
minimoSegun f = foldl1 (menorSegun f)

menorSegun :: Ord x => (t -> x) -> (t -> t -> t)
menorSegun f a b
  | f a < f b = a
  | otherwise = b



-- tour es una lista de funciones en orden Turista -> Turista
completarTour ::  Tour -> Turista -> Turista
completarTour tour turista = foldl (flip ($)) turista tour 


-- dada una lista con repetidos , devuelve otra lista SIN REPETIDOS  recursividad
sinRepetidos :: Eq a => [a] -> [a]
sinRepetidos [] = []
sinRepetidos (cabeza : cola)
  | elem cabeza cola = sinRepetidos cola
  | otherwise        = cabeza : sinRepetidos cola


{- Resolver utilizando recursividad. Definir la función gemaMasPoderosa que dado un guantelete y una persona obtiene la gema del infinito que produce la
pérdida más grande de energía sobre la víctima. PARCIAL DE escuelita de thanos.
un guantelete era un data que tenia una lista de gemas.
-}

gemaMasPoderosa :: Personaje -> Guantelete -> Gema
gemaMasPoderosa personaje guantelte = gemaMasPoderosaDe personaje $ gemas guantelte

gemaMasPoderosaDe :: Personaje -> [Gema] -> Gema
gemaMasPoderosaDe _ [gema] = gema
gemaMasPoderosaDe personaje (gema1:gema2:gemas) 
    | (energia.gema1) personaje < (energia.gema2) personaje = gemaMasPoderosaDe personaje (gema1:gemas)
    | otherwise = gemaMasPoderosaDe personaje (gema2:gemas)


-- interesante este punto como se elimina una habilidad es decir dado un elemento de una lista devuelvo otra que no lo tiene
eliminarHabilidad :: String -> Personaje -> Personaje
eliminarHabilidad habilidad personaje =  personaje { habilidades = filter (/=habilidad) $ habilidades personaje }

-- filtra una lista de string genericamente              :: Criterio = String -> Bool
eliminarEnfermedadesCriterio ::  Criterio-> Raton-> Raton
eliminarEnfermedadesCriterio criterio aRaton  = aRaton{enfermedades = filter criterio (enfermedades aRaton)} 


--Hacer la función que encuentra la cantidadIdeal. Recibe una condición y dice cuál es el primer 
-- PUnto 4 : EXperimentos 
type Condicion = Number->Bool
--a
cantidadIdeal :: Condicion->Number
cantidadIdeal cond = head (filter cond numerosNaturales)

numerosNaturales :: [Number]
numerosNaturales  = iterate (1+) 1







