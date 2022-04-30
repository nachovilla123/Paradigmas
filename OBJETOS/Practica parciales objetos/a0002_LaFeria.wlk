// CONSIGNA _: https://docs.google.com/document/d/1uwJOJk12lq6WQesWuVYcj0uyHSYw4XJjQk7n2Llm9iY/edit

// NOTAS
// despues de un method siempre () --> volar(parametro)
// var property VARIABLE : me crea el setter y getter


// dos objetos son polimorficos para un tercero que trata de usarlos

object julieta {
    var property tickets = 15
    var cansancio = 0

    method punteria() = 20

    method fuerza() = 80 - cansancio

   // method tickets() = tickets   //getter
   //method tickets(nuevaCantidad){ tickets = nuevaCantidad} setter

    method jugar(juego){          
        tickets += juego.ticketsGanados(self)
        cansancio += juego.cansancioQueProduce()
    }

	method puedeCanjear(premio) = tickets >= premio.costo()

}

object gerundio{
	
    method jugar(juego){}  // esta implementacion es suficiente , ya que no es relevante ver el cansancio que gerundio va a guardar
    
	method puedeCanjear(premio) = true
}




///JUEGOS 

object tiroAlBlanco{
	
    method ticketsGanados(jugador) = (jugador.punteria() / 10).roundUp()

	method cansancioQueProduce(jugador) = 3 

}

object pruebaDeFuerza {
    method ticketsGanados(jugador) = if(jugador.fuerza() > 75) 20 else 0
    
    method cansancioQueProduce(jugador) = 8 
}


object ruedaDeLaFortuna {
    var property aceitada = true

    method ticketsGanados(jugador) =(0.randomUpTo(20)).roundUp() 
    
    method cansancioQueProduce(jugador) = if(aceitada) 0 else 1
}


object robarseUnTicket {
	
	method ticketsGanados(jugador) = 1
   
	method cansancioQueProduce(jugador) = 20
}


////////////////////// PREMIOS %%%%%%%%%%%%%%%%%%%%%

object ositoDePeluche{
	method costo() = 45
	
}

object taladro{
	var property costo = 200
	
}
