
var root
var control_nodes

var play_button
var close_button
var close_button_label
var demo_button
var quit_button
var online_button

var main_menu_animations
var settings_animations
var main_menu
var settings

var settings_new
var settings_gfx
var settings_sound
var settings_game
 
var menu_button
var settings_button
var campaign_button

var label_completed
var label_wins
var label_maps_created
var label_version

var maps_sub_menu = preload("res://gui/menu_maps.xscn").instance()
var maps_sub_menu_anchor
var maps_close_button
var workshop_button
var workshop

var overscan_group
var language_group

var sound_toggle_button
var music_toggle_button
var shake_toggle_button
var camera_follow_button
var camera_zoom_in_button
var camera_zoom_out_button
var resolution_button
var difficulty_button
var overscan_toggle_button
var language_cycle_button
var gamepad_info
var gamepad_info_button
var tooltips_button

var sound_toggle_label
var music_toggle_label
var shake_toggle_label
var camera_follow_label
var camera_zoom_label
var resolution_label
var difficulty_label
var overscan_toggle_label
var language_cycle_label

var background_map
var root_tree
var background_gradient

func _ready():
    self.control_nodes = [self.get_node("top"),self.get_node("middle"),self.get_node("bottom")]

    workshop_button = get_node("bottom/center/workshop")
    if !Globals.get('tof/enable_workshop'):
        workshop_button.hide()

    campaign_button = get_node("bottom/center/start_campaign")
    self.background_gradient = self.get_node('vigette/center/sprite')

    play_button = get_node("bottom/center/play")
    close_button = get_node("top/center/close")
    quit_button = get_node("top/center/quit")
    demo_button = get_node("top/center/demo")
    online_button = get_node("bottom/center/online")

    if not Globals.get('tof/online'):
        online_button.hide()

    close_button_label = close_button.get_node('Label')

    main_menu = get_node("middle/center/game_panel")
    settings = get_node("middle/center/settings_panel")
    settings_new = get_node("middle/center/settings_panel2")
    settings_gfx = settings_new.get_node("body/tabs/game/")
    settings_sound = settings_new.get_node("body/tabs/game/")
    settings_game = settings_new.get_node("body/tabs/game/")

    main_menu_animations = get_node("middle/center/menu_anim")
    settings_animations = get_node("middle/center/settings_anim")

    settings_button = get_node("top/center/settings")
    overscan_group = settings.get_node("overscan_group")
    language_group = settings.get_node("language_group")

    sound_toggle_button = settings.get_node("sound_toggle")
    music_toggle_button = settings.get_node("music_toggle")
    shake_toggle_button = settings.get_node("shake_toggle")
    camera_follow_button = settings.get_node("camera_follow")
    camera_zoom_in_button = settings.get_node("camera_zoom_in")
    camera_zoom_out_button = settings.get_node("camera_zoom_out")
    resolution_button = settings.get_node("display_mode_toggle")

    self.difficulty_button = settings_game.get_node("difficulty/buttons/center/first")
    self.tooltips_button = settings_game.get_node("tooltips/buttons/center/first")
    self.language_cycle_button = settings_game.get_node('language/buttons/center/first')

    overscan_toggle_button = overscan_group.get_node('overscan_button')
    self.gamepad_info = settings.get_node('gamepad_info')
    self.gamepad_info_button = gamepad_info.get_node('gamepad_info_button')

    sound_toggle_label = sound_toggle_button.get_node("Label")
    music_toggle_label = music_toggle_button.get_node("Label")
    shake_toggle_label = shake_toggle_button.get_node("Label")
    camera_follow_label = camera_follow_button.get_node("Label")
    camera_zoom_label = settings.get_node("camera_zoom_level")
    resolution_label = resolution_button.get_node("Label")
    difficulty_label = difficulty_button
    overscan_toggle_label = overscan_toggle_button.get_node('Label')
    language_cycle_label = language_cycle_button

    campaign_button.connect("pressed", self, "_campaign_button_pressed")
    workshop_button.connect("pressed", self, "_workshop_button_pressed")
    play_button.connect("pressed", self, "_play_button_pressed")
    online_button.connect("pressed", self, "_online_button_pressed")

    sound_toggle_button.connect("pressed", self, "_toggle_sound_button_pressed")
    music_toggle_button.connect("pressed", self, "_toggle_music_button_pressed")
    shake_toggle_button.connect("pressed", self, "_toggle_shake_button_pressed")
    camera_follow_button.connect("pressed", self, "_toggle_follow_button_pressed")
    camera_zoom_in_button.connect("pressed", self, "_camera_zoom_in_button_pressed")
    camera_zoom_out_button.connect("pressed", self, "_camera_zoom_out_button_pressed")
    resolution_button.connect("pressed", self, "_resolution_button_pressed")
    difficulty_button.connect("pressed", self, "_difficulty_button_pressed")
    overscan_toggle_button.connect("pressed", self, "_overscan_toggle_button_pressed")
    language_cycle_button.connect("pressed", self, "_language_cycle_button_pressed")
    self.gamepad_info_button.connect("pressed", self.root.bag.gamepad_popup, "show")
    if self.root.is_pandora:
        self.gamepad_info.hide()
        self.gamepad_info_button.set_disabled(true)
        self.gamepad_info_button.get_node('Label').hide()

    close_button.connect("pressed", self, "_close_button_pressed")
    quit_button.connect("pressed", self, "_quit_button_pressed")
    settings_button.connect("pressed", self, "_settings_button_pressed")
    demo_button.connect("pressed", self, "_demo_button_pressed")

    self.label_completed = self.get_node("bottom/center/completed")
    self.label_maps_created = self.get_node("bottom/center/maps_created")
    self.label_version = self.get_node("middle/center/game_panel/under_logo/copy")

    self.refresh_buttons_labels()
    self.load_maps_menu()
    self.load_workshop()

    self.update_progress_labels()
    self.update_version_label()
    self.update_zoom_label()
    self.load_background_map()
    self.toggle_main_menu()

