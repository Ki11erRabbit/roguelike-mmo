extends Node2D

@onready
var forward_body = $ForwardFacing
@onready
var forward_skeleton = $ForwardFacing/Skeleton2D
@onready
var backward_body = $BackwardFacing
@onready
var backward_skeleton = $BackwardFacing/Skeleton2D

# The direction is based on the body
enum BendDirection {RightToLeft, LeftToRight}
# Which arm to touch
enum Arm { Right, Left, Both }

# The physical direction the character is facing
enum FacingDirection {Down, Up, Left, Right, DownLeft, DownRight, UpLeft, UpRight, LastDirection}
var current_facing_direction: FacingDirection = FacingDirection.Down

func set_current_facing_direction(direction: FacingDirection):
	var last_direction = current_facing_direction
	# We first set all bodies to be not visible
	forward_body.visible = false
	backward_body.visible = false
	current_facing_direction = direction
	# Then we enable the right body in the match
	match current_facing_direction:
		FacingDirection.LastDirection:
			set_current_facing_direction(last_direction)
		FacingDirection.Down:
			forward_body.visible = true
		FacingDirection.Up:
			backward_body.visible = true
			
			
	

func set_bend_direction(direction: BendDirection, arm: Arm):
	match current_facing_direction:
		FacingDirection.Down:
			match direction:
				BendDirection.RightToLeft:
					match arm:
						Arm.Right:
							forward_skeleton.get_modification_stack().modifications[0].flip_bend_direction = true
						Arm.Left:
							forward_skeleton.get_modification_stack().modifications[1].flip_bend_direction = true
						Arm.Both:
							forward_skeleton.get_modification_stack().modifications[0].flip_bend_direction = true
							forward_skeleton.get_modification_stack().modifications[1].flip_bend_direction = true
				BendDirection.LeftToRight:
					match arm:
						Arm.Right:
							forward_skeleton.get_modification_stack().modifications[0].flip_bend_direction = false
						Arm.Left:
							forward_skeleton.get_modification_stack().modifications[1].flip_bend_direction = false
						Arm.Both:
							forward_skeleton.get_modification_stack().modifications[0].flip_bend_direction = false
							forward_skeleton.get_modification_stack().modifications[1].flip_bend_direction = false
		FacingDirection.Up:
			match direction:
				BendDirection.RightToLeft:
					match arm:
						Arm.Right:
							forward_skeleton.get_modification_stack().modifications[0].flip_bend_direction = false
						Arm.Left:
							forward_skeleton.get_modification_stack().modifications[1].flip_bend_direction = false
						Arm.Both:
							forward_skeleton.get_modification_stack().modifications[0].flip_bend_direction = false
							forward_skeleton.get_modification_stack().modifications[1].flip_bend_direction = false
				BendDirection.LeftToRight:
					match arm:
						Arm.Right:
							forward_skeleton.get_modification_stack().modifications[0].flip_bend_direction = true
						Arm.Left:
							forward_skeleton.get_modification_stack().modifications[1].flip_bend_direction = true
						Arm.Both:
							forward_skeleton.get_modification_stack().modifications[0].flip_bend_direction = true
							forward_skeleton.get_modification_stack().modifications[1].flip_bend_direction = true

