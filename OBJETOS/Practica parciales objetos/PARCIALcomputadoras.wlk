
class Supercomputadora{
	
	var property equipos = []
	var totalDeComplejidadComputada = 0
	
	
	method estaActivo() = true
	method equiposActivos() = equipos.filter{ equipo => equipo.estaActivo()}
	
	method computo() = self.equiposActivos() . sum{equipo =>  equipo.computo() }
	method consumo() = self.equiposActivos() . sum{equipo =>  equipo.consumo() }
	
	method malConfigurada () = self.equipoQueMasConsume() != self.equipoQueMasComputa()
	method equipoQueMasConsume() = self.equiposActivos().max{equipo => equipo.consumo()}
	method equipoQueMasComputa() = self.equiposActivos().max{equipo => equipo.computo()}



	method computar(problema){
		self.equiposActivos() . forEach{ equipo =>
			equipo.computar(new Problema(complejidad = problema.complejidad() / self.equiposActivos() . size()  ))
		}
		
		totalDeComplejidadComputada += problema.complejidad()
		
	} 
}

//--------------- EQUIPOS ---------------\\

class Equipo{
	var property quemado = false
	var overclockAntesDeQuemarse //no chequeado 
	var property modo = standard
	
	method estaActivo() = !quemado and self.computo() > 0
	method consumo() = modo.comsumoDe(self)
	method computo() = modo.computoDe(self)
	
	method computar(problema){ 
		if(problema.complejidad() > self.computo() ) throw new DomainException(message = "capacidad excedida")
		modo.realizoComputo(self)
	}
	
	method consumoBase() 
	method computoBase() 
	method computoExtraPorOverclock()
}

class A105 inherits Equipo{
	override method consumoBase() = 300
	override method computoBase() = 600
	override method computoExtraPorOverclock() =self.computoBase() * 0.3
	
	override method computar(problema){ 
		if(problema.complejidad() < 5 ) throw new DomainException(message = "error de fabrica")
		super(problema)
	}
}

class B2 inherits Equipo {
	var property microchips
	
	override method consumoBase() = 50 * microchips + 10
	override method computoBase() = 800.min(microchips * 100)
}

//--------------- MODOS DE FUNCIONAMIENTO ---------------\\

class Modo{
	method consumoDe(equipo)
	method computoDe(equipo)
}

object standard {
	 method consumoDe(equipo) = equipo.consumoBase()
	 method computoDe(equipo) = equipo.computoBase()
	 method realizoComputo(equipo){}
}

class Overclock {
	var usosRestantes
	
	override method initialize(){
		if(usosRestantes < 0) throw new DomainException(message = " los usos restantes deben ser mayor a 0")
	}
	
	 method consumoDe(equipo) = equipo.consumoBase() * 2
	 method computoDe(equipo) = equipo.computoBase() + equipo.computoExtraPorOverclock()

	method realizoComputo(equipo){
		if(usosRestantes == 0){
			equipo.estaQuemado(true)
			throw new DomainException(message = " equipo quemado por overclock")
		}
	}
}

class AhorrodeEnergia {
	
	var computosRealizados
	 method consumoDe(equipo) = 200
	 method computoDe(equipo) = (self.consumoDe(equipo) / equipo.ConsumoBase() ) * equipo.computoBase()	
	
	method periocidadDeError() = 17
	
	method realizoComputo(equipo){
		computosRealizados += 1
		if(computosRealizados % self.periocidadDeError()){
			throw new DomainException(message = " corriendo monitor")
		}
	}
}

class APruebaDeFallos inherits AhorrodeEnergia{
	
	override method computoDe(equipo) = super(equipo) / 2
	
	override method periocidadDeError() = 100
	
}

class Problema {
	const property complejidad
}

