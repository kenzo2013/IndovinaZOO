function submitForm(parametro)
{
  var f = document.getElementById("form_gioca");
  
  if (parametro == "s")
	 f = document.getElementById("form_settings");
  else if (parametro == "g")
	f = document.getElementById("form_gioca");
  
  if("indexedDB" in window) 
  {
	f.submit();
  } else 
  {
	var div = document.getElementById("mostra_gioco");
	div.style.display = "none";
	div = document.getElementById("cambio_browser");
	div.style.display = "block";
  }
}