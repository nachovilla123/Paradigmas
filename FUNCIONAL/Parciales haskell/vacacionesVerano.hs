-- https://docs.google.com/document/d/1C_oehBaJYavsacmThRZcrpIpX6axxVOdX19vYusRhlE/edit
data Turista = Turista{
    cansancio :: Int ,
    estres :: Int ,
    viajaSolo :: Bool ,
    idiomas :: [Idioma]
} deriving (Show,Eq)

type Excursion = Turista -> Turista
type Idioma = String
ana :: Turista
ana = Turista 0 21 False ["espanol"]
beto :: Turista
beto = Turista 15 15 True ["aleman"]
cathi :: Turista
cathi = Turista 15 15 True ["aleman","catalan"]

-- modificadores
modificarCansancio :: (Int->Int) -> Turista -> Turista
modificarCansancio modificador turista = turista{ cansancio = modificador . cansancio $ turista}

modificarEstres :: (Int->Int) -> Turista -> Turista
modificarEstres modificador turista = turista{ estres = modificador . estres $ turista}

modificarIdiomas :: ([String]->[String]) -> Turista -> Turista
modificarIdiomas modificador turista = turista{ idiomas = modificador . idiomas $ turista}

modificarviajaSolo :: (Bool->Bool) -> Turista -> Turista
modificarviajaSolo modificador turista = turista{ viajaSolo = modificador . viajaSolo $ turista}


--Ir a la playa: si está viajando solo baja el cansancio en 5 unidades, si no baja el stress 1 unidad.
irALaPlaya :: Excursion
irALaPlaya turista | viajaSolo turista = modificarCansancio  (subtract 5)  turista
                   | otherwise = modificarEstres (subtract 1)  turista      

--Apreciar algún elemento del paisaje: reduce el stress en la cantidad de letras de lo que se aprecia. 
apreciarElementoPaisaje :: String -> Excursion
apreciarElementoPaisaje elemento  = modificarEstres (subtract (length elemento)) 

--Salir a hablar un idioma específico: el turista termina aprendiendo dicho idioma y continúa el viaje acompañado.
salirAHablarIdiomaEspecifico :: String -> Excursion
salirAHablarIdiomaEspecifico idioma  = modificarviajaSolo (const False) . modificarIdiomas (++[idioma]) 

--Caminar ciertos minutos: aumenta el cansancio pero reduce el stress según la intensidad de la caminad, ambos en la misma cantidad. El nivel de intensidad se calcula en 1 unidad cada 4 minutos que se caminen.
caminarCiertosMinutos :: Int -> Excursion
caminarCiertosMinutos minutos  = modificarEstres (subtract(calcularIntensidad minutos)) . modificarCansancio (+(calcularIntensidad minutos))

calcularIntensidad :: Int-> Int
calcularIntensidad minutos = div minutos 4
{-Paseo en barco: depende de cómo esté la marea
si está fuerte, aumenta el stress en 6 unidades y el cansancio en 10.
si está moderada, no pasa nada.
si está tranquila, el turista camina 10’ por la cubierta, aprecia la vista del “mar”, y sale a hablar con los tripulantes alemanes.
-}

data Marea = Fuerte | Moderada | Tranquila

paseoEnBarco :: Marea -> Excursion
paseoEnBarco Fuerte turista = modificarEstres (+6) . modificarCansancio (+10) $ turista
paseoEnBarco Moderada turista = turista
paseoEnBarco Tranquila turista = salirAHablarIdiomaEspecifico "aleman" . apreciarElementoPaisaje "mar" . caminarCiertosMinutos 10 $ turista

--Hacer que un turista haga una excursión. Al hacer una excursión, el turista además de sufrir los efectos propios de la excursión, reduce en un 10% su stress.

hacerExcursion :: Excursion -> Turista -> Turista
hacerExcursion excursion  = sacardiezporciento . excursion

sacardiezporciento :: Turista -> Turista
sacardiezporciento turista = modificarEstres (subtract (div ( 10* estres turista) 100)) turista

{- Definir la función deltaExcursionSegun que a partir de un índice, un turista y una excursión determine cuánto varió dicho índice después de que el turista haya hecho la excursión. Llamamos índice a cualquier función que devuelva un número a partir de un turista.

Por ejemplo, si “stress” es la función que me da el stress de un turista:
> deltaExcursionSegun stress ana irALaPlaya
-3     -- porque al ir a la playa Ana queda con 18 de estrés (21 menos 1 menos 10% de 20)-}

deltaExcursionSegun :: (Turista->Int) -> Turista -> Excursion -> Int
deltaExcursionSegun indice turista excursion = deltaSegun indice turista (hacerExcursion excursion turista)

deltaSegun :: (a -> Int) -> a -> a -> Int
deltaSegun f algo1 algo2 = f algo1 - f algo2

--Saber si una excursión es educativa para un turista, que implica que termina aprendiendo algún idioma.

esEducativa :: Turista -> Excursion -> Bool
esEducativa turista excursion =  0 < deltaSegun (length.idiomas) turista (hacerExcursion excursion turista)

esEducativa1 :: Turista -> Excursion -> Bool
esEducativa1 turista excursion =  0 < deltaExcursionSegun (length.idiomas) turista excursion

--Conocer las excursiones desestresantes para un turista. Estas son aquellas que le reducen al menos 3 unidades de stress al turista.

excursionesDesestresantes ::Excursion -> Turista -> Bool
excursionesDesestresantes  excursion turista= (>=3) . (deltaExcursionSegun estres turista ) $ excursion

