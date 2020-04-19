var newUsuario = document.getElementById('UsuarioReg');
var newPass = document.getElementById('PassReg1');
var repPass = document.getElementById('repPass');

var usu = []
var agregar = document.getElementById('btnReg');

agregar.addEventListener('click', function agregar() {
    if (repPass.value != newPass.value ) {
        alert('La contraseñas no coinciden')
    }

    usu.push({
        'Usuario':newUsuario.value ,
        'Pass': newPass.value
    });

    localStorage.setItem('usuarios', JSON.stringify(usu));
})