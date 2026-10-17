extends Node

@export var mob_scene: PackedScene
@export var strong_mob_scene: PackedScene
var score
var mob

func _ready():
	#new_game()
	pass

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	$Player.hide()
	$Player.set_process(false)
	$Player.set_deferred("monitoring", false)
	
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	lives = 3
	$HUD.update_lives(lives)
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	$Music.play()

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	if randf() < 0.25:
		mob = strong_mob_scene.instantiate()
	else:
		mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)



var lives = 3

func _on_player_hit(damage):
	lives -= damage
	$HUD.update_lives(lives)

	if lives <= 0:
		game_over()
		
