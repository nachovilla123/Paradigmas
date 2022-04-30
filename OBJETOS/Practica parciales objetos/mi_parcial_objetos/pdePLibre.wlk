import usuarios.*
import productos.*

object pdePLibre {
	
	var usuarios = []
	var productos = [ganga1,mueble1,indumentaria1]
	
	method reducirPuntosAMorosos(){
		usuarios.filter{unUsuario => unUsuario.esMoroso()} 
		.map{ unUsuario => unUsuario.perderPuntos(1000) } //usuario.deberia llamarse perder puntos?
		
	}
	
	method eliminarCuponesUsadosDeUsuarios(){
		
		usuarios.forEach{ usuario => usuario.eliminarMisCuponesUsados() }	
	}
	
	method obtenerNombresDeOferta() = productos.map{unProducto => unProducto.nombreDeOferta() }
	
	
	method actualizarNivelesUsuarios(){
		usuarios.forEach{ usuario => usuario.actualizarNivel()}
	}
}
