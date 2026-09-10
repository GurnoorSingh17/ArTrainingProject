extends Node3D

@onready var start_xr_button: Button = $EnterAR
@export var UI:Control

# Our WebXR interface.
var xr_interface: WebXRInterface

# Is a WebXR is_session_supported query running
var webxr_session_query: bool = false

# Set this to true if we wish to have an AR session
var require_ar: bool = true

func _ready() -> void:
	UI.visible = false
	# Configure the WorldEnvironment for AR.
	var world_env = $WorldEnvironment
	if world_env:
		var env = world_env.environment
		# Set background mode to Color and make it transparent.
		env.background_mode = Environment.BG_COLOR
		env.background_color = Color(0, 0, 0, 0)

	# Connect the button to the function that starts AR.
	start_xr_button.pressed.connect(_on_enter_webxr_button_pressed)
	start_xr_button.visible = false # Hide until we know it's supported

	xr_interface = XRServer.find_interface("WebXR")
	if xr_interface:
		# Connect our signals
		xr_interface.session_supported.connect(_on_webxr_session_supported)
		xr_interface.session_started.connect(_on_webxr_session_started)
		xr_interface.session_ended.connect(_on_webxr_session_ended)
		xr_interface.session_failed.connect(_on_webxr_session_failed)
		
		webxr_session_query = true
		xr_interface.is_session_supported("immersive-ar" if require_ar else "immersive-vr")
	else:
		print("WebXR is not available")

# Handle the Enter AR button
func _on_enter_webxr_button_pressed() -> void:
	UI.visible = true
	# Configure the WebXR interface
	xr_interface.session_mode = "immersive-ar" if require_ar else "immersive-vr"
	xr_interface.requested_reference_space_types = "local"
	xr_interface.required_features = "local"
	xr_interface.optional_features = ""
	
	# Initialize the interface.
	if not xr_interface.initialize():
		OS.alert("Failed to initialize WebXR")

# Handle WebXR session supported check
func _on_webxr_session_supported(session_mode: String, supported: bool) -> void:
	if not webxr_session_query:
		return
	webxr_session_query = false
	
	if not supported:
		OS.alert("Your web browser doesn't support " + session_mode + ". Sorry!")
		return
	
	# WebXR supported - show the button to enter AR
	start_xr_button.visible = true

# Called when the WebXR session has started successfully
func _on_webxr_session_started() -> void:
	start_xr_button.visible = false
	get_viewport().transparent_bg = require_ar # Make the viewport transparent for AR
	get_viewport().use_xr = true

# Called when the user ends the immersive AR session
func _on_webxr_session_ended() -> void:
	start_xr_button.visible = true
	get_viewport().transparent_bg = false
	get_viewport().use_xr = false

# Called when the immersive AR session fails to start
func _on_webxr_session_failed(message: String) -> void:
	OS.alert("Unable to enter AR: " + message)


