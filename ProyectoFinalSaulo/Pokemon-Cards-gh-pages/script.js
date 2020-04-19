let pokemon = [];
let rutasUsadas = [];
let rutasDobles = [];
var puntuación = 0;
var cartaAbierta;
var contadorVolteadas = 0;
var rutaAnterior = "";
var rutaActual = "";
var cartaAnterior;
var cartaActual;
var igualdad;
var contadorIgualdad = 0;
var puntos = 0;
var cartas;
var contadorAciertos = 0;
var centesimas = 0;
var segundos = 0;
var minutos = 0;
var horas = 0;

//Cargo el tablero de cartas
function cargar(cards) {
	cartas = cards;
	var numCards = cards + 1;
	var tamImagen = "";
	cargarImagenes();

	//Borro por si acaso hay alguno antes
	var divPadre = document.getElementById("div1");
	var divHijo = document.getElementById("contenedor");
	divPadre.removeChild(divHijo);

	//Vuelvo a crearlo
	var div = document.createElement("div");
	div.setAttribute("id", "contenedor");
	div.setAttribute("class", "container");

	//Creo las cartas 
	if (cards == 16) {
		tamImagen = "120";
		div.setAttribute("style", "grid-template-rows: repeat(4, 120px); grid-template-columns: repeat(4, 120px);");
	} else if (cards == 36) {
		tamImagen = "120";
		div.setAttribute("style", "grid-template-rows: repeat(6, 120px); grid-template-columns: repeat(6, 120px);");
	} else if (cards == 64) {
		tamImagen = "120";
		div.setAttribute("style", "grid-template-rows: repeat(8, 120px); grid-template-columns: repeat(8, 120px);");
	}

	var efectoCarta = tamImagen / 2;

	//Genero la primera mitad de la tabla
	for (let i = 1; i < (numCards / 2); i++) {
		var carta = document.createElement("div");
		carta.setAttribute("class", "card");
		carta.setAttribute("id", "card" + i);
		carta.setAttribute("onclick", "girarCarta(this);");
		carta.setAttribute("style", "width:" + tamImagen + "px;height:" + tamImagen + "px;transform-origin: 100% " + efectoCarta + "px;");

		var front = document.createElement("div");
		front.setAttribute("class", "front");
		var back = document.createElement("div");
		back.setAttribute("class", "back");
		var img = document.createElement("img");
		var ruta = pokemon[getRandomArbitrary(0, 53)];

		while (repetido(rutasUsadas, ruta) == true) {
			ruta = pokemon[getRandomArbitrary(0, 53)];
		}

		rutasUsadas[(i - 1)] = ruta;
		img.setAttribute("src", ruta);
		img.setAttribute("style", "width:" + tamImagen + "px;height:" + tamImagen + "px");
		back.appendChild(img);

		carta.appendChild(front);
		carta.appendChild(back);

		div.appendChild(carta);
		divPadre.appendChild(div);
	}

	//Genero la segunda mitad de la tabla
	for (let i = Math.floor(((numCards / 2) + 1)); i < numCards; i++) {
		var carta = document.createElement("div");
		carta.setAttribute("class", "card");
		carta.setAttribute("id", "card" + i);
		carta.setAttribute("onclick", "girarCarta(this);");
		carta.setAttribute("style", "width:" + tamImagen + "px;height:" + tamImagen + "px;transform-origin: 100% " + efectoCarta + "px;");

		var front = document.createElement("div");
		front.setAttribute("class", "front");
		var back = document.createElement("div");
		back.setAttribute("class", "back");
		var img = document.createElement("img");
		var ruta = rutasUsadas[getRandomArbitrary(0, rutasUsadas.length)];

		while (repetido(rutasDobles, ruta) == true) {
			ruta = rutasUsadas[getRandomArbitrary(0, rutasUsadas.length)];
		}

		rutasDobles[(i - 1)] = ruta;
		img.setAttribute("src", ruta);
		img.setAttribute("style", "width:" + tamImagen + "px;height:" + tamImagen + "px");
		back.appendChild(img);

		carta.appendChild(front);
		carta.appendChild(back);

		div.appendChild(carta);
		divPadre.appendChild(div);
	}
}

