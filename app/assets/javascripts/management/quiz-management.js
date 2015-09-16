/* Delegato JQuery per l'evento change della select del primo animal id
* nella form di creazione dei Quiz. */

$(document).delegate('#quiz_quiz_rows_attributes_0_animal_id', 'change', function(e) {
	e.preventDefault();
	var $select = $(this);
		
	$.post("/quizzes/set_animal_ids", {id: $select.val()}, null, "script");	
});

/* Delegato JQuery per intercettare il click sul tasto reset, presente nel form
* di creazione dei Quiz. */

$(document).delegate('#quizform_reset_button', 'click', function(e) {
	$('#quizform_error_messages').empty();
	$('#quiz_form:input').each(function(){
      $(this).val('');
    });
});

/* Delegato JQuery per la gestione del pulsante 'Nuovo Quiz'
* nella form di creazione dei Quiz. E' compresa la gestione del tasto Annulla. */

$(document).delegate('#new_quiz_link, .edit-quiz', 'ajax:success', function(e, data, status, xhr) {
	var $responseText = $(xhr.responseText),		
	    $cancelButton = $responseText.find('#cancel_button');
        
    if ($('#quiz_form_container').length)
		$container = $('#quiz_form_container');
		
	if ($('#new_quiz_links').length)
		$container = $('#new_quiz_links');
		
    $container.replaceWith($responseText);
    $cancelButton.click(function(e) {
        $('#quiz_form_container').replaceWith($container);
        $('#quizform_error_messages').empty();
        e.preventDefault();
    });
});