func _campaign_button_pressed():
    self.root.sound_controller.play('menu')
    self.show_campaign_menu()
func _workshop_button_pressed():
    self.root.sound_controller.play('menu')
    self.enter_workshop()
func _play_button_pressed():
    self.root.sound_controller.play('menu')
    self.show_maps_menu()
func _toggle_sound_button_pressed():
    self.toggle_sound()
    self.root.sound_controller.play('menu')
func _toggle_music_button_pressed():
    self.root.sound_controller.play('menu')
    self.toggle_music()
func _toggle_shake_button_pressed():
    self.root.sound_controller.play('menu')
    self.toggle_shake()
func _toggle_follow_button_pressed():
    self.root.sound_controller.play('menu')
    self.toggle_follow()
func _camera_zoom_in_button_pressed():
    self.root.sound_controller.play('menu')
    self.root.bag.camera.camera_zoom_in()
func _camera_zoom_out_button_pressed():
    self.root.sound_controller.play('menu')
    self.root.bag.camera.camera_zoom_out()
func _overscan_toggle_button_pressed():
    self.root.sound_controller.play('menu')
    self.root.settings['is_overscan'] = not self.root.settings['is_overscan']
    self.refresh_buttons_labels()
func _language_cycle_button_pressed():
    self.root.sound_controller.play('menu')
    self.root.bag.language.switch_to_next_language()
    self.refresh_buttons_labels()
func _close_button_pressed():
    self.root.sound_controller.play('menu')
    if not self.root.is_map_loaded && self.root.bag.saving != null:
        self.root.bag.saving.load_state()
    self.root.toggle_menu()
func _quit_button_pressed():
    self.root.sound_controller.play('menu')
    self.quit_game()
func _menu_button_pressed():
    self.root.sound_controller.play('menu')
    self.toggle_main_menu()
