class Naves{
    var velocidad
    var direccion
    var combustible

    method acelerar(cuanto){velocidad=(velocidad + cuanto).min(100000)}
    method desacelerar(cuanto){velocidad=(velocidad - cuanto).max(0)}

    method irHaciaElSol(){direccion=10}
    method escaparDelSol(){direccion=-10}
    method ponerseParaleloAlSol(){direccion=0}

    method acercarseUnPocoAlSol(){direccion=(direccion + 1).min(10)}
    method alejarseUnPocoDelSol(){direccion=(direccion - 1).max(-10)}
    
    //combustible
    method cargarCombustible(cantidad){combustible=combustible + cantidad}
    method descargarCombustible(cantidad){combustible=combustible - cantidad}
    
    method prepararViaje(){
        self.cargarCombustible(30000)
        self.acelerar(5000)
    }

    //estado de tranqulidad
    method estaTranquila(){
        return combustible >= 4000 and velocidad <=12000 and self.condicionAdicional()
    }

    //condicionesAdicionales
    method condicionAdicional(){return true}

    //recibir amenaza
    method recibirAmenaza(){
        self.escapar()
        self.avisar()
    }
    method escapar()
    method avisar()

    //relajo

    method estaDeRelajo(){
        return self.estaTranquila() and self.tenerPocaActividad()
    }
    method tenerPocaActividad()
}

class Naves_baliza inherits Naves{
    var colorBaliza="verde"
    var cantidadCambiosColor=0

    method colorBaliza(){return colorBaliza}

    method cambiarColorDeBaliza(colorNuevo){
        colorBaliza=colorNuevo
        cantidadCambiosColor=cantidadCambiosColor + 1
        }
    
    override method prepararViaje(){    
    super()
    self.cambiarColorDeBaliza("verde") 
    self.ponerseParaleloAlSol()
    }

    override method condicionAdicional(){
    return self.colorBaliza() != "rojo"   
    }
    override method escapar(){
        self.irHaciaElSol()
    }
    override method avisar(){
        self.cambiarColorDeBaliza("rojo")
    }
    override method tenerPocaActividad(){
        return cantidadCambiosColor==0
    }


}

class Naves_pasajeros inherits Naves {
    var racionesDeComida
    var racionesDeBebida
    var property  cantidadDePasajeros=0
    var  totalRacionesComidasServidas=0

    method cargarRacionDeComida(cantidad){racionesDeComida=racionesDeComida + cantidad}
    method descargarRacionDeComida(cantidad){
        racionesDeComida= (racionesDeComida - cantidad).max(0)
        totalRacionesComidasServidas=totalRacionesComidasServidas + cantidad
        }

    method cargarRacionDeBebida(cantidad){racionesDeBebida= racionesDeBebida + cantidad}
    method descargarRacionDeBebida(cantidad){racionesDeBebida=(racionesDeBebida - cantidad).max(0)}

    override method prepararViaje(){
        super()
        self.cargarRacionDeComida(4 * cantidadDePasajeros)  
        self.cargarRacionDeBebida(6 * cantidadDePasajeros)
        self.acercarseUnPocoAlSol()
    }
    override method escapar(){
        self.acelerar(velocidad)
    }
    override method avisar(){
        self.descargarRacionDeComida(1 * cantidadDePasajeros)
        self.descargarRacionDeBebida(2 * cantidadDePasajeros)
    }
    override method tenerPocaActividad(){
        return totalRacionesComidasServidas < 50
    }
}

class Naves_Combate inherits Naves{
    var estaInvisible = false
    var misilesDesplegados = false 
    const mensajesEmitidos = []

    method estaVisible(){return not estaInvisible}  

    method ponerseVisible(){estaInvisible=false}
    method ponerseInvisible(){estaInvisible=true}
    

    method desplegarMisiles(){misilesDesplegados=true}
    method replegarMisiles(){misilesDesplegados=false}
    method misilesDesplegados(){return misilesDesplegados }

    method emitirMensaje(mensaje){mensajesEmitidos.add(mensaje)}
    method mensajesEmitidos(){return mensajesEmitidos}
    method primerMensajeEmitido(){return mensajesEmitidos.first()}
    method ultimoMensajeEmitido(){return mensajesEmitidos.last()}
    method esEscueta(){return not mensajesEmitidos.any({m => m.size()>30})}
    method emitioMensaje(mensaje){return mensajesEmitidos.contains(mensaje)}
    
    override method prepararViaje(){
        super()
        self.ponerseVisible()
        self.replegarMisiles()
        self.acelerar(15000)
        self.emitirMensaje("saliendo en mision")
    }
    override method condicionAdicional(){
    return not self.misilesDesplegados()
    }
    override method escapar(){
        self.acercarseUnPocoAlSol()
        self.acercarseUnPocoAlSol()
    }
    override method avisar(){
        self.emitirMensaje("Amenaza recibida")
    }
}

class NaveHospital inherits Naves_pasajeros{
    var quirofanosPreparados= true

    method tieneQuirofanosPreparados(){return quirofanosPreparados}
    method prepararQuirofanos(){quirofanosPreparados=true}
    method desarmarQuirofanos(){quirofanosPreparados=false}

    override method condicionAdicional(){
        return super() and not quirofanosPreparados
    }
    override method recibirAmenaza(){
        super()
        self.prepararQuirofanos()
    }
}

class NaveSigilosa inherits Naves_Combate{

override method condicionAdicional(){
    return super() and self.estaVisible()
}
override method escapar(){
    super()
    self.desplegarMisiles()
    self.ponerseInvisible()
}
}