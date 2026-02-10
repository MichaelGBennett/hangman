extends Node

var guessPhrase:String
var hiddedPhrase:String
var LASTFRAME:int = 5
var gameOver:bool = false
var phraseArray: Array[String]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	loadThePhrases()
	newGame()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_hud_guess(letter: Variant) -> void:
	if not gameOver:
		if not $HUD.wrongGuessContainsLetter(letter):
			if guessPhrase.to_lower().contains(letter.to_lower()):
				correctGuess(letter)
			else:
				wrongGuess(letter)

func newGame():
	$hangman.hide()
	$hangman.set_frame_and_progress(0,0)
	$HUD.newGame()
	
	guessPhrase = generateNewGuessPhrase()
	hiddedPhrase = ""
	for i in guessPhrase.length():
		if guessPhrase[i] == " ":
			hiddedPhrase += " "
		else:
			hiddedPhrase += "*"
		
	$HUD.setCorrectGuess(hiddedPhrase)
	gameOver = false
	
func generateNewGuessPhrase():
	return phraseArray.pick_random()
	
func wrongGuess(letter: String):
	$HUD.addWrongGuess(letter)
	
	if not $hangman.visible:
		$hangman.show()
		$HUD.displayMessage("Incorrect", Color.RED)
	else:
		$hangman.set_frame_and_progress($hangman.frame + 1,0)
		if $hangman.frame == LASTFRAME:
			$HUD.displayMessage("Game Over", Color.RED)
			$HUD.setCorrectGuess(guessPhrase)
			gameOver = true
	
	
func correctGuess(letter: String):
	for i in guessPhrase.length():
		if guessPhrase[i].to_lower() == letter.to_lower():
			hiddedPhrase[i] = guessPhrase[i]
	$HUD.setCorrectGuess(hiddedPhrase)
	$HUD.displayMessage("Correct!", Color.GREEN)
	
	if not hiddedPhrase.contains("*"):
		gameWin()
		
func gameWin():
	$HUD.displayMessage("You Win!", Color.GREEN)
	gameOver = true

func loadThePhrases():
	var file = FileAccess.open("assets/SecretPhrases.txt", FileAccess.READ)
	while not file.eof_reached():
		phraseArray.push_back(file.get_line())