func _settings_button_pressed():
    self.root.sound_controller.play('menu')
    self.toggle_settings()
func _demo_button_pressed():
    self.root.sound_controller.play('menu')
    self.start_demo_mode()
func _maps_close_button_pressed():
    self.root.sound_controller.play('menu')
    self.hide_maps_menu()
    self.play_button.grab_focus()
func _resolution_button_pressed():
    self.root.sound_controller.play('menu')
    self.root.bag.resolution.toggle_resolution()
    self.refresh_buttons_labels()
func _difficulty_button_pressed():
    self.root.sound_controller.play('menu')
    self.root.settings['easy_mode'] = not self.root.settings['easy_mode']
    self.refresh_buttons_labels()
    self.root.write_settings_to_file()
func _online_button_pressed():
    self.root.sound_controller.play('menu')
    self.show_online_menu()


func show_online_menu():
    self.root.bag.controllers.online_menu_controller.show()
    self.hide_control_nodes()
    if self.root.settings['online_player_id'] != null:
        self.root.bag.controllers.online_menu_controller.multiplayer.refresh_button.grab_focus()

func start_demo_mode():
    self.root.bag.demo_mode.start_demo_mode(false)

func load_maps_menu():
    maps_sub_menu.hide()
    self.add_child(maps_sub_menu)

    maps_sub_menu_anchor = maps_sub_menu.get_node("middle")
    maps_close_button = maps_sub_menu.get_node("bottom/control/menu_controls/close")

    maps_close_button.connect("pressed", self, "_maps_close_button_pressed")

func show_campaign_menu():
    self.root.bag.controllers.campaign_menu_controller.show_campaign_menu()
    self.hide_control_nodes()
    self.root.bag.controllers.campaign_menu_controller.start_button.grab_focus()

func show_maps_menu():
    self.hide_control_nodes()
    self.root.bag.map_picker.attach_panel(self.maps_sub_menu_anchor)
    self.root.bag.map_picker.connect(self, "switch_to_skirmish_setup_panel")
    self.root.bag.map_picker.lock_delete_mode_button()
    self.maps_sub_menu.show()
    if self.root.bag.map_picker.blocks_cache.size() > 0:
        self.root.bag.map_picker.blocks_cache[0].get_node("TextureButton").grab_focus()
    else:
        self.maps_close_button.grab_focus()

func switch_to_skirmish_setup_panel(selected_map_name, is_remote):
    self.root.bag.map_picker.detach_panel()
    self.root.bag.skirmish_setup.attach_panel(self.maps_sub_menu_anchor)
    self.root.bag.skirmish_setup.set_map_name(selected_map_name, selected_map_name, is_remote)
    self.root.bag.skirmish_setup.connect(self, "switch_to_map_selection_panel", "play_selected_skirmish_map")
    self.root.bag.skirmish_setup.play_button.grab_focus()

func switch_to_map_selection_panel():
    self.root.bag.map_picker.attach_panel(self.maps_sub_menu_anchor)
    self.root.bag.map_picker.connect(self, "switch_to_skirmish_setup_panel")
    self.root.bag.skirmish_setup.detach_panel()
    self.root.bag.map_picker.blocks_cache[0].get_node("TextureButton").grab_focus()

func play_selected_skirmish_map(map_name, is_remote):
    self.load_map(map_name, true, is_remote)

func show_control_nodes():
    for nod in self.control_nodes:
        nod.show()

func hide_control_nodes():
    for nod in self.control_nodes:
        nod.hide()

func hide_maps_menu():
    self.show_control_nodes()
    maps_sub_menu.hide()
    self.root.bag.map_picker.detach_panel()
    self.root.bag.skirmish_setup.detach_panel()

# MAIN MENU
func get_main_menu_visibility():
    return self.main_menu.get_opacity() == 1

func toggle_main_menu():
    if self.get_main_menu_visibility():
        self.hide_main_menu()
    else:
        if self.get_settings_visibility():
            self.hide_settings()
        self.show_main_menu()

