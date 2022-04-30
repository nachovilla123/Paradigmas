import usuarios.*
import zonas.*



object app{
	
	var usuarios = [nacho]
	
	var zonas = [liniers,almagro]
	
	method pagarMulta(){
	}
	
	
	
	method usuariosComplicados(){
		usuarios.filter{usuario => usuario.multas().map{multa => multa.costo()}.sum() > 5000}
	}
	
	method zonaMasTransitada() = zonas.max{zona => zona.usuarios().size()}
	
	
	
	
}
