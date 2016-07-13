require 'yaml'

class TeamValor

	def initialize
		member_list = YAML::load(File.read("members/member_list.sav"))
	end

	def import_member_list
		puts "File: "
		file = gets.chomp
		puts "Confirm import of [#{file}]"
		puts "1. Confirm"
		puts "2. Cancel"
		input = gets.chomp
		if input == "1" # import the list
			# first create members hash
			members = Hash.new

			Dir.mkdir("members") unless Dir.exists? "members"
			filename = "members/member_list.sav"
			save_file = File.new(filename, 'w')
			save_file.write(yaml)
			save_file.close
		else # return to main menu
			puts "Import cancelled."
			main_menu
		end

end