//Me compara que no haya una imagen repetida en el array que le paso
function repetido(array, img) {
	for (var i = 0; i < array.length; i += 1) {
		if (array[i] == img)
			return true;
	}
}

//Genero el número random sin decimales
function getRandomArbitrary(min, max) {
	return Math.floor(Math.random() * (max - min) + min);
}

//Abro el nivel facil, con 16 cartas
function abrirFacil() {
	miVentana = window.open("juegoFacil.html");
}

//Abro el nivel medio, con 36 cartas
function abrirMedio() {
	miVentana = window.open("juegoMedio.html");
}

//Abro el nivel dicifil, con 64 cartas
function abrirDificil() {
	miVentana = window.open("juegoDificil.html");
}

function girarCarta(e) {
	contadorVolteadas += 1;
	var carta = e;
	var puntuacion = document.getElementById("puntuacion");
	var puntosActuales = 0;
	var front = e.lastChild;
	var img = front.firstChild;
	var ruta = img.src;

	if (comprobarGanado() == true) {
		alert("¡Ya has ganado!");
	} else

	if (contadorVolteadas <= 2) {
		carta.setAttribute("style", "transform: rotateX(180deg);");
		//Desactivo la posibilidad de que se haga doble click en la misma carta girada y sume puntos
		carta.setAttribute("onclick", "desactivaClick(this.id)");

		if (contadorVolteadas == 1) {
			rutaAnterior = ruta;
			cartaAnterior = carta;

		} else if (contadorVolteadas == 2) {
			rutaActual = ruta;
			cartaActual = carta;

			if (rutaAnterior == rutaActual) {
				igualdad = true;
				puntosActuales = parseInt(puntuacion.innerHTML);
				puntos = puntosActuales + 10;
				puntuacion.innerHTML = puntos;
				contadorAciertos += 1;

				if (comprobarGanado() == true) {
					var nom = formularioFinPartida();
					var tiempo = "" + minutos + " minutos, " + segundos + " segundos";

					//DECLARO EL OBJETO PARTIDA
					var p = {
						nombre: nom,
						pun: puntos,
						tiem: tiempo,
						fech: getFechaHoy()
					};

					alert("Datos de la partida: " + "\nNombre: " + p.nombre + "\nPuntos: " + p.pun + "\nTiempo: " + p.tiem + "\nFecha: " + p.fech);
					var partidaGuardar = JSON.stringify(p);
					localStorage.setItem("partida" + getRandomArbitrary(2, 10000), partidaGuardar);

					//Por si quiere jugar otra partida
					var c = confirm("¿Desea jugar otra partida?");
					if (c != false) {
						location.reload();
					} else {
						miVentana2 = window.close();
					}

				}
			} else {
				igualdad = false;
				puntosActuales = parseInt(puntuacion.innerHTML);
				puntos = puntosActuales - 1;
				puntuacion.innerHTML = puntos;
			}
		}

	} else if (contadorVolteadas > 2) {
		if (igualdad == false) {
			//Hago que se vuelvan a dar la vuelta, las cartas giradas
			cartaAnterior.setAttribute("style", "transform: rotateX(360deg);");
			cartaActual.setAttribute("style", "transform: rotateX(360deg);");
		} else if (igualdad == true) {
			igualdad = false;
		}
		contadorVolteadas = 0;
		//Vuelvo a añadir a las cartas giradas, la función desactivada con anterioridad
		cartaAnterior.setAttribute("onclick", "girarCarta(this);");
		cartaActual.setAttribute("onclick", "girarCarta(this);");
	}
}

function comprobarGanado() {
	if (cartas == 16) {
		if (contadorAciertos == 8) {
			return true;
		}
	} else if (cartas == 36) {
		if (contadorAciertos == 18) {
			return true;
		}
	} else if (cartas == 64) {
		if (contadorAciertos == 32) {
			return true;
		}
	}
}

function desactivaClick(id) {
	document.getElementById(id).disabled = true;
}

function activaClick(id) {
	document.getElementById(id).disabled = false;
}


