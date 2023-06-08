require("fileutils")

$source_images_directory = File.join(__dir__, "images")
$repository_directory = File.dirname(__dir__)
$distributions_directory = File.join($repository_directory, "distributions")
$distributions_images_directory = File.join($distributions_directory, "images")
$license_file = File.join($repository_directory, "LICENSE")
corner_coordinate = {x: 4, y: 3}
center_coordinate = {x: 15, y: 15}
$cursor = {
	name: "skippyr_cursor",
	size: 29,
	scale: 2,
	parts: [
		{
			name: "xterm",
			files: ["xterm", "text"],
			hotspot: center_coordinate
		},
		{
			name: "left_ptr",
			files: ["left_ptr", "right_ptr", "pointing_hand"],
			hotspot: corner_coordinate
		},
		{
			name: "hand2",
			files: [
				"hand2",
				"hand1",
				"hand",
				"grab",
				"openhand"
			],
			hotspot: corner_coordinate
		},
		{
			name: "ns-resize",
			files: [
				"bottom_side",
				"n-resize",
				"ns-resize",
				"row-resize",
				"s-resize",
				"sb_v_double_arrow",
				"size_ver",
				"split_v",
				"top_side"
			],
			hotspot: center_coordinate
		},
		{
			name: "ew-resize",
			files: [
				"col-resize",
				"e-resize",
				"ew-resize",
				"left_side",
				"right_side",
				"sb_h_double_arrow",
				"size_hor",
				"split_h",
				"w-resize"
			],
			hotspot: center_coordinate
		},
		{
			name: "nwse-resize",
			files: [
				"bottom_right_corner",
				"nw-resize",
				"nwse-resize",
				"se-resize",
				"size_fdiag",
				"top_left_corner"
			],
			hotspot: center_coordinate
		},
		{
			name: "nesw-resize",
			files: [
				"bottom_left_corner",
				"ne-resize",
				"nesw-resize",
				"size_bdiag",
				"sw-resize",
				"top_right_corner"
			],
			hotspot: center_coordinate
		},
		{
			name: "all-scroll",
			files: [
				"all-scroll",
				"cell",
				"crosshair",
				"move",
				"fleur",
				"plus"
			],
			hotspot: center_coordinate
		},
		{
			name: "help",
			files: [
				"context-menu",
				"dnd-ask",
				"help",
				"question_arrow"
			],
			hotspot: corner_coordinate
		},
		{
			name: "vertical-text",
			files: ["vertical-text"],
			hotspot: center_coordinate
		},
		{
			name: "watch",
			files: [
				"watch",
				"wait",
				"progress",
				"half-busy",
				"left_ptr_watch"
			],
			hotspot: corner_coordinate
		},
		{
			name: "zoom-in",
			files: ["zoom-in"],
			hotspot: corner_coordinate
		},
		{
			name: "zoom-out",
			files: ["zoom-out"],
			hotspot: corner_coordinate
		},
		{
			name: "not-allowed",
			files: [
				"dnd-no-drop",
				"dnd-none",
				"no-drop",
				"not-allowed"
			],
			hotspot: corner_coordinate
		}
	]
}

def create_images()
	layers_directory = File.join($distributions_images_directory, "layers")
	FileUtils.rm_rf($distributions_images_directory)
	puts("Creating images:")
	for source in Dir.children($source_images_directory)
		FileUtils.rm_rf(layers_directory)
		FileUtils.mkdir_p(layers_directory)
		source_path = File.join($source_images_directory, source)
		source_without_extension = File.basename(source, File.extname(source))
		layer_image = "#{File.join(layers_directory, source_without_extension)}.png"
		system("convert #{source_path} -scale #{$cursor[:size] * $cursor[:scale]} #{layer_image}")
		composite = []
		index = 0
		for layer in Dir.children(layers_directory)
			layer_path = File.join(layers_directory, layer)
			composite << layer_path
			if index != 0
				composite << "-composite"
			end
			index += 1
		end
		image_file = "#{File.join(
			$distributions_images_directory,
			source_without_extension
		)}.png"
		system("convert #{composite.join(" ")} #{image_file}")
		puts("\tCreated image of source #{source}.")
	end
	FileUtils.rm_rf(layers_directory)
end

def create_cursor()
	cursor_directory = File.join($distributions_directory, $cursor[:name])
	parts_directory = File.join(cursor_directory, "cursors")
	settings_file = File.join(cursor_directory, "settings.cfg")
	metadata_file = File.join(cursor_directory, "index.theme")
	FileUtils.rm_rf(cursor_directory)
	FileUtils.mkdir_p(parts_directory)
	File.write(metadata_file, "[Icon Theme]\nName=#{$cursor[:name]}\n")
	puts("Creating cursor part files:")
	for part in $cursor[:parts]
		image_file = "#{File.join($distributions_images_directory, part[:name])}.png"
		for file in part[:files]
			part_file = File.join(parts_directory, file)
			File.write(
				settings_file,
				"#{$cursor[:size]} #{part[:hotspot][:x] * $cursor[:scale]} #{part[:hotspot][:y] * $cursor[:scale]} #{image_file} 0"
			)
			system("xcursorgen #{settings_file} #{part_file}")
			puts("\tCreated part file #{part[:name]} => #{file}.")
		end
	end
	FileUtils.rm_rf(settings_file)
	FileUtils.cp($license_file, cursor_directory)
	puts("Created cursor at: #{cursor_directory}.")
end

puts("Building cursor #{$cursor[:name]}.")
FileUtils.rm_rf($distributions_directory)
create_images()
create_cursor()

