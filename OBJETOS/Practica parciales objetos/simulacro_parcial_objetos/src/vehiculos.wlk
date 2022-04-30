import usuarios.*

class Vehiculo{
	
	const capacidadTanque
	var property cantidadCombustibleEnTanque
	
	
	method velocidadPromedio()
	
	method consumoBasePorKM() = 2
	method consumoExtraPorKM() = 0
	
	method calcularConsumoTotal(distanciaEnKM) = distanciaEnKM * self.consumoBasePorKM() + self.consumoExtraPorKM() * distanciaEnKM
	
	method ecologico() 
	
	method recorrer(unaDistancia){
		if (self.calcularConsumoTotal(unaDistancia) > cantidadCombustibleEnTanque) throw new DomainException(message = "el combustible en tanque no es suficiente")
		else {
			cantidadCombustibleEnTanque = cantidadCombustibleEnTanque - self.calcularConsumoTotal(unaDistancia)
			}	
		}
	
	method muchosLitros(litrosAcargar) = litrosAcargar > capacidadTanque
	
	method litrosFaltantesDelTanque() = capacidadTanque - cantidadCombustibleEnTanque 
	
	method recargarCombustible(unosLitros){
		
		if (self.muchosLitros(unosLitros) ){
			
			cantidadCombustibleEnTanque += self.litrosFaltantesDelTanque
			
		} else{
				cantidadCombustibleEnTanque += unosLitros
				
			}
	}
	
	
}

class Camioneta inherits Vehiculo{
	
	override method ecologico() = false
	
	method velocidadPromedio() = 80
	
	override method consumoExtraPorKM() = 5
	
}


class Deportivo inherits Vehiculo{
	
	override method ecologico() = self.velocidadPromedio() < 120
	
	method consumoPorVelocidad() = self.velocidadPromedio() * 0.2
	
}

class Familiar inherits Vehiculo{
	override method ecologico() = true
}


const reno = new Camioneta(capacidadTanque = 70, cantidadCombustibleEnTanque = 50)







