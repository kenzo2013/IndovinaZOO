/* Inizializzazione header messaggi per utilizzo di Ajax*/

$.ajaxSetup({
	'beforeSend': function (xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
});
