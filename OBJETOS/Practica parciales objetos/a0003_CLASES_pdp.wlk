// CLASE 3 PELADO PDP

/*
 * las clases empiezan con letra mayuscula
 * 
 * para instanciar un nuevo objeto: const pepita = new Golondrina()
 * 
 * si quiero modificar datos de la clase puedo hacer asi:
 * const pepito = new Golondrina (energia = 180)
 * 
 * 
 */

class Golondrina{

var energia = 100

method vola(kilometros){
energia = self.energia()  - kilometros * 2
}

method come(gramos){
    energia = self.energia() + gramos * 10
}

method energia() = energia

}

//const pepita = new Golondrina()

// const pepito = new Golondrina (energia = 180)
