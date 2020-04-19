//Cuando iniciamos el index deslogeamos el usuario
var arGamer = JSON.parse(localStorage.getItem('gamer'));
if(arGamer != null){
    arGamer.length = 0;
    localStorage.setItem('gamer', JSON.stringify(arGamer));
}
//Buscar en localStorage el JSON de usuarios
function registro() {
    var arUsuario = JSON.parse(localStorage.getItem('usuarios'));
    //Si no existe crearlo
    if (arUsuario == null) {
        arUsuario = []
    }
    //Recoger los valores del registro 
    var nameUsu = document.getElementById('UsuarioReg').value;

    var passUno = document.getElementById('PassReg1').value;
    var passConf = document.getElementById('repPass').value;

    //ver si las contraseñas coinciden crear objeto usuario
    if (passUno == passConf) {
        var usuario = {
            nombre: nameUsu,
            contraseña: passConf,
            score: 0,
            avatar: 'img/PJS/sinLog.gif'
        }
        var contiene = false;
        for (let i = 0; i < arUsuario.length; i++) {
            if (usuario.nombre == arUsuario[i].nombre) {
                contiene = true;
                break;
            }
        }
        if (contiene == false) {
            arUsuario.push(usuario)
        } else {
            alert('El nombre de Usuario ya existe, se mas original')
        }
        localStorage.setItem('usuarios', JSON.stringify(arUsuario));


    } else {
        alert('Introduce bien las contraseñas');
    }
}

function mostrarMensaje(mensaje) {
    var msj = document.getElementById('iniciarJuego');
    msj.style = 'display: block;'
    msj.innerHTML = mensaje;
}

function login() {
    //comprobar si el usuario existe
    var arUsuario = JSON.parse(localStorage.getItem('usuarios'));
    //si el usuario no  existe
    if (arUsuario == null) {
        mostrarMensaje('Tienes que registrarte primero');

    } else {
        var us = document.getElementById('nombreLogin').value;
        var con = document.getElementById('PassUsu').value;
        var contiene = false;
        for (let i = 0; i < arUsuario.length; i++) {
            if (arUsuario[i].nombre == us && arUsuario[i].contraseña == con) {
                contiene = true;
                break;
            }
        }
        if (contiene == true) {
            var arGamer = JSON.parse(localStorage.getItem('gamer'));
            if (arGamer == null) {
                arGamer = []
            }
            var gamer = {
                nombre: us,
                score: 0,
                avatar: ''
            }

            arGamer.push(gamer);
            localStorage.setItem('gamer', JSON.stringify(arGamer));


            mostrarMensaje('Bienvenido ' + us + ', ya puede jugar!');

            // Set effect from select menu value

            var play = document.getElementById('botonPlay');
            //play.addEventListener('click', () => window.location.href = 'juego.html', false);
        } else {
            mostrarMensaje('Usuario o contraseña incorrectos!');
        }

    }

}

function play() {
    if (JSON.parse(localStorage.getItem('gamer')).length != 0) {
        window.location.href = 'juego.html';
    } else {
        mostrarMensaje('Para poder jugar tienes que identificarte')

    }

}
// si no mostrar mensaje