import productos.*
import niveles.*
import cupones.*

class Usuario {
	const nombre
	var property dinero
	var property puntos = 0
	
	var property nivel = bronce
	
	var cupones = []
	var productosEnCarrito = []
	
	method agregarProducto(producto) {
		if(productosEnCarrito.size() >= nivel.maxProductosEnCarrito()) {
			throw new DomainException(message = "No puede agregar mas productos por su nivel")
		}
		
		productosEnCarrito.add(producto)
	} 
	
	method comprarProductos(){
		self.eliminarMisCuponesUsados()
		const cuponAleatorio = cupones.anyOne()
		const totalAPagar = cuponAleatorio.aplicarDescuentoA(self.precioTotalCarrito())
		
		if(dinero < totalAPagar){
			throw new DomainException(message = "NO TIENE DINERO SUFICIENTE")	
		} else {
			cuponAleatorio.usado(true)
			self.pagarProductos(totalAPagar)
		}
		
		self.eliminarMisCuponesUsados()
	}
	
	method pagarProductos(monto) {
		dinero -= monto
		puntos += (monto * 0.1) //Se suma el 10% del valor de la compra
	}
	
	method precioTotalCarrito() = productosEnCarrito.sum{ producto => producto.precioFinal()}
	
	method esMoroso() = dinero < 0
	
	method perderPuntos(unosPuntos){
		puntos -= unosPuntos
	}
	
	method eliminarMisCuponesUsados(){
		cupones = cupones.filter{unCupon => !unCupon.usado()}
	}
	
	method actualizarNivel(){
		nivel = nivel.actualizate(puntos)
	}
}

const nacho = new Usuario(puntos = 15000,nombre = "nacho", dinero = 2500 ,productosEnCarrito = [ganga1,mueble1,indumentaria1] ,cupones = [cupon1])
