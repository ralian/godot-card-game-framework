# Code for a sample deck, you're expected to provide your own ;)
extends Pile

signal draw_card(deck)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not cfc.are_all_nodes_mapped:
		# Future self: Based off everything I've learned about 4.0, the below
		# line should work (if instead of while above.) However, it seems
		# when the scene is this fresh, godot 4 doesn't like awaiting a
		# ToSignal call, even though it's a static function. Cursed.
		# await Node.ToSignal(cfc, "all_nodes_mapped")
		cfc.connect("all_nodes_mapped", Callable(self, "_on_nodes_mapped"))
	else: _on_nodes_mapped()

func _on_nodes_mapped():
	# warning-ignore:return_value_discarded
	$Control.connect("gui_input", Callable(self, "_on_Deck_input_event"))
	# warning-ignore:return_value_discarded
	connect("draw_card", Callable(cfc.NMAP.hand, "draw_card"))
	#print(get_signal_connection_list("input_event")[0]['target'].name)

func _on_Deck_input_event(event) -> void:
	if event.is_pressed()\
		and not cfc.game_paused\
		and event.get_button_index() == 1:
		emit_signal("draw_card", self)
