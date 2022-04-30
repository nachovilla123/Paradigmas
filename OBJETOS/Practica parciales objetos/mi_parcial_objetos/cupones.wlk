class Cupon {
	var property usado = false
	const property porcentajeDescuento // ronda entre 0 y 1

	method aplicarDescuentoA(monto) = monto - monto * porcentajeDescuento
}

const cupon1 = new Cupon(porcentajeDescuento = 0.5)
const cupon2 = new Cupon(porcentajeDescuento = 0.1)