func show_main_menu(force = false):
    if force and self.get_settings_visibility():
        self.hide_settings()
    self.main_menu_animations.play('show_main_menu')

func hide_main_menu():
    self.main_menu_animations.play('hide_main_menu')

# SETTINGS
func get_settings_visibility():
    return settings.is_visible()

func toggle_settings():
    if self.get_settings_visibility():
        self.hide_settings()
        self.show_main_menu()
        self.settings_button.grab_focus()
    else:
        if self.get_main_menu_visibility():
            self.hide_main_menu()
        self.show_settings()
        # here we coudl back to the game (if user clicked settings in game)

func show_settings(force = false):
    if force and self.get_main_menu_visibility():
        self.hide_main_menu()
    self.refresh_buttons_labels()
    self.settings_animations.play('show_settings')

func hide_settings():
    self.settings_animations.play('hide_settings')

func manage_close_button():
    if not self.close_button:
        return
    if self.root.is_map_loaded:
        self.close_button.show()
        self.close_button_label.set_text('< ' + tr('LABEL_GAME'))
    elif self.root.bag.saving != null && self.root.bag.saving.is_save_available():
        self.close_button.show()
        self.close_button_label.set_text('< ' + tr('LABEL_RESUME'))
    else:
        self.close_button.hide()

# WORKSHOP TODO - create separate class for this
func load_workshop():
    self.workshop = self.root.bag.workshop

func enter_workshop():
    if Globals.get('tof/enable_workshop'):
        self.root.unload_map()
        self.root.bag.match_state.reset()
        self.workshop.is_working = true
        self.workshop.is_suspended = false
        self.show_workshop()

func show_workshop():
    if Globals.get('tof/enable_workshop'):
        self.hide()
        self.root.toggle_menu()
        self.workshop.show()
        self.workshop.units.raise()
        self.hide_background_map()
        self.workshop.camera.make_current()
        self.root.bag.controllers.workshop_gui_controller.navigation_panel.block_button.grab_focus()

func hide_workshop():
    if Globals.get('tof/enable_workshop'):
        self.workshop.hide()
        self.workshop.camera.clear_current()
        self.root.bag.camera.camera.make_current()
        self.show()
        if not self.root.is_map_loaded:
            self.show_background_map()
        self.workshop_button.grab_focus()

func load_map(name, from_workshop, is_remote = false):
    if from_workshop:
        root.load_map('workshop', name, false, is_remote)
    else:
        root.load_map(name, false)
    root.toggle_menu()
    self.hide_maps_menu()
    if Globals.get('tof/enable_workshop'):
        workshop.hide()
        workshop.is_working = false
        workshop.is_suspended = true

func resume_map():
    if self.root.bag.saving == null:
        return
    self.root.bag.saving.load_state()
    root.toggle_menu()
    self.hide_maps_menu()
    if Globals.get('tof/enable_workshop'):
        workshop.hide()
        workshop.is_working = false
        workshop.is_suspended = true

func toggle_sound():
    root.settings['sound_enabled'] = not root.settings['sound_enabled']
    self.refresh_buttons_labels()
    root.write_settings_to_file()

func toggle_music():
    root.settings['music_enabled'] = not root.settings['music_enabled']
    if root.settings['music_enabled']:
        root.sound_controller.play_soundtrack()
    else:
        root.sound_controller.stop_soundtrack()
    self.refresh_buttons_labels()
    root.write_settings_to_file()

func toggle_shake():
    root.settings['shake_enabled'] = not root.settings['shake_enabled']
    if root.settings['shake_enabled']:
        shake_toggle_label.set_text(tr('LABEL_ON'))
    else:
        shake_toggle_label.set_text(tr('LABEL_OFF'))
    root.write_settings_to_file()

func toggle_follow():
    root.settings['camera_follow'] = not root.settings['camera_follow']
    if root.settings['camera_follow']:
        camera_follow_label.set_text(tr('LABEL_ON'))
    else:
        camera_follow_label.set_text(tr('LABEL_OFF'))
    root.write_settings_to_file()

