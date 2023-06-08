require("fileutils")

source_images_directory = File.join(__dir__, "images")
repository_directory = File.dirname(__dir__)
distributions_directory = File.join(repository_directory, "distributions")
distributions_images_directory = File.join(distributions_directory, "images")
license_file = File.join(repository_directory, "LICENSE")
corner_coordinate = {x: 4, y: 3}
center_coordinate = {x: 26, y: 26}
cursor = {
	name: "skippyr_cursor",
	size: 52,
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
		}
	]
}

def create_images(source_images_directory, distributions_images_directory)
	layers_directory = File.join(distributions_images_directory, "layers")
	FileUtils.rm_rf(distributions_images_directory)
	puts("Creating images:")
	for source in Dir.children(source_images_directory)
		FileUtils.rm_rf(layers_directory)
		FileUtils.mkdir_p(layers_directory)
		source_path = File.join(source_images_directory, source)
		source_without_extension = File.basename(source, File.extname(source))
		layer_image = "#{File.join(layers_directory, source_without_extension)}.png"
		system("convert #{source_path} #{layer_image}")
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
			distributions_images_directory,
			source_without_extension
		)}.png"
		system("convert #{composite.join(" ")} #{image_file}")
		puts("\tCreated image from #{source}.")
	end
	FileUtils.rm_rf(layers_directory)
end

def create_cursor(
	distributions_directory,
	distributions_images_directory,
	cursor
)
	cursor_directory = File.join(distributions_directory, cursor[:name])
	parts_directory = File.join(cursor_directory, "cursors")
	settings_file = File.join(cursor_directory, "settings.cfg")
	metadata_file = File.join(cursor_directory, "index.theme")
	FileUtils.rm_rf(cursor_directory)
	FileUtils.mkdir_p(parts_directory)
	File.write(metadata_file, "[Icon Theme]\nName=#{cursor[:name]}\n")
	puts("Creating cursor part files:")
	for part in cursor[:parts]
		image_file = "#{File.join(distributions_images_directory, part[:name])}.png"
		for file in part[:files]
			part_file = File.join(parts_directory, file)
			File.write(settings_file, "#{cursor[:size]} #{part[:hotspot][:x]} #{part[:hotspot][:y]} #{image_file} 0")
			system("xcursorgen #{settings_file} #{part_file}")
			puts("\tCreated part file #{file}.")
		end
	end
	FileUtils.rm_rf(settings_file)
	puts("Created cursor at: #{cursor_directory}.")
end

FileUtils.rm_rf(distributions_directory)
create_images(source_images_directory, distributions_images_directory)
create_cursor(distributions_directory, distributions_images_directory, cursor)

