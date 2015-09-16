function submitForm()
{
  /*Questa funzione controlla che non ci siano inconsistenze tra i parametri
   *inseriti dall'utente e lo stato del DB server, e se i dati inseriti sono
   *accettati allora fa il submit della form che porta al gioco vero e 
   *proprio.*/
  
  var form = document.getElementById("settings");
  var livello_massimo = gon.livello_alto;
  var numeroquiz = document.getElementById("numeroquiz").value;
  var livelloquiz = document.getElementById("livelloquiz").value;
  var timeout = document.getElementById("timeout").value;
  var livelli_numero = gon.quantita_quiz;
  var numero_quiz_db = gon.numero_quiz;
  
  if(timeout < 1)
  {
	document.getElementById("timeout").value = 5;
  }
  if(numeroquiz == 0)
  {
	alert("Impossibile una partita con 0 quiz."); 
	document.getElementById("numeroquiz").focus();
  } else if (livelloquiz == 0)
  {
	if (numeroquiz > numero_quiz_db || numeroquiz < 0)
	{
	  alert("Ci dispiace, ma al momento non abbiamo quella quantità di quiz disponibile.");
	  document.getElementById("numeroquiz").focus();
	} else
	{
	  form.submit();
	}
  } else if (livelli_numero[livelloquiz] < numeroquiz)
  {
	alert("Ci dispiace, ma al momento non abbiamo un numero di quiz disponibili con quel livello.");
	document.getElementById("numeroquiz").focus();
  } else if (livelloquiz > livello_massimo || livelloquiz < 0)
  {
	alert("Ci dispiace, ma al momento non abbiamo quiz di quel livello.");
	document.getElementById("livelloquiz").focus();
  } else
  {
	form.submit();
  }
}