//Cargo las imágenes en la tabla
function cargarImagenes() {

	pokemon[0] = "pokemon/aerodactyl.png";
	pokemon[1] = "pokemon/arcanine.png";
	pokemon[2] = "pokemon/banette.png";
	pokemon[3] = "pokemon/blastoise.jpg";
	pokemon[4] = "pokemon/buterfree.jpg";
	pokemon[5] = "pokemon/charizard.png";
	pokemon[6] = "pokemon/cyndaquil.jpg";
	pokemon[7] = "pokemon/ditto.png";
	pokemon[8] = "pokemon/doduo.png";
	pokemon[9] = "pokemon/eevee.png";
	pokemon[10] = "pokemon/electabuzz.png";
	pokemon[11] = "pokemon/exeggcute.png";
	pokemon[12] = "pokemon/gastly.png";
	pokemon[13] = "pokemon/graveler.jpg";
	pokemon[14] = "pokemon/gyarados.png";
	pokemon[15] = "pokemon/hitmonchan.png";
	pokemon[16] = "pokemon/horsea.png";
	pokemon[17] = "pokemon/jigglypuff.png";
	pokemon[18] = "pokemon/jynx.png";
	pokemon[19] = "pokemon/kangaskhan.png";
	pokemon[20] = "pokemon/machoke.png";
	pokemon[21] = "pokemon/magikarp.png";
	pokemon[22] = "pokemon/magmar.png";
	pokemon[23] = "pokemon/marowak.png";
	pokemon[24] = "pokemon/meowth.png";
	pokemon[25] = "pokemon/mew.jpg";
	pokemon[26] = "pokemon/mewtwo.png";
	pokemon[27] = "pokemon/mrmime.jpg";
	pokemon[28] = "pokemon/nidoran.png";
	pokemon[29] = "pokemon/ninetales.png";
	pokemon[30] = "pokemon/oddish.jpg";
	pokemon[31] = "pokemon/omanyte.gif";
	pokemon[32] = "pokemon/onix.png";
	pokemon[33] = "pokemon/persian.png";
	pokemon[34] = "pokemon/pichu.png";
	pokemon[35] = "pokemon/pikachu.png";
	pokemon[36] = "pokemon/pinsir.png";
	pokemon[37] = "pokemon/porygon.png";
	pokemon[38] = "pokemon/psyduck.png";
	pokemon[39] = "pokemon/rhydon.png";
	pokemon[40] = "pokemon/seadra.png";
	pokemon[41] = "pokemon/seel.png";
	pokemon[42] = "pokemon/shinx.jpg";
	pokemon[43] = "pokemon/slowbro.png";
	pokemon[44] = "pokemon/snorlax.png";
	pokemon[45] = "pokemon/squirtle.png";
	pokemon[46] = "pokemon/tauros.png";
	pokemon[47] = "pokemon/vaporeon.png";
	pokemon[48] = "pokemon/venomoth.jpg";
	pokemon[49] = "pokemon/voltorb.png";
	pokemon[50] = "pokemon/wailmer.png";
	pokemon[51] = "pokemon/weedle.png";
	pokemon[52] = "pokemon/weezing.jpg";
	pokemon[53] = "pokemon/zapdos.png";

}

function inicio() {
	control = setInterval(cronometro, 10);
}

function parar() {
	clearInterval(control);
}

function cronometro() {
	if (centesimas < 99) {
		centesimas++;
		if (centesimas < 10) {
			centesimas = "0" + centesimas
		}
		Centesimas.innerHTML = ":" + centesimas;
	}
	if (centesimas == 99) {
		centesimas = -1;
	}
	if (centesimas == 0) {
		segundos++;
		if (segundos < 10) {
			segundos = "0" + segundos
		}
		Segundos.innerHTML = ":" + segundos;
	}
	if (segundos == 59) {
		segundos = -1;
	}
	if ((centesimas == 0) && (segundos == 0)) {
		minutos++;
		if (minutos < 10) {
			minutos = "0" + minutos
		}
		Minutos.innerHTML = ":" + minutos;
	}
	if (minutos == 59) {
		minutos = -1;
	}
	if ((centesimas == 0) && (segundos == 0) && (minutos == 0)) {
		horas++;
		if (horas < 10) {
			horas = "0" + horas
		}
		Horas.innerHTML = horas;
	}
}

function formularioFinPartida() {
	var person = prompt("Introduzca su nombre:", "Daniel");
	if (person == null || person == "") {
		txt = "Error.";
	} else {
		return person;
	}
}

