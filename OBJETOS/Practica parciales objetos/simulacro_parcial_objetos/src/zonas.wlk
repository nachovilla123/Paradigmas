import usuarios.*
import multas.*


class Zona{
	var property nombre
	
	const velocidadMaximaPermitida
	
	var property usuarios = []
	
	method controlDeVelocidad(){
		const usuariosAMultar = usuarios.filter{usuario => velocidadMaximaPermitida < usuario.vehiculoAsociado().velocidadPromedio() }
		usuariosAMultar.map{usuario => usuario.multas().add(new Multa(costo = 3000)  )}
	}
	
	method controlEcologico(){
		const usuariosAMultar = usuarios.filter{usuario => !usuario.vehiculoAsociado().ecologico() }
		usuariosAMultar.map{usuario => usuario.multas().add(new Multa(costo = 1500)  )}
	}
	
	//FALTA TERMINAR ESTE
	method regulatorios(){
		const usuariosAMultar = usuarios.filter{usuario => !usuario.vehiculoAsociado().ecologico() }
		usuariosAMultar.map{usuario => usuario.multas().add(new Multa(costo = 2000)  )}
	}
	
	//Regulatorios: 
	// Los días del mes pares sólo los usuarios con dni par pueden moverse, lo mismo para los días impares2. 
	
	
}

const liniers = new Zona(velocidadMaximaPermitida = 50 ,usuarios = [nacho], nombre = "liniers")

const almagro = new Zona(velocidadMaximaPermitida = 80, nombre = "almagro")
