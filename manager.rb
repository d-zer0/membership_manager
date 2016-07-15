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
			"List" => nil, 
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
		#begin
			menu[@action].call
#		rescue
#			clear_screen
#			puts "Error: Invalid input or feature not implemented."
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
			approved: [],
			unapproved: [],
			removed: [],
			banned: []
		}
		save_member_list
	end

	def reset_variables
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


	def find_member(name)
		update_names_to_keys_if_necessary
		@current_status = @member_to_keys[@name]
		@member_exists = true unless @current_status.empty?
		@current_status
	end

	def update_names_to_keys_if_necessary
		return if @old_members == @members 
		@member_to_keys = @members.each_with_object(Hash.new { |h,k| h[k] = [] }) { |(k,v),h| v.each { |name| h[@name] << k } }
		@old_members = @member_to_keys
	end

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
			:approved
		when "2"
			:unapproved
		when "3"
			:removed
		when "4"
			:banned
		end
		#puts "DEBUG: @members is #{@members.inspect}"
		#sleep 1
		@members.values.each do |member|
			member.delete_if {|it| it == @name}
		end
		@members[@new_group] << @name
		flash_message("#{@name} added to #{@new_group}")
	end

	def flash_message(message)
		clear_screen
		puts message
	end

end

=begin
	def find_member(@name)
		puts "Members: #{@members.inspect}"
  		@members.select {|k,v| v.include? @name }.keys
	end
=end

=begin
	def find_member_group(@name)
		@members.each { |group, @names| return group if @names.include?(@name) }
		nil
	end

	def find_member
		clear_screen
		puts "---Find Member---"
		puts ""
		puts "@name: "
		@name = gets.chomp
		group_@name = find_member_group(@name)
		puts group_@name ? "#{@name} found in #{group_@name}." : "#{@name} not found."
		if group_@name != nil
			puts "Move #{@name} from #{group_@name}?"
			puts "[1]Yes [2]No"
			input = gets.chomp
			if input == "1"
				@old_group = group_@name
				move_member
			else
				main_menu
			end
		end
	end
=end

member = MembershipManager.new