function getFechaHoy() {
	var today = new Date();
	var dd = today.getDate();
	var mm = today.getMonth() + 1; //January is 0!

	var yyyy = today.getFullYear();
	if (dd < 10) {
		dd = '0' + dd;
	}
	if (mm < 10) {
		mm = '0' + mm;
	}
	var today = dd + '/' + mm + '/' + yyyy;
	return today;
}

function cargarPuntuaciones() {
	var div = document.getElementById("puntuaciones");
	var lista = [];

	//Recorro el localStorage, y guardo los objetos partida en una lista
	for (var i = 0; i < localStorage.length; i++) {
		var clave = localStorage.key(i);
		var valor = JSON.parse(localStorage.getItem(clave));
		lista[i] = valor;
	}

	//Ordena la lista de objetos de partidas, por la puntuación
	lista.sort(function (a, b) {
		if (a.pun > b.pun) {
			return -1;
		}
		if (a.pun < b.pun) {
			return 1;
		}
		//Si las puntuaciones son iguales, las ordena también según el tiempo
		if (a.pun == b.pun) {
			if (a.tiem < b.tiem) {
				return -1;
			}
			if (a.tiem > b.tiem) {
				return 1;
			}
		}
		return 0;
	});

	//Saco el top 5 de las puntuaciones
	for (var i = 0; i < 5; i++) {
		var txt = document.createTextNode("" + (i + 1) + ". " + lista[i].pun + " puntos ( " + lista[i].nombre + "  -  " + lista[i].tiem + "  -  " + lista[i].fech + " )");
		var h3 = document.createElement("h3");
		h3.appendChild(txt);
		div.appendChild(h3);
	}

}

//Borro el historial de partidas
function borrarStorage() {
	var contador = 0;

	for (var i = 0; i < localStorage.length; i++) {
		contador += 1;
	}

	var c = confirm("¿Está seguro de que quiere eliminar su historial de partidas?");
	if (c != false) {
		alert("Se han eliminado " + contador + " registros");
		localStorage.clear();
	} else {

	}
}

//Actualizo el historial de partidas
function actualizarStorage() {
	location.reload();
}

//El tour guide web
function startIntro() {
	var intro = introJs();
	intro.setOptions({
		steps: [{
				intro: "Esto es muy sencillo, ya verás... "
			},
			{
				element: '#button16',
				intro: 'Abre un tablero de 4x4',
				position: 'left'
			},
			{
				element: '#button36',
				intro: "Abre un tablero de 6x6.",
				position: 'left'
			},
			{
				element: '#button64',
				intro: 'Abre un tablero de 8x8.',
				position: 'left'
			},
			{
				element: '#myBtn',
				intro: 'Muestra el top 5 de mejores puntuaciones.',
				position: 'right'
			},
			{
				element: '#actualizarButton',
				intro: 'Actualiza el historial de puntuaciones.',
				position: 'right'
			},
			{
				element: '#borrarButton',
				intro: 'Borra todas las puntuaciones existentes hasta el momento.',
				position: 'right'
			}
		]
	});
	intro.start();
}

//Máxima puntuación
function maxPuntuacion() {
	var puntuacion = document.getElementById("maxPuntos");
	var partidas = document.getElementById("numPartidas");
	var lista = [];

	//Recorro el localStorage, y guardo los objetos partida en una lista
	for (var i = 0; i < localStorage.length; i++) {
		var clave = localStorage.key(i);
		var valor = JSON.parse(localStorage.getItem(clave));
		lista[i] = valor;
	}

	//Ordena la lista de objetos de partidas, por la puntuación
	lista.sort(function (a, b) {
		if (a.pun > b.pun) {
			return -1;
		}
		if (a.pun < b.pun) {
			return 1;
		}
		if (a.pun == b.pun) {
			if (a.tiem < b.tiem) {
				return -1;
			}
			if (a.tiem > b.tiem) {
				return 1;
			}
		}
		return 0;
	});

	//Añado la máxima puntuación, que viene a ser la puntuación del primer elemento puntos de la lista de partidas ordenadas
	puntuacion.innerHTML = lista[0].pun;
	//Añado el número de partidas jugadas gracias al localstorage
	partidas.innerHTML = lista.length;
}