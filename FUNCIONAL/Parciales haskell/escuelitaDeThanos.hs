- https://docs.google.com/document/d/1IKrJkdbPyoxfHqREIfqzxpsBdANcL2g9gvs9t-IR30E/edit
import Text.Show.Functions

---------- Datas y Tipos ----------
data Guantelete = Guantelete {
    material :: String    ,
    gemas    :: [Gema]
}deriving (Show)

data Personaje = Personaje {
    edad        :: Int ,
    energia     :: Int ,
    habilidades :: [String] ,
    nombre      :: String,
    planeta     :: String
}deriving (Show)

type Universo = [Personaje]

---------- Datas y Tipos ----------

---------- Personajes y Universos ----------

thor:: Personaje
thor = Personaje 30 100 ["bailar","cantar","darte un martillazo"] "thor" "tierra"

ironMan:: Personaje
ironMan = Personaje 45 75 ["volar","ser rico"] "stark" "tierra"

groot:: Personaje
groot = Personaje 250 700 ["arbol"] "groot" "planeta Arbol"

groot2:: Personaje
groot2 = Personaje 250 700 ["arbol"] "groot" "planeta Arbol"
universoMarvel :: Universo
universoMarvel =[thor, ironMan , groot, groot2]

mataTodos :: Guantelete
mataTodos = Guantelete "uru" [mente 10,alma "volar", espacio "govir",poder,tiempo ,gemaLoca (alma "programacion en haskell")]
---------- Personajes , Universos , Guantelete ----------

---------- Helpers ----------

tieneDeterminadaHabilidad :: String -> Personaje -> Bool
tieneDeterminadaHabilidad habilidad  = elem habilidad . habilidades 
---------- Helpers ----------


chasquidoUniverso :: Guantelete -> Universo -> Universo
chasquidoUniverso guantelete universo | estaCompleto guantelete = chasquear universo

estaCompleto :: Guantelete -> Bool
estaCompleto guantelete = hechoDeUru guantelete && tiene6gemas guantelete

hechoDeUru :: Guantelete -> Bool 
hechoDeUru  = (=="uru") . material

tiene6gemas :: Guantelete -> Bool
tiene6gemas = (6 ==) . length . gemas

chasquear :: Universo -> Universo
chasquear unUniverso = take (div (length unUniverso) 2) unUniverso

----------  Punto 2 ----------
aptoParaPendex :: Universo -> Bool
aptoParaPendex  = any ((<45). edad ) 

energiaTotal :: Universo -> Int
energiaTotal  = sum . (map energia) . masDeUnaHabilidad 

masDeUnaHabilidad :: Universo -> Universo
masDeUnaHabilidad  = filter ((1<).length . habilidades) 

----------  Punto 2 ----------

type Gema = Personaje -> Personaje

restarEnergia :: Int -> Personaje -> Personaje
restarEnergia cantidad personaje = personaje { energia = energia personaje - cantidad}

modificarHabilidad :: ([String]->[String]) -> Personaje -> Personaje
modificarHabilidad modificador personaje = personaje { habilidades =  modificador . habilidades $ personaje}

mente ::Int -> Gema
mente = restarEnergia 

alma :: String -> Gema
alma habilidad =  restarEnergia 10 . eliminarHabilidad habilidad

-- interesante este punto como se elimina una habilidad es decir dado un elemento de una lista devuelvo otra que no lo tiene
eliminarHabilidad :: String -> Personaje -> Personaje
eliminarHabilidad habilidad personaje =  personaje { habilidades = filter (/=habilidad) $ habilidades personaje }

espacio :: String -> Gema 
espacio planeta = restarEnergia 20 . modificarPlaneta (const planeta)

modificarPlaneta :: (String -> String) ->  Personaje -> Personaje
modificarPlaneta modificador personaje = personaje { planeta =  modificador . planeta $ personaje}

poder :: Gema
poder personaje = atacarHabilidadesSI . restarEnergia (energia personaje) $ personaje

atacarHabilidadesSI :: Personaje -> Personaje
atacarHabilidadesSI personaje | (<=2).length.habilidades $ personaje = modificarHabilidad (const []) personaje
                              | otherwise                            = personaje       

tiempo :: Gema
tiempo  = edadALaMitad . restarEnergia 50

edadALaMitad :: Personaje -> Personaje
edadALaMitad personaje = personaje{ edad = max 18 (div (edad personaje) 2) }

gemaLoca :: Gema -> Personaje -> Personaje
gemaLoca gema1  = gema1 . gema1 

------- punto 4
guanteleteDeEjemplo :: Guantelete
guanteleteDeEjemplo = Guantelete "goma" [tiempo , alma "usar Mjolnir", gemaLoca (alma "programacion en haskell")]


utilizar :: [Gema] -> Personaje -> Personaje
utilizar gemas personaje = foldl (flip ($)) personaje gemas

{-Punto 6: (2 puntos). Resolver utilizando recursividad. Definir la función gemaMasPoderosa que dado un guantelete y una persona obtiene la gema del infinito que produce la pérdida más grande de energía sobre la víctima. -}

gemaMasPoderosa :: Personaje -> Guantelete -> Gema
gemaMasPoderosa personaje guantelte = gemaMasPoderosaDe personaje $ gemas guantelte

gemaMasPoderosaDe :: Personaje -> [Gema] -> Gema
gemaMasPoderosaDe _ [gema] = gema
gemaMasPoderosaDe personaje (gema1:gema2:gemas) 
    | (energia.gema1) personaje < (energia.gema2) personaje = gemaMasPoderosaDe personaje (gema1:gemas)
    | otherwise = gemaMasPoderosaDe personaje (gema2:gemas)


--Punto 7: (1 punto) Dada la función generadora de gemas y un guantelete de locos:
infinitasGemas :: Gema -> [Gema]
infinitasGemas gema = gema:(infinitasGemas gema)

guanteleteDeLocos :: Guantelete
guanteleteDeLocos = Guantelete "vesconite" (infinitasGemas tiempo)

usoLasTresPrimerasGemas :: Guantelete -> Personaje -> Personaje
usoLasTresPrimerasGemas guantelete = (utilizar . take 3. gemas) guantelete

{-
Justifique si se puede ejecutar, relacionándolo con conceptos vistos en la cursada:
gemaMasPoderosa ironMan guanteleteDeLocos  ------------------------> si se puede ejecutar
usoLasTresPrimerasGemas guanteleteDeLocos ironMan    ----------> funciona
-}
