// CLASE 4 PDP COLECCIONES
// la lista es un objeto que tiene acciones interesantes para hacer

// ----------------ENUNCIADO ----------------//
/*                             
 * Consultar cuantos litros de leche que podemos ordeñar de bichos contentas
 * 
 * saber si todas las bichos estan contentas
 * 
  ordeñar todas las bichos contentas
  * 
 * podemos agregar cabras? si, el corral no tiene nada que ver con las bichos
 *  lo que hay que hacer es tener codigo polimorfico ( donde dice animal antes iba bicho
 * */

class Corral{
	
	const bichos = []
	
	// una opcion: method lecheDisponible() = bichos.filter{bicho => bicho.estaContenta()} . map{ bicho => bicho.litrosDeLeche() } . sum ()

	method lecheDisponible() = bichos.filter{ bicho => bicho.estaContenta() } . sum { bicho => bicho.litrosDeLeche() } 
	
	method todasContentas() = bichos.all { bicho => bicho.estaContenta() }
	
	method ordeniar (){
		
		bichos.forEach { bicho => 
			if(bicho.estaContenta() )
			 bicho.ordeniar()
		}
	}
	
	}//fin clase corral

class Vaca {
	
	//method estaContenta() = no importa como lo hace para lo que queria mostrar esta clase
	
//	method litrosDeLeche() = 2
	
	//method ordeniar() = 2
}


object criterioEstaContenta {
	
	method apply(bicho) = bicho.estacontenta()
	
}

//--------------------- in consola ---------------------//
//const bichos = [new bicho(), new bicho()]

/* bichos.add(new bicho())
 * 
 * bichos.size()
 * 
 * EL FILTER SE HACE ASI :
 * bichos.filter( { bicho => bicho.estaContenta()} )
 * y devolveria esto:    [bichoContenta1,bichoContenta2]
*/

// identico : que sea unico.  igual: que sean iguales pero no tienen que ser unicas
