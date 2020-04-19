
function selectAvat(a, user) {
    //crear path pasandole la id del avatar seleccionado
    var path = "img/PJS/" + a + ".png";
    // buscar el usuario actual en JSON si no hay usuario identificado no puede jugar
    var arGamer = user;
    if(arGamer==null){
        alert('¿ESTAS JUGANDO SIN LOGEARTE? FUERA DE AQUÍ')
        window.location.href= 'index.html'
    }
    //agregamos al objeto la ruta del avatar
    arGamer[0].avatar = path;
    localStorage.setItem('gamer', JSON.stringify(arGamer));
    // a ese usuario actualizar el avatar con el path de la foto

    // quitar los avatares de la pantalla
    var o = document.querySelectorAll('.selecAcatar');
    for (let i = 0; i < o.length; i++) {
        o[i].style = 'display:none'

    }
    // agregar boton empezar partida y quitar el texto de los avatares
    var btnStart = document.getElementById('btnStart');
    var btnStartArma = document.getElementById('btnStartArma');
    var txtAv = document.getElementById('txtAv');
    // empiza el juego
    btnStartArma.style = 'display:block';
    btnStart.style = 'display:block';
    txtAv.style = 'display:none'
}
//movimiento del arma
let arma = document.getElementById('arma');

function coordenadas(event) {
    x = event.clientX;
    y = event.clientY;

    arma.setAttribute('style', 'top:' + y + 'px;left:' + x + 'px; display:block;');
    
}

// Variables de juego
var monsters = 10;
var copiaMonsters = monsters;
var tiempo = 0;
var tiempoInterval = null;
var balas = 6;
var isRecargando = false;
var isJugando = false;


var contador = 0;
var contenedor = document.getElementById('contenedor');
var timeNivel = 500;

var mensaje = document.createElement('h1');
mensaje.setAttribute('class', 'cambioNivel');
mensaje.setAttribute("style", "display:none");
mensaje.id = 'idMensaje';
contenedor.appendChild(mensaje);

function startJuego(bool) {
    if(!bool){
        arma.setAttribute('style', 'display:none;');
            contenedor.setAttribute('onMouseMove','coordenadas(event)')
    }
    
    isJugando = true;
    monsters = 10;
    copiaMonsters = monsters;
    tiempo = 0;
    balas = 6;
    contador = 0;
    timeNivel = 500;

    var btnFinales = document.getElementById('botonesFinal');
    btnFinales.style = 'display:none;'
// variables y elementos que se verán en la pantalla
    var kills = document.getElementById('totalMonster');
    var timer = document.getElementById('time');
    var ammo = document.getElementById('municion');
    var btn = document.getElementById('boton');

    kills.style = 'display:initial';
    timer.style = 'display:initial';
    ammo.style = 'display:initial';
    btn.style = 'display:none';


    toggleTiempo(true);
// añadimos mounstros llamando a crearMonster por tiempo
    setInterval(crearMonster, timeNivel);
}

function crearMonster() {
    //si estamos jugando y no ah terminado el juego
    if (isJugando && !terminaJuego()) {

    //variables para cojer el alto y anho de la pantalla y los enemígos salgan entre dichos margenes
        var alto = Math.floor(window.innerHeight) - 300;
        var ancho = Math.floor(window.innerWidth) - 200;
    //crear enemigos según la cantidad especificada
        if (contador < monsters) {
            var n = Math.random() * (7 - 0) + 0;
            var randomAlto = Math.random() * (alto - 0) + 0;
            var randomAncho = Math.random() * (ancho - 0) + 0;
            var monster = document.createElement('div');
            monster.setAttribute('id', 'monster' + contador)
            monster.setAttribute('class', 'monster');

            monster.addEventListener('click', destruirMonsters, false);

            monster.setAttribute('style', 'top:' + Math.floor(randomAlto) + 'px;left:' + Math.floor(randomAncho) + 'px;  background-image: url(img/zombies/zzombie' + Math.floor(n) + '.png);')

            contenedor.appendChild(monster);

            contador++
        } else {
            //limpiamos o  paramos el intervalo que llama a esta función
            clearInterval(crearMonster);
        }
    }

}

function toggleTiempo(bool) {
    //controlar el tiempo
    // si está true entra y si no para el intervalo 
    if (bool) {
        //intervalo que cada segundo "1" y muestra por pantalla
        tiempoInterval = setInterval(() => {
            tiempo++;
            document.getElementById('time').innerHTML = tiempo;
        }, 1000);
    } else {

        clearInterval(tiempoInterval);
    }


}

function destruirMonsters(e) {
    //funcion que es llamada desde el juego.html para eliminar el enemigo clickeado
 // si no ah terminado el juego, si no está recargando y si está jugando puedes destruir al enemigo 
    if (!terminaJuego()) {

        if (!isRecargando && isJugando) {
            //efectos jquery ui al clickear en el enemigo
            $('#' + e.srcElement.id).effect("explode", 500, callback);

            // Borrar el elemento
            $('#' + e.srcElement.id).remove();
            // restar uno a la cantidad de enemigos que aparecen por pantalla
            var m = document.getElementById('totalMonster');
            copiaMonsters--;
            m.innerHTML = copiaMonsters;
            //effectors jquery ui
            function callback(e) {
                setTimeout(function () {
                    $('#' + e).removeAttr("style").hide().fadeIn();
                }, 1000);
            };
        }
        //si terminar la partida devuelve verdadero que es lo que sucede cuando copiamonster llega a 0  pasamos al siguiente nivel
        terminoPartida() ? siguienteNivel() : null;
    } else {
        clearInterval(crearMonster);
    }
};