type Tour = [Excursion]
--type Excursion = Turista -> Turista
completo :: Tour
completo = [caminarCiertosMinutos 20 , apreciarElementoPaisaje "cascada" , caminarCiertosMinutos 40 , salirAHablarIdiomaEspecifico "melmacquiano"]

ladoB :: Excursion -> Tour 
ladoB excursionelegida =[paseoEnBarco Tranquila,excursionelegida ,caminarCiertosMinutos 120 ]

islaVecina ::Marea -> Tour
islaVecina Fuerte = [paseoEnBarco Fuerte , apreciarElementoPaisaje "lago" , paseoEnBarco Fuerte ]
islaVecina marea = [paseoEnBarco marea ,irALaPlaya, paseoEnBarco marea ]

--Hacer que un turista haga un tour. Esto implica, primero un aumento del stress en tantas unidades como cantidad de excursiones tenga el tour, y luego realizar las excursiones en orden.
hacerTour :: Turista -> Tour -> Turista
hacerTour turista tour = completarTour tour . modificarEstres (+ length tour) $ turista

completarTour ::  Tour -> Turista -> Turista
completarTour tour turista = foldl (flip ($)) turista tour 


{---Dado un conjunto de tours, saber si existe alguno que sea convincente para un turista. Esto significa que el tour tiene alguna excursión desestresante la cual, además, deja al turista acompañado luego de realizarla.

excursionesDesestresantes ::Excursion -> Turista -> Bool
excursionesDesestresantes  excursion turista= (>=3) . (deltaExcursionSegun estres turista ) $ excursion


type Tour = [Excursion]
type Excursion = Turista -> Turista

Tour = [(Turista -> Turista),(Turista -> Turista),(Turista -> Turista)]

-}
esConveniente :: Tour -> Turista -> Bool
esConveniente unTour unTurista = algunaCumpleLasSiguientes [flip excursionesDesestresantes unTurista, loDejaAcompaniado unTurista] unTour

loDejaAcompaniado :: Turista -> Excursion -> Bool
loDejaAcompaniado unTurista unaExcursion = not . viajaSolo . hacerExcursion unaExcursion $ unTurista

cumpleLasSiguientes :: [a -> Bool] -> a -> Bool
cumpleLasSiguientes listaDeCondiciones unValor = all ($ unValor) listaDeCondiciones

algunaCumpleLasSiguientes :: [a -> Bool] -> [a] -> Bool
algunaCumpleLasSiguientes listaDeCondiciones listaDeValores = any (cumpleLasSiguientes listaDeCondiciones) listaDeValores


--hayExcursionDesestresante :: Turista -> [Excursion] -> Bool
--hayExcursionDesestresante turista  = any (flip excursionesDesestresantes) $ turista

--quedaAcompaniadoYHayDesestresante ::  Turista -> Tour -> Bool
--quedaAcompaniadoYHayDesestresante turista tour = any (quedaAcompaniadoEnExcursion turista)$ tour && hayExcursionDesestresante turista tour

--quedaAcompaniadoEnExcursion :: Turista ->Excursion ->  Bool
--quedaAcompaniadoEnExcursion turista  = not . viajaSolo . (flip hacerExcursion) turista 

--hacerExcursion :: Excursion -> Turista -> Turista
--hacerExcursion excursion  = sacardiezporciento . excursion





---C------------------------------------------------------------------------------
--Saber la efectividad de un tour para un conjunto de turistas. Esto se calcula como la sumatoria de la espiritualidad recibida de cada turista a quienes les resultó convincente el tour. 
--La espiritualidad que recibe un turista es la suma de las pérdidas de stress y cansancio tras el tour.

efectividadDeTour :: Tour -> [Turista] -> Int
efectividadDeTour unTour turistas = sum . map (espiritualidad unTour) . filter (esConveniente unTour) $ turistas

espiritualidad :: Tour -> Turista -> Int
espiritualidad unTour unTurista = deltaExcursionSegun estres unTurista (flip hacerTour unTour) + deltaExcursionSegun cansancio unTurista (flip hacerTour unTour)

--Implementar y contestar en modo de comentarios o pruebas por consola
--Construir un tour donde se visiten infinitas playas.


infinitasPlayas :: Tour
infinitasPlayas = repeat irALaPlaya

{-- B.
    Para que un tour sea convincente hay que revisar que alguna excursion cumpla ciertas condiciones,
    como todas las excursiones son irALaPlaya, basta con evaluar esta funcion en particular para ana y beto.
    Si retorna true, el any dentro de esConveniente va a cortar a la primera, si retorna false nunca corta.

    *Main> esDesestresante ana irALaPlaya
    True   
    *Main> loDejaAcompaniado ana irALaPlaya
    True
-
    *Main> esDesestresante beto irALaPlaya 
    True   
    *Main> loDejaAcompaniado beto irALaPlaya
    False

    Como para ana retornan ambas condiciones true, infinitasPlayas le es Conveniente,
    pero para beto no, ya que no ambas condiciones evaluan a true.

    *Main> esConveniente infinitasPlayas ana
    True

    la de beto se queda colgada.

    C.
    Nunca se puede conocer la efectividad de infinitasPlayas, ya que es imposible
    saber el deltaExcursionSegun de realizar un tour infinito, necesariamente debe poder marcarse
    un antes y un despues, pero el tour nunca termina.
    
--}
