extends Node2D

var enemy = preload("res://enemy.tscn")
var score = 0
var playing = false
var level = 1

@onready var start_button = $CanvasLayer/CenterContainer/Start
@onready var game_over = $CanvasLayer/CenterContainer/GameOver

func _ready():
	game_over.hide()
	start_button.show()
	var tween = create_tween().set_loops().set_parallel(false).set_trans(Tween.TRANS_SINE)
	tween.tween_property($EnemyAnchor, "position:x", $EnemyAnchor.position.x + 3, 1.0)
	tween.tween_property($EnemyAnchor, "position:x", $EnemyAnchor.position.x - 3, 1.0)
	var tween2 = create_tween().set_loops().set_parallel(false).set_trans(Tween.TRANS_BACK)
	tween2.tween_property($EnemyAnchor, "position:y", $EnemyAnchor.position.y + 3, 1.5).set_ease(Tween.EASE_IN_OUT)
	tween2.tween_property($EnemyAnchor, "position:y", $EnemyAnchor.position.y - 3, 1.5).set_ease(Tween.EASE_IN_OUT)
#	spawn_enemies()	
	
func spawn_enemies(level):
	for x in range(9):
		for y in range(2+level):
			var e = enemy.instantiate()
			var pos = Vector2(x * (16 + 8) + 24, 16 * 4 + y * 16)
			add_child(e)
			e.start(pos)
			e.anchor = $EnemyAnchor
			e.died.connect(_on_enemy_died)

func _on_enemy_died(value):
	score += value
	$CanvasLayer/UI.update_score(score)
	$Camera2D.add_trauma(0.5)
	
func _process(_delta):
	if get_tree().get_nodes_in_group("enemies").size() == 0 and playing:
		spawn_enemies(level)
		level=level+1
	
func _on_player_died():
#	print("game over")
	var s
	var http_request = HTTPRequest.new()
	add_child(http_request)
	var r="https://www.delfosse-telecom.fr/g1/shmup.php?q="+str(score)
	s=http_request.request(r)
	playing = false
	level=1
	get_tree().call_group("enemies", "queue_free")
	game_over.show()
	await get_tree().create_timer(2).timeout
	game_over.hide()
	start_button.show()
	
func new_game():
	score = 0
	$CanvasLayer/UI.update_score(score)
	$Player.start()
	spawn_enemies(level)
	playing = true
	level=level+1

func _on_start_pressed():
	start_button.hide()
	new_game()