var fon = 0

function siguienteNivel() {
    //Al pasar de nivel se resta el intervalo en el que se crea los enemigos
    timeNivel -= 500;
    //Cambiamos el fondo del terreno de juego
    contenedor.style = 'background-image: url("img/fondo' + (fon + 1) + '.jpg");';
    fon++;
    //si no ha terminado jego
    if (!terminaJuego()) {
        //paramos el contador hasta le siguiente oleada
        toggleTiempo(false);
        setTimeout(function () {

            mensaje.innerHTML = 'Preparate para la siguiente oleada'
            mensaje.style = "display:block"


            setTimeout(() => {
                //iniciamos el siguiente nivel
                toggleTiempo(true);

                mensaje.style = "display:none"

                monsters += 10;
                copiaMonsters = monsters;

                var m = document.getElementById('totalMonster');
                m.innerHTML = copiaMonsters;



                contador = 0;

                balas = Math.floor(monsters / 2);
                document.getElementById('municion').innerHTML = balas;

                setInterval(crearMonster, timeNivel);

            }, 4000);
        }, 2000);
    } else {
        //si ha terminado la partida mostraremos un mensaje por pantalla, pararemos el tiempo y llamaremos a finpartida()
        var gif = document.createElement('img');
        mensaje.innerHTML = 'FIN DE LA PARTIDA<br>'
        mensaje.style = "display:block"
        gif.setAttribute('src','img/bailarin/bailarin.gif')
        contenedor.appendChild(gif);
        contenedor.style = "text-align: center;"

        toggleTiempo(false);
        finPartida()
    }
    /// Aqui ponemos lo que pasa cuando acaba el turno/nivel

}
//se usa para pasar al siguiente nivel cuando copiaMonster llega a 0 devueve true 
const terminoPartida = () => copiaMonsters == 0 ? true : false;
//se usa para finalizar la partida cuando el intervelo es menor de 500 (el ultimo nivel es 500 lo que viene a ser medio segundo)
const terminaJuego = () => timeNivel < 500 ? true : false;



contenedor.addEventListener('click', function () {
   
    // al hacer click en la pantalla del juego
    if (!isRecargando && isJugando && !terminaJuego()) {
        //si no está recargadno y si está jugando  descuenta balas al cargador y añade sonido, además se muestra por pantalla
        if (balas > 1) {
            var audioElement = document.createElement('audio');
            audioElement.setAttribute('src', 'Sounds/disparo.mp3');
            balas--
            audioElement.play();
            document.getElementById('municion').innerHTML = balas;
        } else {
            var audioElement = document.createElement('audio');
            audioElement.setAttribute('src', 'Sounds/disparo.mp3');
            audioElement.play();
            balas = 0;
            document.getElementById('municion').innerHTML = balas;
            isRecargando = true;
            setTimeout(() => {
                balas = Math.floor(monsters / 2);
                document.getElementById('municion').innerHTML = balas;

                $('#municion').effect("bounce", 2000, callback);

                function callback() {
                    setTimeout(function () {
                        $('#municion').removeAttr("style").hide().fadeIn();
                    }, 1000);
                };
                isRecargando = false;
            }, 2000);

        }
    }
}, false); 

function finPartida() {
    arma.setAttribute('style', 'display:none;');
    //Paramos el tiempo
    toggleTiempo(false);
    //aparecen los botones finales
    var btnFinales = document.getElementById('botonesFinal');
    btnFinales.style = 'display:block; '
    //musica final
    var audioElement = document.createElement('audio');
    miedo.pause();
    audioElement.setAttribute('src', 'Sounds/winer.mp3');
    audioElement.play();

}

// function exit() {
//     //salimos de la partida redireccionado al index.html
//     var arGamer = JSON.parse(localStorage.getItem('gamer'));
//     arGamer.length = 0;
//     localStorage.setItem('gamer', JSON.stringify(arGamer));
//     window.location.href = '../pages/pagina-principal.php'
// }
    
function save() {
    //Guardamos en el localStorage la puntuación del jugador
    var arGamer = JSON.parse(localStorage.getItem('gamer'));
    arGamer[0].score = tiempo;
    localStorage.setItem('gamer', JSON.stringify(arGamer));
    //buscamos el jugador que a iniciado la partida que sea igual al array de los usuarios, y se modifica el escore de dicho jugador
    var arUsuario = JSON.parse(localStorage.getItem('usuarios'));
    for (let i = 0; i < arUsuario.length; i++) {
        if (arUsuario[i].nombre == arGamer[0].nombre) {
            arUsuario[i].score = tiempo;
            arUsuario[i].avatar = arGamer[0].avatar;
            localStorage.setItem('usuarios', JSON.stringify(arUsuario));
            arGamer.length = 0;
            localStorage.setItem('gamer', JSON.stringify(arGamer));
            break;
        }

    }
    alert(' Se a guardado tu partida correctamente!! ')

}
function reiniciar(){
    window.location.href = 'juego.html';
}