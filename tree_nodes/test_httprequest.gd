extends Node

func test_request(table_name: String, row: String, column: String = ""):
	var http = HTTPRequest.new()
	add_child(http)
	var body := {"table name": table_name, "row": row, "column": column}
	http.request("http://localhost:7071/api/query_database", [], false, HTTPClient.METHOD_POST, to_json(body))
	
	return yield(http, "request_completed")

func _ready():
#	print("HTTPRequest Testing Starting...")
#	print(" ")
#	print(" ")
#	var response = yield(test_request("celestrak", "25544"), "completed")
#	print(response)
#	print(JSON.parse(response[3].get_string_from_utf8()).result)
#	print(" ")
#	print(" ")
	pass
