var empezar = $('#botonPlay');
var juego = $('.juego');

function coordenadas(event) {
    x=event.clientX;
    y=event.clientY;
    
   }
empezar.on('click', function(){
    juego.empty();
    juego.css("background-image", "url(img/fondo2.jpg)");
    juego.append('<img src="img/Pistola.png" id="pistola">');
    pistola=$('#pistola');
    pistola.animate({
        left: x,
        top: y,
    });
 });
juego.on('mousemove',function(){

})


     