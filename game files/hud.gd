extends CanvasLayer

signal guess(letter)
signal newGameSignal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_player_input_text_change_rejected(rejected_substring: String) -> void:
	$Input/PlayerInput.text = rejected_substring


func _on_player_input_text_submitted(letter: String) -> void:
	guess.emit(letter)

func addWrongGuess(newGuess: String):
	$Guesses/WrongGuesses.text = $Guesses/WrongGuesses.text + newGuess

func wrongGuessContainsLetter(letter: String) -> bool:
	return $Guesses/WrongGuesses.text.contains(letter)
	
func setCorrectGuess(newGuess: String):
	$Guesses/CorrectGuesses.text = newGuess
	
func newGame():
	$Input/PlayerInput.clear()
	$Guesses/CorrectGuesses.text = ""
	$Guesses/WrongGuesses.text = ""
	$Input/PlayerInput.grab_focus()

func _on_message_timer_timeout() -> void:
	$Message.hide()
	$Message.add_theme_color_override("font_color", Color.BLACK)
	
func displayMessage(message: String, color: Color):
	$Message.add_theme_color_override("font_color", color)
	$Message.text = message
	$Message.show()
	$MessageTimer.start()

func _on_new_game_button_pressed() -> void:
	newGameSignal.emit()
