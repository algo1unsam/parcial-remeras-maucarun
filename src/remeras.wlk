class RemeraLisa {
	var property talle
	var property color
	
	method costoPorTalle() {
		if (talle>=32 and talle<=40)
			return 80
		else
			(talle>=41 and talle<=48)
				return 100
	}
	
	method costoPorColor() {
		if (color == "blanco" or color == "negro" or color == "gris")
			return 0
		else
			return self.costoPorTalle()*0.10
	}
	
	method costo() {
		return self.costoPorTalle() + self.costoPorColor()
	}
	
	method descuento() {
		return 0.10
	}
}

class RemeraBordada inherits RemeraLisa {
	var property coloresBordado = []
	
	method costoBordado() {
		if (coloresBordado.size() <= 2) 
			return 20
		else
			return coloresBordado.size()*10
	}
	
	override method costo() {
		return self.costoPorTalle() + self.costoPorColor() + self.costoBordado()
	}
	
	override method descuento() {
		return 0
	}
}

class RemeraSublimada inherits RemeraLisa {
	var property alto
	var property ancho
	var property derechos
	var property convenio = false
	const valorCm2 = 0.50
	
	method superficie() {
		return alto * ancho
	}
	
	method costoSublimado() {
		return self.superficie() * valorCm2 + derechos
	}
	
	override method costo() {
		return self.costoPorTalle() + self.costoPorColor() + self.costoSublimado()
	}
	
	override method descuento() {
		if (convenio)
			return 0.20
		else
			return 0.10
	}
}

class Pedido {
	var property tipo
	var property color
	var property talle
	var property cantidad
	var property sucursal
	
	method precio() {
		return tipo.costo() * cantidad
	}
	
	method descuento() {
		if (cantidad>=sucursal.cantidadMinima())
			return tipo.descuento()*self.precio()
		else
			return 0
	}
	
	method precioFinal() {
		return self.precio() - self.descuento()	
	}
}

class Sucursal {
	const property cantidadMinima
}

object empresa {
	var pedidos = []
	
	method nuevoPedido(pedido) {
		pedidos.add(pedido)
	}
	
	method facturacionTotal() {
		return pedidos.sum{pedido=>pedido.precioFinal()}
	}
	
	method pedidosDeSucursal(sucursal) {
		return pedidos.filter{pedido=>pedido.sucursal() == sucursal}
	}
	
	method facturacionSucursal(sucursal) {
		return self.pedidosDeSucursal(sucursal).sum{pedido=>pedido.precioFinal()}
	}
	
	method listaSucursales(){
		return pedidos.map{pedido=>pedido.sucursal()}
	}
	
	method sucursalMayorFacturacion() {
		return self.listaSucursales().max{sucursal=>self.facturacionSucursal(sucursal)}
	}
	
	method cantPedidosColor(color) {
		return pedidos.count{pedido=>pedido.color()==color}
	}
	
	method pedidoMasCaro() {
		return pedidos.max{pedido=>pedido.precioFinal()}
	}
	
	method sucursalesVendieronTalles() {
		return self.listaSucursales().filter{sucursal=>self.sucursalVendioTalles(sucursal)}
	}
	
	method sucursalVendioTalles(sucursal) {
		return 0
	}
	
	method tallesPedidosDeSucursal(sucursal) {
		return self.pedidosDeSucursal(sucursal).map{pedido=>pedido.talle()}
	}
}