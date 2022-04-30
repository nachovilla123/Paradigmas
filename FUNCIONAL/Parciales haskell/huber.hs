-- parcial huber :: https://docs.google.com/document/d/1b-dhR_yAQui07DvZCk2vvwIkcs-d9jxM7mX203nMaz8/edit
import Text.Show.Functions

type NombreCliente = String
type Direccion = String
type CondicionViaje = Viaje -> Bool

data Chofer = Chofer {
    nombre :: String,
    kilometrosAuto :: Int,
    viajesTomados :: [Viaje],
    condicion :: CondicionViaje
} deriving (Show)

data Viaje = Viaje {
    fecha :: (Int, Int, Int),
    cliente :: Cliente,
    costo :: Float
} deriving (Show)

data Cliente = Cliente {
    nombreCliente :: String,
    lugar :: String
} deriving (Show)

tomaCualquierViaje :: CondicionViaje
tomaCualquierViaje _ = True 

viajesMayoresDe200 :: CondicionViaje
viajesMayoresDe200 = (> 200) . costo

clienteNombreLargo :: Int -> CondicionViaje
clienteNombreLargo n  = (n <) . length . nombreCliente . cliente  -- ver si anda sino alternativa

clienteNombreLargo1 :: Int -> CondicionViaje
clienteNombreLargo1 n = (> n) . length . nombreCliente . cliente

tomaSiClienteNoviveEnZona :: String -> CondicionViaje
tomaSiClienteNoviveEnZona zona  = (/= zona) . lugar . cliente


--(1 punto) Saber si un chofer puede tomar un viaje.-}

lucas :: Cliente
lucas = Cliente "lucas" "Victoria"

lucas1 :: Cliente
lucas1 = Cliente "lucas" "Olivos"

daniel :: Chofer
daniel = Chofer "Daniel" 23500 [Viaje (20,04,2017) lucas 150 ] (tomaSiClienteNoviveEnZona "Olivos")

alejandra :: Chofer
alejandra = Chofer "alejandra" 180000 [] tomaCualquierViaje

viajeDeNacho :: Viaje
viajeDeNacho = Viaje (20,04,312312) lucas 2452

choferTomaViaje ::  Viaje -> Chofer -> Bool
choferTomaViaje viaje chofer = (condicion chofer) $ viaje

liquidacionChofer :: Chofer -> Float
liquidacionChofer =  sum . map costo . viajesTomados
----------------------------------------------------------------------------------------------------------------
realizarViaje :: Viaje -> [Chofer] -> Chofer
realizarViaje viaje  = efectuarViaje viaje . considerarChoferMenosViajes . filter (choferTomaViaje viaje) 

modificarViajes :: ([Viaje] -> [Viaje]) -> Chofer -> Chofer
modificarViajes modificadorViajes unChofer = unChofer { viajesTomados = modificadorViajes.viajesTomados $ unChofer}

efectuarViaje :: Viaje -> Chofer -> Chofer 
efectuarViaje viaje =  modificarViajes (++[viaje])

considerarChoferMenosViajes :: [Chofer] -> Chofer
considerarChoferMenosViajes  = minimoSegun (length . viajesTomados) 

minimoSegun :: Ord b => (a -> b) -> [a] -> a
minimoSegun f = foldl1 (menorSegun f)

menorSegun :: Ord x => (t -> x) -> (t -> t -> t)
menorSegun f a b
  | f a < f b = a
  | otherwise = b
  ---------------------------------

repetirViaje :: t -> [t]
repetirViaje viaje = viaje : repetirViaje viaje

nitoInfy :: Chofer
nitoInfy = Chofer "Nito Infy" 70000 viajeInfinito (clienteNombreLargo 3)

viajeInfinito :: [Viaje]
viajeInfinito = repetirViaje $ Viaje (11, 3, 2017) lucas 50


-- b 
-- liquidacionChofer nito ... no termina nunca!!
-- c pero 
-- puedeTomarViaje (Viaje (2,5,2017) lucas 50) nito
-- True
-- porque no involucra a la lista de viajes

-- Punto 8
gongNeng arg1 arg2 arg3 = 
     max arg1 . head . filter arg2 . map arg3

--gongNeng :: Ord a => a -> (a -> Bool)  -> (b -> a)  -> [b] -> a
-- pueden variar las letras en Haskell, a mi me tira
-- gongNeng :: Ord c => c -> (c -> Bool) -> (a -> c) -> [a] -> c
