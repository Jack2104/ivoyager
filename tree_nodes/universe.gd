# universe.gd
# This file is part of I, Voyager (https://ivoyager.dev)
# *****************************************************************************
# Copyright (c) 2017-2020 Charlie Whitfield
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
# Universe is the main scene root node. It provides spatial reference for top
# Body instances, which could be the Sun or a collection of stars or something
# else. Get the Universe instance from Global.program.universe. Get specific
# Body instances by name or id from Registrar (program_nodes/registrar.gd)
# which you can access via Global.program.Registrar.
#
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# !!!!!!!!          Developers! The place to start is:                 !!!!!!!!
# !!!!!!!!          ivoyager/singletons/project_builder.gd             !!!!!!!!
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

extends Spatial

const PERSIST_AS_PROCEDURAL_OBJECT := false

const j_epoch_in_unix_time: float = 946690200.0 # Seconds between Jan 1st 1970 and Jan 1st 2000
var j_epoch_dict := {
	"year": 2000,
	"month": 1,
	"day": 1,
	"hour": 0,
	"minute": 0,
	"second": 0
}
var start_time_dict := {
	"year": 2020,
	"month": 5,
	"day": 10,
	"hour": 0,
	"minute": 0,
	"second": 0
}

func _on_Universe_tree_entered():
	var start_time_in_unix_time := OS.get_unix_time_from_datetime(start_time_dict)
	Global.start_time = start_time_in_unix_time - OS.get_unix_time_from_datetime(j_epoch_dict)
