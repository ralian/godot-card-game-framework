# This contains information about one specific alteration requested by the card
# automation
class_name ScriptAlter
extends ScriptObject

# Stores the details arg passed the signal to use for filtering
var trigger_details : Dictionary
# If true if this task has been confirmed to run by the player
# Only relevant for optional tasks (see [SP].KEY_IS_OPTIONAL)
var is_accepted := true


# Prepares the script_definition needed by the alteration to function and
# checks the ongoing task and its owner_card against defined filters.
func _init(
		alteration_script: Dictionary,
		trigger_object: Card,
		alterant_object,
		task_details: Dictionary) -> void:
	super(alterant_object,
			alteration_script,
			trigger_object)
	# The alteration name gets its own var
	script_name = get_property("filter_task")
	trigger_details = task_details
	if not SP.filter_trigger(
			alteration_script,
			trigger_object,
			owner,
			trigger_details):
		is_valid = false
	if is_valid:
		var confirm_return = await CFUtils.confirm(
				script_definition,
				owner.canonical_name,
				script_name)
		is_valid = confirm_return
	if is_valid:
	# The script might require counting other cards.
		var ret = await _find_subjects([], 0)
	# We emit a signal when done so that our ScriptingEngine
	# knows we're ready to continue
	emit_signal("primed")
	is_primed = true
