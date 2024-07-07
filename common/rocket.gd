extends RigidBody3D

var bombTime = 20

var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0

var landing_site = Global.landing_site
var launch_site = Global.launch_site
var rocket_position = Global.rocket_position
var rocket_speed = Global.rocket_velocity
var turret_can_fire = Global.turret_fire

@onready var twist_pivot := $TwistPvot
@onready var pitch_pivot = $TwistPvot/PitchPivot

@onready var fire = $Fire
@onready var kaboom_1 = $Kaboom1
@onready var smoke = $Smoke



# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Feelers.disabled = true
	Global.flying = false

	
	await get_tree().create_timer(3.0).timeout
	# below is just a sample autonomous mode launch
	#explode()
	#apply_central_force(Vector3.UP * 80.0  * bombTime)
	#await get_tree().create_timer(4.95).timeout
	#explode()
	#apply_central_force(Vector3.UP * 60.0  * bombTime)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	check_input()	# checking for rotating the tank turret
	#check_kablooey()
	# handling bomb drops keys
	if Input.is_action_just_pressed("bomb1"):
		explode()
		apply_central_force(Vector3.UP * 800.0 * delta * bombTime)
	if Input.is_action_just_pressed("bomb2"):
		explode()
		apply_central_force(Vector3.UP * 2000.0 * delta * bombTime)
	if Input.is_action_just_pressed("bomb3"):
		explode()
		apply_central_force(Vector3.UP * 8000.0 * delta * bombTime)
	if Input.is_action_just_pressed("turret_can_fire"):		# the "t" key6
		turret_can_fire = !turret_can_fire
		$Feelers.disabled = !$Feelers.disabled
		Global.flying = !Global.flying
	
	if (Input.is_action_just_pressed("rocket_launch")):
		print("l key pressed")
		if(abs(rocket_position.x) >=1 || abs(rocket_position.z) >= 1):
			kablooey()
		else:
			explode()
			apply_central_force(Vector3.UP * 80.0  * 20)
		#await get_tree().create_timer(1.95).timeout
		Global.flying = true
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	# handling parameter labels
	var my_velocity = linear_velocity
	$my_speed.text = str(round(my_velocity))
	rocket_position = position
	var my_distL = (rocket_position - Global.landing_site).length()
	$my_height.text = str(round(rocket_position))
	$my_distL.text = str(round(my_distL))
	$my_roll.text = str(round(Global.heading))
	$land_location.text = str(round(Global.landing_site))
	$my_bombs.text = str(round(Global.bombs))
	$power_node_location.text = str(round(Global.power_node_position))
	
	#if(rocket_position.distance_to(Global.landing_site)<=1.0):
		#await get_tree().create_timer(1.0).timeout
		#get_tree().change_scene_to_file("res://common/safe_landing.tscn")
	
	#if(rocket_position.y < 0):
		#kablooey()
		
	 #handling height of tank when turret can fire
	#if turret_can_fire:
		#if rocket_position.y > 2:
			#explode()
		#else:
			#kablooey()
		
	# handling tank fwd/back and lef/right
	var input = Vector3.ZERO
	input.x = Input.get_axis("roll_left", "roll_right")		#variable names are messed up, l/r & f/b
	input.z = Input.get_axis("pitch_down", "pitch_up")
	apply_central_force(basis* input*1200.0 * delta)
	
	# handling camera pitch and roll
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(
		pitch_pivot.rotation.x, -0.5, 0.9 )
	twist_input = 0.0
	pitch_input = 0.0

func	explode():
	fire.emitting = true
	$Fire3.emitting = true
	kaboom_1.play(true)
	smoke.emitting = true
	Global.bombs -=  1
	if (Global.bombs <= 0):
		kablooey()
	return true
	
func kablooey():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://common/crashed.tscn")
	
# handling movemenet of mouse camera 
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity 

func check_input():
	if Input.is_action_pressed("ui_left"):
		$turret.rotate_y(deg_to_rad(.3))
		Global.heading = $turret.get_rotation_degrees().y
	elif Input.is_action_pressed("ui_right"):
		$turret.rotate_y(deg_to_rad(-.3))
		Global.heading = $turret.get_rotation_degrees().y

func check_kablooey():
	if (position.y < 2 && explode()):
		kablooey()
