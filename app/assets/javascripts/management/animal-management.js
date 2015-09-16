/* Delegato JQuery per la gestione del click sul pulsante 'Nuovo Animale'. */

$(document).delegate('#new_animal_link, .edit-animal', 'ajax:success', function(e, data, status, xhr) {
	var $this = $(this),		
		$responseText = $(xhr.responseText),
		$cancelButton = $responseText.find('#cancel_button');
		
	if ($('#animal_form_container').length)
		$container = $('#animal_form_container');
		
	if ($('#new_animal_links').length)
		$container = $('#new_animal_links');
		
	$container.replaceWith($responseText)
	$cancelButton.click(function(e) {
		$('#animal_form_container').replaceWith($container);
		$('#animalform_error_messages').empty();
		e.preventDefault();
	});
});

