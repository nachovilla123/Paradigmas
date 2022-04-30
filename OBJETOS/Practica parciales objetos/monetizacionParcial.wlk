
const tagsDeModa = ["pdp","objetos"]


// USUARIOS

object usuarios{
	const todosLosUsuarios = []
	
	method emailsDeUsuariosRicos() = todosLosUsuarios
		.filter{unUsuario => unUsuario.verificado()}
		.sortedBy{uno , otro => uno.saldoTotal() > otro.saldoTotal() }
		.take(100)
		.map{usuario => usuario.email()}
		
	method cantidadSuperUsuarios() = todosLosUsuarios
	.count{ unUsuario => unUsuario.superUsuario()}
		
}

class Usuario {
	var nombre
	var email
	var property verificado = false
	var contenidosPublicados = []
	
	method saldoTotal() = contenidosPublicados.sum{unContenido => unContenido.recaudacion()}
	
	method emailDeVerificadosConSaldoMayor( )
	
	method superUsuario() = contenidosPublicados.count{unContenido => unContenido.esPopular()} >= 10

	method publicar(contenido, monetizacion){
		contenidosPublicados.add(contenido)
	}
}


// CONTENIDOS

class Contenido {
	const titulo
	var vistas = 0
	var property ofensivo = false
	var property formaMonetizacion
	
	method formaMonetizacion(nuevaMonetizacion){
		if(!nuevaMonetizacion.puedeAplicarseA(self))
		throw new DomainException(message = "El contenido no soporta la forma de monetizacion")
		
		formaMonetizacion  =  nuevaMonetizacion
	}
	
	override method initialize(){
	if(!formaMonetizacion.puedeAplicarseA(self))
		throw new DomainException(message = "El contenido no soporta la forma de monetizacion")
	}

	method recaudacion() = formaMonetizacion.recaudacionDe(self)
	method puedeVenderse() = self.esPopular()

	method esPopular()
	method recaudacionMaximaParaPublicidad()   
	method puedealquilarse()
}

class Video inherits Contenido{
	override method esPopular() = vistas > 10000
	override method recaudacionMaximaParaPublicidad() = 10000
	method puedealquilarse() = true
}

class Imagen inherits Contenido {
	var property tags = []
	override method esPopular() = self.estaALaModa()
	
	method estaALaModa() = tagsDeModa.all{tag => tags.contains(tag)}
	
	override method recaudacionMaximaParaPublicidad() = 4000
	
	method puedealquilarse() = false
} 



// FORMA DE MONETIZACION

object publicidad {
	method recaudacionDe(contenido) = (
		contenido.vistas() * 0.05 +
		if(contenido.esPopular()) 2000 else 0
		).min(contenido.recaudacionMaximaParaPublicidad())

	method puedeAplicarseA(contenido) = !contenido.ofensivo()

}

class Donacion{
	var property donaciones = 0
	
	method recaudacionDe(contenido) = donaciones
	
	method puedeAplicarseA(contenido) = true
}

class Descarga{
	var property precio
	
	override method initialize(){  // esto no hace falta que este
		if(precio < 5) throw new DomainException(message = "No mira, esto es muy barato" )
	}
	
	method recaudacionDe(contenido) = ( precio.min(5) * contenido.vistas()   )
	
	method puedeAplicarseA(contenido) = contenido.puedeVenderse()
	
}

class Alquiler inherits Descarga{
	
	override method precio() = 1 .max(super())
	
	override method puedeAplicarseA(contenido) = super(contenido) and contenido.puedealquilarse()
	
}

// RESPUESTA A PREGUNTAS TEORICAS

// Agregar un nuevo tipo de contenido es sumamente facil porque tiene la interfaz definida
// es realmente muy facil ,... sin embargo no es facil.

// permitir cambiar el tipo de contenido es algo mas dificil, ya que esta realizado con clases.
/* deberiamos tener que ponerle un atributo al contenido llamado tipo 
 * 
 * no lo hice porque el enunciado no lo pide, pero se podria hacer. para este parcial es mas complejo. y no es mejor
 * 
 * 
 * 
 * si queremos agregar un nuevo estado a los verificados, 
 * 
 * polimorfismo es el trato de un obj indistinto por un tercero.
 * 
 * no se puede enviar un mensaje si no hay polimorfismo
 * trato indistintamente a los videos y a las imagenes. alto uso polimorfismo
 
 y en 
 * 
 * hay n saldo total
 * */

