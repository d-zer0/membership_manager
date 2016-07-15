require 'yaml'

class MembershipManager
	
	def initialize
		puts "Membership Manager intialised!"
		reset_variables
		load_members
	end

	def main_menu
		puts "--- MAIN MENU ---"
		menu = {
			"Find" => method(:member_search), 
			"List" => method(:list_members), 
			"Add" => method(:add_member),
			"Change Status" => method(:assign_status), 
			"Delete Record" => nil
		}

		options = menu.keys
		methods = menu.values

		options.each_with_index do |option, index|
			puts "[#{index+1}]#{option}"
		end

		input = gets.chomp.to_i
		puts "Input: #{input.inspect}"
		@action = options[input-1]
		clear_screen
		#begin
			menu[@action].call
#		rescue
#			flash_message("Error: Invalid input or feature not implemented.")
#			return main_menu
#		end

		save_member_list
		main_menu
	end

	def load_members
		unless Dir.exists? "members"
			Dir.mkdir("members")
			create_member_list
		end

		file = YAML::load(File.read("members/member_list.sav"))
		file.main_menu
		# create_member_list if @members == nil
	end

	def create_member_list
		@members = {
			"Approved" => [],
			"Unapproved" => [],
			"Removed" => [],
			"Banned" => []
		}
		save_member_list
	end

	def reset_variables
		@current_status = false
		@member_exists = false
		@name = ""
		@action = ""
		@new_group = ""
	end

	def clear_screen
		(system "cls") or (system "clear")
	end

	def save_member_list
		reset_variables
		yaml = YAML::dump(self)
		filename = "members/member_list.sav"
		save_file = File.new(filename, 'w')
		save_file.write(yaml)
		save_file.close
	end

	def member_search
		clear_screen
		puts "--- MEMBER SEARCH ---"
		print "Name: "
		@name = gets.chomp
		find_member(@name)
	end

	# THIS is what I'm having trouble with
	# It should see if name exists as the value for "Name" in any of the profile hashes.
	def find_member(name)
		@members.each do |member|
			member.each do |status|
				counter = 0
				profile = status[counter]
				unless profile == nil
					name = profile["Name"]
					puts name
					puts name.class.name
					puts
				end
				counter +=1
			end
		end

		# Some working out I did trying to get to the "Name" keys
=begin
		# Members Hash
		puts "@members is a #{@members.class.name}"
		puts @members.inspect
		puts

		#Status arrays
		puts "@members['Banned'] is a #{@members["Banned"].class.name}"
		puts @members["Banned"]
		puts

		#Profile hashes
		banned = @members["Banned"]
		puts "banned[0] is a #{banned[0].class.name}"
		puts banned[0].inspect
		puts

		#Profile keys
		puts "#{banned[0]["Name"]} is a #{banned[0]["Name"].class.name}"
		puts banned[0]["Name"].inspect
		x = banned[0]["Name"]
		@current_status = banned[0]["Status"]
		puts

		@member_exists = true if x == name
		puts "@member_exists: #{@member_exists}"
=end
		#end
		#puts "Exists: #{@member_exists}"
		#sleep 2
	end

=begin
	def find_member(name)
		update_names_to_keys_if_necessary
		#@member_exists = true if @member_to_keys.exists? (@name)
		puts @member_exists.inspect
		#@current_status = @member_to_keys[@name]
		#@member_exists = true unless @current_status == false
		#@current_status
	end

	def update_names_to_keys_if_necessary
		return if @old_members == @members 
		@member_to_keys = @members.each_with_object(Hash.new { |h,k| h[k] = [] }) { |(k,v),h| v.each { |name| h[@name] << k } }
		@old_members = @member_to_keys
	end
=end

	def add_member
		member_search
		return move_member(@name) if @member_exists == true
		assign_status
		save_member_list
	end

	def move_member(name)
		member_search unless @action == "Add"
		puts "#{@name} found in '#{@current_status}'."
		puts "Move member? [1]Yes [2]No"
		input = gets.chomp
		case input
		when "1"
			assign_status
		when "2"
			puts "Cancelled. Returning to menu."
			sleep 1
			main_menu
		end
	end

	def assign_status
		member_search if @action == "Change Status"
		puts "Choose status for #{@name}:"
		puts "[1]Approved [2]Unapproved [3]Removed [4]Banned"
		input = gets.chomp
		@new_group = case input
		when "1" #Approved
			"Approved"
		when "2"
			"Unapproved"
		when "3"
			"Removed"
		when "4"
			"Banned"
		end
		#puts "DEBUG: @members is #{@members.inspect}"
		#sleep 1
		# DELETE ENTRIES
		#@members.values.each do |member|
		#	member.delete_if {|it| it.values["Name"] == @name}
		#end
		#new_member = []
		profile = {
			"Name" => @name, 
			"Status" => @new_group, 
			"Join Date" => Time.new
		}
		#new_member << profile
		@members[@new_group] << profile
		flash_message("#{@name} added to #{@new_group}")
	end

	def flash_message(message)
		clear_screen
		puts message
	end

	def list_members
		@members.keys.each_with_index do |member, index|
			puts "#{index+1}. #{member.capitalize}"
		end
		input = gets.chomp.to_i
		clear_screen
		status = @members.keys[input-1]
		members = @members.values[input-1]
		puts "--- #{status.upcase} ---"
		members.each_with_index do |member, index|
			puts "#{index+1}. #{member}"
		end
		puts "Select member with number or [C]Change List [X]Main Menu"
		input = gets.chomp.to_i
		#unfinished
	end



end

member = MembershipManager.new