var quizzes = [];

/*Apro una connessione a indexedDB e carico nell'array quizzes tutti i quiz della partita*/
$(document).ready ( function ()
{
  var openrequest = indexedDB.open("game");
  console.log("db aperto");

  openrequest.onsuccess = function(event) 
  {
	console.log("entrato onsuccess");
	var db = event.target.result;
	var objectStore = db.transaction("quizzes").objectStore("quizzes");

	quizzes = [];

	var cursorRequest = objectStore.openCursor();
	cursorRequest.onsuccess = function(event) 
	{
	  console.log("entrato onsuccess");
	  var cursor = event.target.result;
	  if (cursor) 
	  {
		quizzes.push(cursor.value);
		cursor.continue();
	  } else 
	  {
		console.log("scaricati tutti i quiz");
		insertQuizzesToHTML();
		db.close();
		console.log("chiuso DB");
		console.log("uscito onsuccess");
	  }
	}
  }
});

/*inserisce nell'HTML il div creato da quizResult_create.*/
function add_quizResult (textQuiz, animal1, animal2, score, solution, response)
{
  var quizContainer = document.getElementById('result_summary');
  quizContainer.appendChild(quizResult_create(textQuiz, animal1, animal2, score, solution, response));
}

/*inserisce sul sommario dei risultati le immagini degli animali e il punteggio in appositi tag.*/
function quizResult_create(textQuiz, animal1, animal2, score, solution, response) 
{
  var quizRes = document.createElement('div');
  quizRes.className = "quiz_result";

  quizRes.appendChild(p_create_title(textQuiz));
  quizRes.appendChild(img_create(animal1, solution, response));
  quizRes.appendChild(img_create(animal2, solution, response));
  quizRes.appendChild(p_create_score("Punteggio: "+score));
  return quizRes;
}

/*crea un tag p che contiene il punteggio.*/
function p_create_score(text)
{
  var p_score = p_create(text);
  p_score.className = p_score.className +" score-res";
  return p_score;
}

/*crea un tag p che contiene il numero del quiz.*/
function p_create_title(text)
{
  var p_title = p_create(text);
  p_title.className = p_title.className +" title-res";
  return p_title;
}

/*crea un tag p con all'interno il testo passato come parametro.*/
function p_create(text) 
{
  var p = document.createElement('p');
  p.textContent = text;
  return p;
}

/*crea un tag img con gli attributi alt e title.*/
function img_create(src, sol, resp) 
{
  var img = document.createElement('img');
  img.src = src;
  var animal = getAnimalName(src);
  console.log("DEBUG: animal: "+animal);
  img.alt = animal;
  img.title = animal;
  img.className = img.className+" img-rounded";

  sol = getAnimalName(sol);
  resp = getAnimalName(resp);
  console.log("DEBUG animal: "+animal+" | sol: "+sol+" | resp: "+resp+" |");
  if (animal == resp)
  {
	if (animal == sol)
	  img.className = img.className+" resp-true";
	else
	  img.className = img.className+" resp-false";
  } 
  else 
	img.className = img.className+" no-resp";
  return img;
}

/*ritorna il nome dell'animale dal path passato come parametro.*/
function getAnimalName (fullPath) 
{
  filename = fullPath.replace(/^.*[\\\/]/, '');
  name = filename.split(".")[0];
  return name.charAt(0).toUpperCase() + name.slice(1);
}

/*inserisce tutti i quiz presenti in quizzes.*/
function insertQuizzesToHTML() 
{
  var extContainer = document.createElement("div");
  for (i=0; i<quizzes.length; i++) {
	var testoQuiz = "Quiz "+(i+1)+"";
	add_quizResult(testoQuiz, quizzes[i].animal1, quizzes[i].animal2, quizzes[i].score, quizzes[i].solution, quizzes[i].user_response);
  }
  totalScore();
}

/*calcola il punteggio totale e lo inserisce nel div "change_total_score".*/
function totalScore()
{
  var res = 0;
  for (i=0; i<quizzes.length; i++) {
	res += quizzes[i].score;
  }
  insertHiddenScore(res);
  insertSocialText(res);
  if (res<0)
  {
	document.getElementById("save-rank").style.display = "none";
  }
  return document.getElementById("change_total_score").textContent = res;
}

/*inserisce il valore passato come parametro nel div hidden_score.*/
function insertHiddenScore(score) 
{
  document.getElementById("hidden_score").value = score;
}

/*mostra il form per il submit del punteggio sul db server.*/
function showForm() 
{
  document.getElementById("hidden_form").style.display = "block";
}

/*inserisce una frase con punteggio e consiglio di condivisione del gioco nei social network
 *[funziona solo su Twitter].*/
function insertSocialText(score) 
{
  var stringa = "Ho totalizzato "+score+" punti a IndovinaZOO! Giocaci anche tu su";
  document.getElementsByClassName("social-share-button")[0].setAttribute("data-title", stringa);
}