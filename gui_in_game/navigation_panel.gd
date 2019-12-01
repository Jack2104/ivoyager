# navigation_panel.gd
# This file is part of I, Voyager
# https://ivoyager.dev
# Copyright (c) 2017-2019 Charlie Whitfield
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# *****************************************************************************
#
# We have a mix of procedural and hard-coded generation here. TODO: make this
# fully procedural (from data tables). That's going to be hard!

extends DraggablePanel
class_name NavigationPanel
const SCENE := "res://ivoyager/gui_in_game/navigation_panel.tscn"

const DDPRINT := false

var _asteroid_buttons := {}
var _points_manager: PointsManager
var _connected_camera: VoyagerCamera


func _on_ready() -> void:
	._on_ready()
	_points_manager = Global.objects.PointsManager
	_asteroid_buttons.all_asteroids = $BottomVBox/AstGroupBox/AllAsteroids
	_asteroid_buttons.NE = $BottomVBox/AstGroupBox/NearEarth
	_asteroid_buttons.MC = $BottomVBox/AstGroupBox/MarsCros
	_asteroid_buttons.MB = $BottomVBox/AstGroupBox/MainBelt
	_asteroid_buttons.JT4 = $BottomVBox/AstGroupBox/Trojans/L4
	_asteroid_buttons.JT5 = $BottomVBox/AstGroupBox/Trojans/L5
	_asteroid_buttons.CE = $BottomVBox/AstGroupBox/Centaurs
	_asteroid_buttons.TN = $BottomVBox/AstGroupBox/TransNeptune
	Global.connect("camera_ready", self, "_connect_camera")
	_connect_camera(get_viewport().get_camera())
	$CameraLock.toggle_mode = true
	$CameraLock.connect("toggled", self, "_toggle_camera_lock")
	$BottomVBox/BottomHBox/MainMenu.connect("pressed", Global, "emit_signal", ["open_main_menu_requested"])
	$BottomVBox/BottomHBox/Hotkeys.connect("pressed", Global, "emit_signal", ["hotkeys_requested"])
	for key in _asteroid_buttons:
		_asteroid_buttons[key].connect("toggled", self, "_select_asteroids", [key])
	_points_manager.connect("show_points_changed", self, "_update_asteroids_selected")
	
func _prepare_for_deletion() -> void:
	._prepare_for_deletion()
	Global.disconnect("system_tree_ready", self, "_build_navigation_tree")
	Global.disconnect("camera_ready", self, "_connect_camera")
	_disconnect_camera()
	_points_manager.disconnect("show_points_changed", self, "_update_asteroids_selected")

func _connect_camera(camera: Camera) -> void:
	if _connected_camera != camera:
		_disconnect_camera()
		_connected_camera = camera
		_connected_camera.connect("camera_lock_changed", self, "_update_camera_lock")

func _disconnect_camera() -> void:
	if _connected_camera:
		_connected_camera.disconnect("camera_lock_changed", self, "_update_camera_lock")
		_connected_camera = null

func _select_asteroids(pressed: bool, group_or_category: String) -> void:
	# only select one group or all groups or none
	if group_or_category == "all_asteroids":
		_points_manager.show_points("all_asteroids", pressed)
	else:
		var is_show: bool = pressed or _asteroid_buttons.all_asteroids.pressed
		if is_show:
			for key in _asteroid_buttons:
				_points_manager.show_points(key, key == group_or_category)
		else:
			_points_manager.show_points(group_or_category, false)
		
func _update_asteroids_selected(group_or_category: String, is_show: bool) -> void:
	_asteroid_buttons[group_or_category].pressed = is_show
	if !is_show:
		_asteroid_buttons.all_asteroids.pressed = false
	
func _update_camera_lock(is_locked: bool) -> void:
	$CameraLock.pressed = is_locked
	
func _toggle_camera_lock(button_pressed: bool) -> void:
	_connected_camera.change_camera_lock(button_pressed)