func refresh_buttons_labels():
    if root.settings['sound_enabled']:
        sound_toggle_label.set_text(tr('LABEL_ON'))
    else:
        sound_toggle_label.set_text(tr('LABEL_OFF'))
    if root.settings['music_enabled']:
        music_toggle_label.set_text(tr('LABEL_ON'))
    else:
        music_toggle_label.set_text(tr('LABEL_OFF'))
    if root.settings['shake_enabled']:
        shake_toggle_label.set_text(tr('LABEL_ON'))
    else:
        shake_toggle_label.set_text(tr('LABEL_OFF'))
    if root.settings['camera_follow']:
        camera_follow_label.set_text(tr('LABEL_ON'))
    else:
        camera_follow_label.set_text(tr('LABEL_OFF'))
    if root.settings['easy_mode']:
        difficulty_label.set_text(tr('LABEL_EASY'))
    else:
        difficulty_label.set_text(tr('LABEL_NORMAL'))
    if root.settings['is_overscan']:
        overscan_toggle_label.set_text(tr('LABEL_ON'))
    else:
        overscan_toggle_label.set_text(tr('LABEL_OFF'))

    language_cycle_label.set_text(self.root.settings['language'])

    if Globals.get('tof/hud_allow_overscan'):
        self.overscan_group.show()
    else:
        self.overscan_group.hide()

    if root.bag.resolution.override_resolution:
        self.resolution_button.set_disabled(false)
        self.resolution_label.show()
        if root.settings['resolution'] == root.bag.resolution.UNLOCKED:
            resolution_label.set_text(tr('LABEL_ON'))
        else:
            resolution_label.set_text(tr('LABEL_OFF'))
    else:
        self.resolution_button.set_disabled(true)
        self.resolution_label.hide()

func quit_game():
    OS.get_main_loop().quit()

func update_zoom_label():
    self.camera_zoom_label.set_text(str(self.root.camera.get_camera_zoom().x))

func update_progress_labels():
    self.update_custom_maps_count_label()
    self.update_campaign_progress_label()

func update_custom_maps_count_label():
    var maps_created = self.root.bag.map_list.maps.size()
    if self.label_maps_created != null:
        self.label_maps_created.set_text(tr('LABEL_MAPS_CREATED') + ': ' + str(maps_created))

func update_campaign_progress_label():
    var completed_maps = self.root.bag.campaign.get_completed_map_count()
    var total_maps = self.root.bag.campaign.maps.size()
    if self.label_completed != null:
        self.label_completed.set_text(tr('LABEL_COMPLETED') + ": " + str(completed_maps) + "/" + str(total_maps))

func update_version_label():
    self.label_version.set_text(self.root.version_name)

func init_root(root_node):
    root = root_node
    self.root_tree = self.root.get_tree()

func load_background_map():
    self.background_map = self.root.map_template.instance()
    self.background_map._init_bag(self.root.bag)
    self.background_map.is_dead = true
    self.background_map.switch_to_tileset(self.root.main_tileset)
    self.background_map.fill_map_from_data_array(self.root.bag.menu_background_map.map_data)
    self.background_map.show_blueprint = false
    self.background_map.get_node('fog_of_war').hide()
    self.root.scale_root.add_child(self.background_map)
    self.flush_group("units")
    self.flush_group("buildings")
    self.flush_group("terrain")
    self.update_background_scale()

func flush_group(name):
    var collection = self.root_tree.get_nodes_in_group(name)
    for entity in collection:
        entity.remove_from_group(name)

func show_background_map():
    if self.background_map != null:
        self.background_map.show()

func hide_background_map():
    if self.background_map != null:
        self.background_map.hide()

func update_background_scale():
    if self.background_map != null:
        self.background_map.scale = self.root.scale_root.get_scale()
        if not self.root.is_map_loaded:
            self.root.camera.set_pos(Vector2(-200, 500))

