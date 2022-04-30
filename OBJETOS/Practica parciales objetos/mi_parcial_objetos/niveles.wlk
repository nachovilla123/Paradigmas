class Nivel {
	method maxProductosEnCarrito()
	
	method actualizate(puntos) {
	    if(puntos < 5000){
	        return bronce
	    } else if(puntos >= 5000 && puntos < 15000){ 
	        return plata
	    } else return oro
	}
}

object bronce inherits Nivel{
	override method maxProductosEnCarrito() = 1
}

object plata inherits Nivel{
	override method maxProductosEnCarrito() = 5
}

object oro inherits Nivel{
	override method maxProductosEnCarrito() = 10000000 
}