--https://docs.google.com/document/d/1Y-hixhngNzgeWrNPyLqRHmmcF0h9D6CyRnrrfMhe2Gk/edit
import Text.Show.Functions
---------- Datas y Tipos ----------

data Personaje = Personaje {
    nombre   :: String ,
    poder    :: Int    ,
    derrotas :: [(Oponente,Anio)] ,
    equipamientos :: [Equipamiento]
} deriving Show

type Oponente = String
type Anio = Int
type Equipamiento = Personaje -> Personaje

---------- Datas y Tipos ----------

---------- Personajes ----------

ironMan :: Personaje
ironMan = Personaje "tony" 500 [ ("hijo de thanos",2014), ("un random",2015) , ("al santi",2069) ]

thor :: Personaje
thor = Personaje "thor" 1000 [ ("hijo de thanos",2014), ("borracho",2015) , ("loki",2069) ]

loki :: Personaje
loki = Personaje "loki" 50 [  ]

spiderMan :: Personaje
spiderMan = Personaje "peter" 250 [ ("buitre",2017), ("mistrio",2019) ]

grupo1 :: [Personaje]
grupo1 = [loki,thor]
grupo2 :: [Personaje]
grupo2 = [spiderMan,ironMan]
---------- Personaje ----------

---------- Funciones Auxiliares ----------

modificarPoder :: (Int -> Int) -> Personaje -> Personaje
modificarPoder modificador personaje = personaje {poder = modificador . poder $ personaje}

multiplicarPoder :: Int -> Personaje -> Personaje
multiplicarPoder = modificarPoder . (*)

---------- Funciones Auxiliares ----------

---------- Punto 2 ----------
entrenamiento :: [Personaje] -> [Personaje]
entrenamiento grupo = map (multiplicarPoder (length grupo)) grupo
---------- Punto 2 ----------

---------- Punto 3 ----------

rivalesDignos :: [Personaje] -> [Personaje]
rivalesDignos  = filter esDigno . entrenamiento

esDigno :: Personaje-> Bool
esDigno personaje = ((500<) . poder $ personaje) && hijothanos personaje

hijothanos :: Personaje -> Bool
hijothanos = elem "hijo de thanos" . map fst . derrotas

---------- Punto 3 ----------

---------- Punto 4 ----------
guerraCivil :: Int -> [Personaje] -> [Personaje] -> [Personaje]
guerraCivil anio grupo1 grupo2 = zipWith (enfrentarse anio) grupo1 grupo2

enfrentarse ::Int -> Personaje -> Personaje -> Personaje
enfrentarse anio personaje1 personaje2 
    | poder personaje1 > poder personaje2  = agregarDerrota (nombre personaje2) anio personaje1
    | otherwise                            = agregarDerrota (nombre personaje1) anio personaje2

agregarDerrota :: String -> Int -> Personaje -> Personaje
agregarDerrota nombreDelDerrotado anio personaje = personaje{derrotas =  (nombreDelDerrotado , anio) : derrotas personaje  }
---------- Punto 4 ----------

---------- Parte B  ----------
{-

trajeMecanizado: devuelve el personaje anteponiendo "Iron" al nombre del personaje y le agrega una versión dada al final del mismo. Por ejemplo:
Si el personaje se llama "Groot" y la versión del traje es 2 , su nombre quedaría "Iron Groot V2"
-}
---------- Punto 1  ----------
escudo :: Equipamiento
escudo personaje | 5 < length (derrotas personaje) = modificarPoder (+50) personaje
                 | otherwise                       = modificarPoder (subtract  100) personaje
