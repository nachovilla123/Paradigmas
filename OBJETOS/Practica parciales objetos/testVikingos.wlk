
import Vikingos.*

describe "Tests Vikingos" {
		var aldea = new Aldea(crucifijos = 20) 
		var aldeaAmurallada = new AldeaAmurallada(crucifijos = 20, minimosVikingos = 10) 
		var capital = new Capital(defensores = 4, riqueza = 20) 
		var soldadoArmado = new Soldado(vidasCobradas = 30,armas = 10)
		var soldadoDesarmado = new Soldado(vidasCobradas = 30, armas = 0)
		var granjeroProductivo = new Granjero(hijos = 2, hectareas = 4)
		var granjeroImproductivo = new Granjero(hijos = 2, hectareas = 0)
		var expedicion = new Expedicion(objetivos = [aldea, capital])
	

	method armarExpedicion(){
		soldadoArmado.casta(karl)
		expedicion.subir(granjeroProductivo)
		expedicion.subir(soldadoArmado)
	}
	
	// tests subir
    test "Puedo agregar soldado karl armado a la expedicion "{
    	soldadoArmado.casta(karl)
    	expedicion.subir(soldadoArmado)
    	assert.that(expedicion.integrantes().contains(soldadoArmado))
    }
     test "No puedo agregar soldado jarl con armas a la expedicion "{
    	assert.throwsExceptionLike(noPuedeSubirAExpedicion, { expedicion.subir(soldadoArmado)})
    }
     test "No puedo agregar a soldado karl sin armas a la expedicion "{
    	soldadoDesarmado.casta(karl)
    	assert.throwsExceptionLike(noPuedeSubirAExpedicion, { expedicion.subir(soldadoDesarmado)})
    }
    test "Puedo agregar granjero productivo a la expedicion "{
    	expedicion.subir(granjeroProductivo)
    	assert.that(expedicion.integrantes().contains(granjeroProductivo))
    }
     test "No puedo agregar granjero improductivo a la expedicion "{
    	assert.throwsExceptionLike(noPuedeSubirAExpedicion, { expedicion.subir(granjeroImproductivo)})
    }
    // Tests Vale la pena
	test "Aldea vale la pena para 2 invasores"{
		assert.that(aldea.valeLaPenaPara(2))
	}
	test "Capital vale la pena para 2 invasores"{
    	self.armarExpedicion() 
		assert.that(capital.valeLaPenaPara(2))
	}
	test "Aldea Amurallada no vale la pena para 2 invasores"{
    	self.armarExpedicion() 
		assert.notThat(aldeaAmurallada.valeLaPenaPara(2))
	}
	
    test "expedicion con aldea amurallada no vale la expedicion"{
    	self.armarExpedicion() 
    	expedicion.agregarLugar(aldeaAmurallada)
    	assert.notThat(expedicion.valeLaPena())
    }
    test "expedicion vale la pena"{
    	self.armarExpedicion() 
    	assert.that(expedicion.valeLaPena())
    }
	// tests realizar expedición
	
	test "Realizar expedición disminuye crucifijos"{
    	self.armarExpedicion()
    	expedicion.realizar() 
    	assert.equals(0,aldea.crucifijos())
    }
    test "Realizar expedición disminuye defensores"{
    	self.armarExpedicion()
    	expedicion.realizar() 
    	assert.equals(2,capital.defensores())
    }
    test "Realizar expedición aumenta vidas cobradas de soldado"{
    	self.armarExpedicion() 
    	expedicion.realizar()
    	assert.equals(31,soldadoArmado.vidasCobradas())
    }
    test "Capital con pocos defensores al ser invadida no recompensa con vidas a todos los invasores"{
    	self.armarExpedicion()
    	capital.defensores(1)
    	expedicion.realizar() 
    	assert.equals(30,soldadoArmado.vidasCobradas())
    }
    test "Realizar expedición aumenta correctamente dinero de integrantes"{
    	self.armarExpedicion()
    	expedicion.realizar() 
    	assert.equals((2*20+20)/2,soldadoArmado.oro())
    	assert.equals((2*20+20)/2,granjeroProductivo.oro())
    }
}
