## This script reads the documentation outputted by Godot and generates an HTML page
## This is an editor script: open it in the Godot editor, and select `File > Run`
## or press ctrl+shift+x to run it.
@tool
extends EditorScript

var component_file_name := "HealthComponentExample"

func _run():
	var input_file_name := "res://docs/"+component_file_name+".xml"
	var output_file_name := "res://docs/"+component_file_name+".html"
	# Create an XML Parser
	var xml := XMLParser.new()
	var success := xml.open(input_file_name)
	
	if success != OK:
		push_error("Couldn't open the XML file, did you forget to run the documentation generator?")
		return
	
	# Start generating the HTML
	var html_string := "<html><title>Documentation</title></html><body>"
	
	# Read the entire file
	while xml.read() == OK:
		if xml.get_node_type() == XMLParser.NODE_ELEMENT:
			var node_name := xml.get_node_name()
			match node_name:
				"class":
					var script_class_name := xml.get_named_attribute_value("name")
					var class_inherits := xml.get_named_attribute_value("inherits")
					html_string += "<h1>Class: %s</h1>"%[script_class_name]
					html_string += "<h2>Inherits: %s</h2>"%[class_inherits]
				"brief_description":
					xml.read() # Move to content
					var brief_description = xml.get_node_data().strip_edges()
					html_string += "<p><strong>Brief Description:</strong> %s</p>"%[brief_description]
				"method":
					var method_name = xml.get_named_attribute_value("name")
					html_string += "<hr/><h3>Method: %s</h3>"%[method_name]
				"return":
					var return_type := xml.get_named_attribute_value("type")
					html_string += "<p><strong>Return Type:</strong> %s</p>"%[return_type]
				"param":
					var param_name := xml.get_named_attribute_value("name")
					var param_type := xml.get_named_attribute_value("type")
					html_string += "<p><strong>Parameter:</strong> %s (%s)</p>"%[param_name, param_type]
				"description":
					xml.read() # Move to content
					if xml.get_node_type() == XMLParser.NODE_TEXT and not xml.is_empty():
						var description := xml.get_node_data().strip_edges()
						html_string += "<p><strong>Description:</strong> %s</p>"%[description]
				"member":
					var member_name := xml.get_named_attribute_value("name")
					var member_type := xml.get_named_attribute_value("type")
					var member_default := xml.get_named_attribute_value("default")
					xml.read() # Move to content
					var member_description = xml.get_node_data().strip_edges()
					html_string += "<hr/><h3>Member: %s</h3>"%[member_name]
					html_string += "<p><strong>Type:</strong> %s</p>"%[member_type]
					html_string += "<p><strong>Default Value:</strong> %s</p>"%[member_default]
					html_string += "<p><strong>Description:</strong> %s</p>"%[member_description]
				"signal":
					var member_name := xml.get_named_attribute_value("name")
					xml.read() # Move to content
					var member_description := xml.get_node_data().strip_edges()
					html_string += "<hr/><h3>Signal: %s</h3>"%[member_name]
					html_string += "<p><strong>Description:</strong> %s</p>"%[member_description]
	
	# Close the html string
	html_string += "</body></html>"
	
	# Write to an output file
	var output_file := FileAccess.open(output_file_name, FileAccess.WRITE)
	if output_file != null:
		output_file.store_string(html_string)
		output_file.close()
		print("HTML file generated successfully!")
	else:
		push_error("Failed to write HTML file!")
