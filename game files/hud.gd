extends CanvasLayer

signal guess(letter)
signal newGameSignal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_input_text_change_rejected(rejected_substring: String) -> void:
	$PlayerInput.text = rejected_substring


func _on_player_input_text_submitted(letter: String) -> void:
	guess.emit(letter)

func addWrongGuess(guess: String):
	$WrongGuesses.text = $WrongGuesses.text + guess

func wrongGuessContainsLetter(letter: String) -> bool:
	return $WrongGuesses.text.contains(letter)
	
func setCorrectGuess(guess: String):
	$CorrectGuesses.text = guess
	
func newGame():
	$PlayerInput.clear()
	$CorrectGuesses.text = ""
	$WrongGuesses.text = ""
	

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
