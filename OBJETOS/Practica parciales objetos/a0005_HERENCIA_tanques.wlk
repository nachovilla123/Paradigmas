class Tanque{
	
	const armas = []
	const tripulantes = 2
	var salud = 1000
	var property prendidoFuego = false
	
	method emiteCalor() = prendidoFuego || tripulantes > 3
	
	method sufrirDanio(danio){
		salud -= danio
		}
	
	method atacar(objetivo) {
		armas.anyOne().dispararA(objetivo)
		}

	}// fin clase tanque

class TanqueBlindado inherits Tanque{
	const blindaje = 200
	
	override method emiteCalor() = false
	
	override method sufrirDanio(danio) {
		
		if (danio > blindaje )
			super(danio - blindaje)
			}
	}

class Misil {
		
	const potencia
	var agotada = false
	
	method agotada() = agotada	
		
	method dispararA(objetivo){	
		agotada = true
		objetivo.sufrirDanio(potencia)		
		}		
	}
	
class MisilTermico inherits Misil {
	
	override method  dispararA(objetivo){	 // el override hace que la clase misil termico sea la primera en buscar ese metodo
		if(objetivo.emiteCalor() ) {       // lo que me permite "sobreescribir" el metodo que heredaba de la clase misil para que lo haga distinto
			super(objetivo)   // empieza a ver las clases que tiene "arriba" y devuelve lo que se hubiera ejecutado normalmente
			}                // se hace para no repetir el mismo codigo de la ejecucion de un misil
		}
	}
	
class Recargable {
	var cargador = 100
	method recargar(){ cargador = 100 }
	method agotada() = cargador <= 0
}	
	/* 
class Lanzallamas inherits Recargable{
	
	method dispararA(objetivo) {
		cargador -= 20
		objetivo.prendidoFuego(true) // esta seteando en true el objetivo que ataca		
		}
	}*/
	
class Metralla inherits Recargable{
	
	const property calibre
	
	method dispararA(objetivo){	
		cargador -= 10
		if (calibre > 50)
		objetivo.sufrirDanio(calibre/4)
		}
}

// para implementar matafuego

class Rociador inherits Recargable{
	method dispararA(objetivo){
		cargador -=20
		self.causarEfecto(objetivo)
			}
			
	method causarEfecto(objetivo)
	method descargaPorRafaga() = 20
	
}

class Lanzallamas inherits Rociador{
	method causarEfecto(objetivo) {
		objetivo.prendidoFuego(false) 	
		}
	}

class Matafuego inherits Rociador{
	method causarEfecto(objetivo) {
		objetivo.prendidoFuego(true) 	
		}
	}	
	
class Sellador inherits Rociador{
	method causarEfecto(objetivo) {
		objetivo.salud( objetivo.salud() * 1.1 ) 	
		  }
		
		override method descargaPorRafaga() = 25 
	}	
