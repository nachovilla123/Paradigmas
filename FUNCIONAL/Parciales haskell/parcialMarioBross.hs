module Lib where
import Text.Show.Functions

----------------------------------------------
-- Copiá acá el código de base
-- provisto en el enunciado
----------------------------------------------

afectarALosQueCumplen :: (a -> Bool) -> (a -> a) -> [a] -> [a]
afectarALosQueCumplen criterio efecto lista
  = (map efecto . filter criterio) lista ++ filter (not.criterio) lista

----------------------------------------------
-- Definí tus tipos de datos y funciones aquí
-- indicando a qué punto pertenecen
----------------------------------------------


--- 1
type Carrera = [Auto]
type Color = String

data Auto = Auto {
    color :: Color,
    velocidad :: Int,
    distancia :: Int
  } deriving (Show, Eq)

-- 1a
estaCerca :: Auto -> Auto -> Bool
estaCerca auto cercano = ((< 10).distanciaEntre auto) cercano && auto /= cercano

distanciaEntre auto otroAuto = abs (distancia auto - distancia otroAuto)

-- 1b
vaTranquilo :: Auto -> Carrera -> Bool
vaTranquilo auto carrera =  (not . any (estaCerca auto)) carrera && lesVaGanandoATodos auto carrera

lesVaGanandoATodos auto = all (leVaGanando auto).filter (/= auto)

leVaGanando auto otroAuto = distancia auto > distancia otroAuto

-- 1c
puesto :: Auto -> Carrera -> Int
puesto auto = (+1).length.filter (flip leVaGanando auto)

---- Punto 2, sin y con azúcar sintáctico de copiado

-- 2a
correr :: Int -> Auto -> Auto
correr tiempo (Auto color velocidad distancia) = Auto color velocidad (distancia + velocidad * tiempo)
correr' tiempo auto = auto { distancia = distancia auto + velocidad auto * tiempo }

-- 2bi
alterarVelocidad :: (Int -> Int) -> Auto -> Auto
alterarVelocidad modificador (Auto color velocidad distancia) = Auto color (modificador velocidad) distancia
alterarVelocidad' modificador auto = auto {velocidad = modificador . velocidad $ auto }

-- 2bii

bajarVelocidad :: Int -> Auto -> Auto
bajarVelocidad cantidad = alterarVelocidad (max 0 . (flip (-) cantidad))

bajarVelocidad' cantidad = alterarVelocidad (max 0 . subtract cantidad)

-- otra variante sin max, menos copada
bajarVelocidad'' cantidad auto
  | velocidad auto < cantidad = cambiarVelocidad 0 auto
  | otherwise = alterarVelocidad (subtract cantidad) auto

cambiarVelocidad :: Int -> Auto -> Auto
cambiarVelocidad cantidad = alterarVelocidad (\ _ -> cantidad)

---- Punto 3

type PowerUp = Auto -> Carrera -> Carrera

-- 3a
terremoto :: PowerUp
terremoto auto carrera = afectarALosQueCumplen (estaCerca auto) (bajarVelocidad 50) carrera

-- 3b
miguelitos :: Int -> PowerUp
miguelitos cantidad auto carrera = afectarALosQueCumplen (leVaGanando auto) (bajarVelocidad cantidad) carrera

-- 3c
jetPack  :: Int -> PowerUp
jetPack tiempo auto carrera = afectarALosQueCumplen (== auto) (cambiarVelocidad (velocidad auto).correr tiempo.(alterarVelocidad (*2))) carrera

{-
Otra variante de modelado podría ser:
data PowerUp = PowerUp {
    condicion :: Auto -> Bool,
    efecto :: Auto -> Auto
  }
y definir una función de este estilo:
gatillar :: PowerUp -> Auto -> Carrera -> Carrera
gatillar powerUp auto carrera = afectarALosQueCumplen (condicion powerUp) (efecto powerUp) carrera
y las funciones pedidas quedan parecidas, pero construyendo un PowerUp, por ejemplo
terremoto auto = PowerUp (estaCerca auto) (bajarVelocidad 50)
-}

---- Punto 4

-- 4a
simularCarrera :: Carrera -> [Carrera -> Carrera] -> [(Int, Color)]
simularCarrera carrera eventos
  = ( tablaDePosiciones . foldl (flip ($)) carrera ) eventos

tablaDePosiciones :: Carrera -> [(Int, Color)]
tablaDePosiciones carrera = map (\auto -> (puesto auto carrera, color auto)) carrera

tablaDePosiciones' carrera = zip (map (flip puesto carrera) carrera) (map color carrera)

-- 4b
correnTodos :: Int -> (Carrera -> Carrera)
correnTodos tiempo = map (correr tiempo)

usaPowerUp :: Color -> PowerUp -> (Carrera -> Carrera)
usaPowerUp colorDelAuto powerUp carrera = flip powerUp carrera . buscarAuto colorDelAuto $ carrera

buscarAuto :: String -> [Auto] -> Auto
buscarAuto colorDelAuto = head . filter ((== colorDelAuto).color)

-- 4c - ejemplo de uso de simularCarrera incluyendo correnTodos y usos de los distintos power ups
carreraDeEjemplo :: Carrera
carreraDeEjemplo = map (\color -> Auto color 120 0) [ "rojo", "blanco", "azul", "negro"]

eventosDeEjemplo = [
  correnTodos 30,
  "azul" `usaPowerUp` (jetPack 3),
  "blanco" `usaPowerUp` terremoto,
  correnTodos 40,
  "blanco" `usaPowerUp` (miguelitos 20),
  "negro" `usaPowerUp` (jetPack 6),
  correnTodos 10
  ]

{-
> simularCarrera carreraDeEjemplo eventosDeEjemplo
[(3,"negro"),(4,"rojo"),(1,"azul"),(2,"blanco")]
-}

---- Punto 5
{-
5a
Se puede agregar sin problemas como una función más misilTeledirigido :: Color -> PowerUp, y usarlo como:
usaPowerUp "azul" (misilTeledirigido "rojo") :: Evento
5b
- vaTranquilo puede terminar sólo si el auto indicado no va tranquilo
(en este caso por tener a alguien cerca, si las condiciones estuvieran al revés, terminaría si se encuentra alguno al que no le gana).
Esto es gracias a la evaluación perezosa, any es capaz de retornar True si se encuentra alguno que cumpla la condición indicada, y all es capaz de retornar False si alguno no cumple la condición correspondiente. Sin embargo, no podría terminra si se tratara de un auto que va tranquilo.
- puesto no puede terminar nunca porque hace falta saber cuántos le van ganando, entonces por más que se pueda tratar de filtrar el conjunto de autos, nunca se llegaría al final para calcular la longitud.
-}
