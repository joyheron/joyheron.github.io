require 'find'
require 'fileutils'

def convert(file)
	if (!File.directory?(file) && file[".jpg"])
		new_name = file.sub '_raw_img', 'img'
		new_dir = File.dirname(new_name)
		unless File.directory?(new_dir)
			puts "creating #{new_dir}"
			FileUtils.mkdir_p(new_dir)
		end

		if File.file?(new_name) 
			puts "Skipping #{file}, #{new_name} already exists"
		else 
			cmd = "convert #{file} -resize 750 -strip -quality 86 #{new_name}"
			puts "converting... #{file}-->#{new_name}"
			system cmd
		end
	end
end

Find.find('../_raw_img') { |e| convert e}