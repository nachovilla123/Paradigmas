object inmobiliaria {
  var porcentajePorVenta
  const empleados = #{}
  
  method porcentajeDeComisionPorVenta()= porcentajePorVenta
  method porcentajeDeComisionPorVenta(porcentaje){
  	porcentajePorVenta = porcentaje
  }

  method mejorEmpleadoSegun(criterio)= empleados.max({empleado => criterio.ponderacion(empleado)})

}

object porTotalComisiones {
	method ponderacion(empleado) = empleado.totalComisiones()
}

object porCantidadDeOperacionesCerradas {
	method ponderacion(empleado) = empleado.operacionesCerradas().size()
}

object porCantidadDeReservas {
	method ponderacion(empleado) = empleado.reservas().size()
}

class Empleado {
	const operacionesCerradas = #{}
	const reservas = #{}
	
	method operacionesCerradas() = operacionesCerradas
	method reservas() = reservas
	
	method totalComisiones() = operacionesCerradas.sum({operacion => operacion.comision()})
	
	method vaATenerProblemasCon(otroEmpleado) 
		= self.operoEnMismaZonaQue(otroEmpleado) 
			&& (self.concretoOperacionReservadaPor(otroEmpleado) || 
				otroEmpleado.concretoOperacionReservadaPor(self))
		
	method operoEnMismaZonaQue(otroEmpleado) =
		self.zonasEnLasQueOpero()
			.any({zona => otroEmpleado.operoEnZona(zona)})
			
	method operoEnZona(zona)= self.zonasEnLasQueOpero().contains(zona)
			
	method zonasEnLasQueOpero() = operacionesCerradas.map({operacion => operacion.zona()}).asSet()
	
	method concretoOperacionReservadaPor(otroEmpleado) =
		operacionesCerradas.any({operacion => otroEmpleado.reservo(operacion)})
		
	method reservo(operacion) = reservas.contains(operacion)
	
	method reservar(operacion, cliente){
		operacion.reservarPara(cliente)
		reservas.add(operacion)
	}
	method concretarOperacion(operacion, cliente){
		operacion.concretarPara(cliente)
		operacionesCerradas.add(operacion)
	}
}

class Cliente {
	var nombre
	constructor(nombreCliente){
		nombre = nombreCliente
	}
}


class Zona {
	var valor
	
	constructor(valorDeZona){
		valor = valorDeZona
	}
	
	method valor() = valor
	method valor(nuevoValor){
		valor = nuevoValor
	}
}

class Inmueble {
  const tamanio
  const cantAmbientes
  const zona
  
  constructor(unTamanio, unosAmbientes, unaZona){
  	tamanio = unTamanio
  	cantAmbientes = unosAmbientes
  	zona = unaZona
  }
  
  method valor() = self.valorParticular() + zona.valor()
  method valorParticular()
  method zona() = zona
  
  method validarQuePuedeSerVendido(){}
}

class Casa inherits Inmueble {
	var valorParticular
	constructor(unTamanio, unosAmbientes, unaZona, valor) 
	  = super(unTamanio, unosAmbientes, unaZona) {
		valorParticular = valor
	}
	
	override method valorParticular() = valorParticular
}

class PH inherits Inmueble {
	override method valorParticular() = (14000 * tamanio).max(50000)
}

class Departamento inherits Inmueble {
	override method valorParticular() = 350000 * cantAmbientes
}

class Local inherits Casa {
	var tipoDeLocal
	constructor(unTamanio, unosAmbientes, unaZona,tipo) = super(unTamanio, unosAmbientes, unaZona){
		tipoDeLocal = tipo
	}
	override method valor() = tipoDeLocal.valorFinal(super())
	override method validarQuePuedeSerVendido(){
		throw new VentaInvalida("No se puede vender un local")
	}
}

object galpon {
	method valorFinal(valorBase) = valorBase / 2
}

object aLaCalle {
	var montoFijo
	method montoFijo(nuevoMonto){
		montoFijo = nuevoMonto
	}
	
	method valorFinal(valorBase) = valorBase + montoFijo
}
class VentaInvalida inherits Exception{}


import inmobiliaria.*

class Operacion {
	const inmueble
	var estado = disponible

	constructor(unInmueble) {
		inmueble = unInmueble
	}

	method comision() method zona() = inmueble.zona()
	method reservarPara(cliente){
		estado.reservarPara(self, cliente)
	}
	method concretarPara(cliente){
		estado.concretarPara(self, cliente)
	}
	
	method estado(nuevoEstado){
		estado = nuevoEstado
	}
}

class Venta inherits Operacion {

	constructor(unInmueble) = super(unInmueble) {
		unInmueble.validarQuePuedeSerVendido()
	}
	override method comision() = inmueble.valor() * (1 + self.porcentaje() / 100)
	method porcentaje() = inmobiliaria.porcentajeDeComisionPorVenta()
}

class Alquiler inherits Operacion {
	const meses

	constructor(unInmueble, mesesDeContrato) = super(unInmueble) {
		meses = mesesDeContrato
	}

	override method comision() = meses * inmueble.valor() / 50000
}

class EstadoDeOperacion {
	method reservarPara(operacion, cliente)
	
	method concretarPara(operacion, cliente){
		self.validarCierrePara(cliente)
		operacion.estado(cerrada)
	}
	
	method validarCierrePara(cliente){}
}

object disponible inherits EstadoDeOperacion{
	override method reservarPara(operacion, cliente){
		operacion.estado(new Reservada(cliente))
	}
}

class Reservada inherits EstadoDeOperacion{
	const clienteQueReservo
	constructor(cliente){
		clienteQueReservo = cliente
	}
	
	override method reservarPara(operacion, cliente){
		throw new NoSePudoReservar("Ya había una reserva previa")
	}
	override method validarCierrePara(cliente){
		if(cliente != clienteQueReservo)
			throw new NoSePudoConcretar("La operación está reservada para otro cliente")
	}
}

object cerrada inherits EstadoDeOperacion{
	override method reservarPara(operacion, cliente){
		throw new NoSePudoReservar("Ya se cerró la operación")
	}
	override method validarCierrePara(cliente){
		throw new NoSePudoConcretar("No se puede cerrar la operación más de una vez")
	}
}

class NoSePudoReservar inherits Exception { }
class NoSePudoConcretar inherits Exception { }
