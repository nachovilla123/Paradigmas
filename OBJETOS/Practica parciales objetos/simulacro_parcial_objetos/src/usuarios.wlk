import vehiculos.*
import multas.*


class Usuario{
	
	const usuario
	const dni
	var property dinero
	var property vehiculoAsociado 
	var property multas = []

	method recorrerDistancia(unaDistancia){
		vehiculoAsociado.recorrer(unaDistancia)	
	}
	
	method cargarCombustible(unaCantidadEnLitros){
		if (dinero > self.vehiculoAsociado(). ){
			dinero -= unaCantidadEnLitros * 40
			vehiculoAsociado.recargarCombustible(unaCantidadEnLitros)	
			
			} else {
					throw new DomainException(message = "el usuario no tiene dinero")	
				}		
	}	
}


const nacho = new Usuario(usuario = "nacho", dni = "123", dinero = 5000, vehiculoAsociado = reno , multas = [multa1,multa2,multa3])