func replace_texture_atlas(atlas: AtlasTexture):
	$ForwardFacing/Head.texture.atlas = atlas
	$ForwardFacing/Torso.texture.atlas = atlas
	$ForwardFacing/Arms/RightArm.texture.atlas = atlas
	$ForwardFacing/Arms/RightArm/RightForearm.texture.atlas = atlas
	$ForwardFacing/Arms/RightArm/RightForearm/RightForearmBody/RightHandBody/RightHand.texture.atlas = atlas
	$ForwardFacing/Arms/LeftArm.texture.atlas = atlas
	$ForwardFacing/Arms/LeftArm/LeftForearm.texture.atlas = atlas
	$ForwardFacing/Arms/LeftArm/LeftForearm/LeftForearmBody/LeftHandBody/LeftHand.texture.atlas = atlas
	$ForwardFacing/Legs/RightLeg/Thigh/Sprite2D.texture.atlas = atlas
	$ForwardFacing/Legs/RightLeg/Knee/Sprite2D.texture.atlas = atlas
	$ForwardFacing/Legs/RightLeg/LowerLeg/Sprite2D.texture.atlas = atlas
	$ForwardFacing/Legs/RightLeg/Foot/Sprite2D.texture.atlas = atlas
	$ForwardFacing/Legs/RightLeg/FootBottom/WholeBottom.texture.atlas = atlas
	$ForwardFacing/Legs/RightLeg/FootBottom/HalfBottom.texture.atlas = atlas
	$ForwardFacing/Legs/LeftLeg/Thigh/Sprite2D.texture.atlas = atlas
	$ForwardFacing/Legs/LeftLeg/Knee/Sprite2D.texture.atlas = atlas
	$ForwardFacing/Legs/LeftLeg/LowerLeg/Sprite2D.texture.atlas = atlas
	$ForwardFacing/Legs/LeftLeg/Foot/Sprite2D.texture.atlas = atlas
	$ForwardFacing/Legs/LeftLeg/FootBottom/WholeBottom.texture.atlas = atlas
	$ForwardFacing/Legs/LeftLeg/FootBottom/HalfBottom.texture.atlas = atlas
	
	
	$BackFacing/Head.texture.atlas = atlas
	$BackFacing/Torso.texture.atlas = atlas
	$ForwardFacing/Arms/RightArm.texture.atlas = atlas
	$ForwardFacing/Arms/RightArm/RightForearm.texture.atlas = atlas
	$ForwardFacing/Arms/RightArm/RightForearm/RightForearmBody/RightHandBody/RightHand.texture.atlas = atlas
	$ForwardFacing/Arms/LeftArm.texture.atlas = atlas
	$ForwardFacing/Arms/LeftArm/LeftForearm.texture.atlas = atlas
	$ForwardFacing/Arms/LeftArm/LeftForearm/LeftForearmBody/LeftHandBody/LeftHand.texture.atlas = atlas
	$ForwardFacing/Legs/RightLeg/Thigh/Sprite2D.texture.atlas = atlas
	$ForwardFacing/Legs/RightLeg/LowerLeg/Sprite2D.texture.atlas = atlas
	$ForwardFacing/Legs/RightLeg/Foot/Sprite2D.texture.atlas = atlas
	$ForwardFacing/Legs/RightLeg/FootBottom/WholeBottom.texture.atlas = atlas
	$ForwardFacing/Legs/RightLeg/FootBottom/HalfBottom.texture.atlas = atlas
	$ForwardFacing/Legs/LeftLeg/Thigh/Sprite2D.texture.atlas = atlas
	$ForwardFacing/Legs/LeftLeg/LowerLeg/Sprite2D.texture.atlas = atlas
	$ForwardFacing/Legs/LeftLeg/Foot/Sprite2D.texture.atlas = atlas
	$ForwardFacing/Legs/LeftLeg/FootBottom/WholeBottom.texture.atlas = atlas
	$ForwardFacing/Legs/LeftLeg/FootBottom/HalfBottom.texture.atlas = atlas


enum WalkingDirection {Forwards, Backwards}

func start_walking(direction: WalkingDirection):
	match current_facing_direction:
		FacingDirection.Down:
			match direction:
				WalkingDirection.Forwards:
					$ForwardFacing/Movement.play("walk")
				WalkingDirection.Backwards:
					$ForwardFacing/Movement.play("backstep")
		FacingDirection.Up:
			match direction:
				WalkingDirection.Forwards:
					$BackwardFacing/Movement.play("walk")
				WalkingDirection.Backwards:
					$BackwardFacing/Movement.play("backstep")

func start_running(direction: WalkingDirection):
	match current_facing_direction:
		FacingDirection.Down:
			match direction:
				WalkingDirection.Forwards:
					$ForwardFacing/Movement.play("walk", -1, 2.0)
				WalkingDirection.Backwards:
					$ForwardFacing/Movement.play("backstep", -1, 2.0)
		FacingDirection.Up:
			match direction:
				WalkingDirection.Forwards:
					$BackwardFacing/Movement.play("walk", -1, 2.0)
				WalkingDirection.Backwards:
					$BackwardFacing/Movement.play("backstep", -1, 2.0)

func stop_moving():
	match current_facing_direction:
		FacingDirection.Down:
			$ForwardFacing/Movement.play("RESET")
		FacingDirection.Up:
			$BackwardFacing/Movement.play("RESET")

func _ready() -> void:
	forward_body.visible = true
	backward_body.visible = false

func _physics_process(delta: float) -> void:
	pass


	
