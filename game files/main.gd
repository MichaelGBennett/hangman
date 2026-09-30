extends Node

@export_file("*.txt") var phrasesFile

var guessPhrase:String
var hiddedPhrase:String
var LASTFRAME:int = 5
var gameOver:bool = false
var phraseArray: Array[String]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	loadThePhrases()
	newGame()
	

func _on_hud_guess(letter: Variant) -> void:
	if not gameOver:
		if not $Screen/HUD.wrongGuessContainsLetter(letter):
			if guessPhrase.to_lower().contains(letter.to_lower()):
				correctGuess(letter)
			else:
				wrongGuess(letter)

func newGame():
	$Screen/hangman.hide()
	$Screen/hangman.set_frame_and_progress(0,0)
	$Screen/HUD.newGame()
	
	guessPhrase = generateNewGuessPhrase()
	hiddedPhrase = ""
	for i in guessPhrase.length():
		if guessPhrase[i] == " ":
			hiddedPhrase += " "
		else:
			hiddedPhrase += "*"
		
	$Screen/HUD.setCorrectGuess(hiddedPhrase)
	gameOver = false
	
func generateNewGuessPhrase():
	return phraseArray.pick_random()
	
func wrongGuess(letter: String):
	$Screen/HUD.addWrongGuess(letter)
	
	if not $Screen/hangman.visible:
		$Screen/hangman.show()
		$Screen/HUD.displayMessage("Incorrect", Color.RED)
	else:
		$Screen/hangman.set_frame_and_progress($Screen/hangman.frame + 1,0)
		if $Screen/hangman.frame == LASTFRAME:
			$Screen/HUD.displayMessage("Game Over", Color.RED)
			$Screen/HUD.setCorrectGuess(guessPhrase)
			gameOver = true
	
	
func correctGuess(letter: String):
	for i in guessPhrase.length():
		if guessPhrase[i].to_lower() == letter.to_lower():
			hiddedPhrase[i] = guessPhrase[i]
	$Screen/HUD.setCorrectGuess(hiddedPhrase)
	$Screen/HUD.displayMessage("Correct!", Color.GREEN)
	
	if not hiddedPhrase.contains("*"):
		gameWin()
		
func gameWin():
	$Screen/HUD.displayMessage("You Win!", Color.GREEN)
	gameOver = true

func loadThePhrases():
	var file = FileAccess.open(phrasesFile, FileAccess.READ)
	while not file.eof_reached():
		phraseArray.push_back(file.get_line())
	phraseArray.pop_back()
