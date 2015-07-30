
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"
var screen_size
var pad_size
var pad_height
func _ready():
	# Initalization here
	screen_size = get_viewport_rect().size
	pad_size = get_node("left").get_texture().get_size()
	pad_height = get_node("left").get_texture().get_height()
	get_node("ball").get_pos() = screen_size*0.5 #ball goes to screen center
	set_process(true)
#score variables
var scoreLeft = 0
var scoreRight = 0
#difficulty multiplier
var difficultyMult = 1
#speed of the ball (in pixels/second)
var ball_speed = 100

#direction of the ball (normal vector)
var direction = Vector2(-1,0)

#constant for pad speed (also in pixels/second)
const PAD_SPEED = 150

func _process(delta):
	var ball_pos = get_node("ball").get_pos()
	var left_rect = Rect2( get_node("left").get_pos() - pad_size/2, pad_size )
	var right_rect = Rect2( get_node("right").get_pos() - pad_size/2, pad_size )
	ball_pos+=direction*ball_speed*delta
	#Checking for upper or lower wall collision with ball 
	if ( (ball_pos.y<0 and direction.y <0) or (ball_pos.y>screen_size.y and direction.y>0)):
		direction.y = -direction.y
	if ( (left_rect.has_point(ball_pos) and direction.x < 0) or (right_rect.has_point(ball_pos) and direction.x > 0)):
		direction.x=-direction.x
		ball_speed*=1.1
		direction.y=randf()*2.0-1
		direction = direction.normalized()
		##Checking for Score
	if (ball_pos.x<0 or ball_pos.x>screen_size.x):
		if (ball_pos.x<0):                                      ## Right Scores
			scoreRight += 1
			get_node("scoreRight").set_text(str(scoreRight))
		elif (ball_pos.x>screen_size.x):                        ## Left Scores
			scoreLeft += 1
			get_node("scoreLeft").set_text(str(scoreLeft))
		ball_pos=screen_size*0.5 #ball goes to screen center
		ball_speed=80*difficultyMult
		direction=Vector2(-1,0)
	get_node("ball").set_pos(ball_pos)
    #move left pad  
	var left_pos = get_node("left").get_pos()

	if (left_pos.y > 0 + pad_height/2 and Input.is_action_pressed("left_move_up")):
		left_pos.y+=-PAD_SPEED*delta
	if (left_pos.y < screen_size.y - pad_height/2 and Input.is_action_pressed("left_move_down")):
		left_pos.y+=PAD_SPEED*delta

	get_node("left").set_pos(left_pos)

    #move right pad 
	var right_pos = get_node("right").get_pos()

	if (right_pos.y > 0 + pad_height/2 and Input.is_action_pressed("right_move_up")):
		right_pos.y+=-PAD_SPEED*delta
	if (right_pos.y < screen_size.y - pad_height/2 and Input.is_action_pressed("right_move_down")):
		right_pos.y+=PAD_SPEED*delta

	get_node("right").set_pos(right_pos)