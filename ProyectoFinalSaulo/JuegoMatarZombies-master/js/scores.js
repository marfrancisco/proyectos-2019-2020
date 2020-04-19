//mirar si existe usuarios en localStorage
function Score() {
    var arUsuario = JSON.parse(localStorage.getItem('usuarios'));
    arUsuario.sort((a, b) => a.score > b.score);
    var div = document.getElementById('contenedorScore');
    div.innerHTML = '';
    if (arUsuario != null) {
        for (let i = 0, j = 0; i < arUsuario.length; i++) {
            //crear p con nombre y puntuacion
            if (arUsuario[i].score != 0) {
                var p = document.createElement('p');
                if (j == 0) {
                    p.innerHTML = '<img class="avScore primero" src="' + arUsuario[i].avatar + '"/>' + ' <b> ' + arUsuario[i].nombre + '</b> - Tiempo: <b>' + arUsuario[i].score + '</b>';
                } else if (j == 1) {
                    p.innerHTML = '<img class="avScore segundo" src="' + arUsuario[i].avatar + '"/>' + ' <b> ' + arUsuario[i].nombre + '</b> - Tiempo: <b>' + arUsuario[i].score + '</b>';

                } else if (j == 2) {
                    p.innerHTML = '<img class="avScore tercero" src="' + arUsuario[i].avatar + '"/>' + ' <b> ' + arUsuario[i].nombre + '</b> - Tiempo: <b>' + arUsuario[i].score + '</b>';

                } else {
                    p.innerHTML = '<img  src="' + arUsuario[i].avatar + '" class="avScore"/>' + ' <b> ' + arUsuario[i].nombre + '</b> - Tiempo: <b>' + arUsuario[i].score + '</b>';
                }
                div.appendChild(p);
                j++
            }
        }
    }
}

// si hay usuarios en localStorage

//mostrar en un bucle por posiciones el nombre y el score