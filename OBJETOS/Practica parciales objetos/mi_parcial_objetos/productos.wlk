

class Producto{
	const property nombre
	const impuestoIVA = 0.21
	var property precioBase
	
	method precioFinal() = precioBase + precioBase * impuestoIVA
	
	method nombreDeOferta()
	
}

class Mueble inherits Producto{
	var property precioDeEntrega = 1000
	
	override method precioFinal() = precioDeEntrega + super()
	override method nombreDeOferta() =  "SUPER OFERTA " + nombre
}


class Indumentaria inherits Producto{
	override method nombreDeOferta() =  "SUPER OFERTA " + nombre
}



class Ganga inherits Producto{
	override method precioFinal() = 0
	
	override method nombreDeOferta() = nombre + " COMPRAME POR FAVOR"
}



const ganga1 = new Ganga(nombre = "papel", precioBase = 10)
const mueble1 = new Mueble(nombre = "estante", precioBase = 10)
const indumentaria1 = new Indumentaria(nombre = "remera", precioBase = 10)


