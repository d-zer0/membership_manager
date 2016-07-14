require 'yaml'

class MembershipManager
	
	def initialize
		puts "Membership Manager intialised!"
		@member_exists = false
		load_members
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

	def save_member_list
		yaml = YAML::dump(self)
		filename = "members/member_list.sav"
		save_file = File.new(filename, 'w')
		save_file.write(yaml)
		save_file.close
	end

	def main_menu
		puts "--- MAIN MENU ---"
		menu = {
			"Find" => method(:member_search), 
			"List" => nil, 
			"Add" => method(:add_member), 
			"Approve" => nil, 
			"Remove" => nil, 
			"Ban" => nil, 
			"Change Status" => "move_member", 
			"Delete Record" => nil
		}

		options = menu.keys
		methods = menu.values

		options.each_with_index do |option, index|
			puts "[#{index+1}]#{option}"
		end

		input = gets.chomp.to_i
		puts "Input: #{input.inspect}"
		choice = options[input-1]

		menu[choice].call

		save_member_list
		main_menu
	end

	def member_search
		system ("cls")
		puts "--- MEMBER SEARCH ---"
		print "Name: "
		name = gets.chomp
		find_member(name)
	end


	def find_member(name)
		update_names_to_keys_if_necessary
		@current_status = @member_to_keys[name]
		@member_exists = true unless @current_status.empty?
		@current_status
=begin
		@new_status = @member_to_keys(name)
		if (@new_status == @current_status)
			@name_exists = true
		else
			@name_exists = false
		end
		@current_status = @member_to_keys(name)
		puts "#{name} found in: #{@member_to_keys[name]}"
		@current_status
=end
	end

	def update_names_to_keys_if_necessary
		return if @old_members == @members 
		@member_to_keys = @members.each_with_object(Hash.new { |h,k| h[k] = [] }) { |(k,v),h| v.each { |name| h[name] << k } }
		@old_members = @member_to_keys
	end

	def add_member
		system ("cls")
		puts "--- ADD MEMBER ---"
		print "Name: "
		name = gets.chomp
		find_member(name)
		if @member_exists == true
			puts "#{name} found in '#{@current_status}'."
			puts "Move member? [1]Yes [2]No"
			input = gets.chomp
			case input
			when "1"
				move_member(name)
			when "2"
				puts "Cancelled. Returning to menu."
				sleep 1
				main_menu
			end
		else
			print "Status: "
			status = gets.chomp.to_sym
			@members[status] << name
			puts "#{name} added to #{status}"
			save_member_list
		end
	end

	def move_member(name)
		puts "Move to where?"
		puts "[1]Approved [2]Unapproved [3]Removed [4]Banned"
		input = gets.chomp
		new_group = case input
		when "1" #Approved
			:approved
		when "2"
			:unapproved
		when "3"
			:removed
		when "4"
			:banned
		end
		@members.each do |member|
			puts member
		end
		@members[new_group] << name
		puts "#{name} moved to #{new_group}"
	end

end

=begin
	def find_member(name)
		puts "Members: #{@members.inspect}"
  		@members.select {|k,v| v.include? name }.keys
	end
=end

=begin
	def find_member_group(name)
		@members.each { |group, names| return group if names.include?(name) }
		nil
	end

	def find_member
		system ("cls")
		puts "---Find Member---"
		puts ""
		puts "Name: "
		@name = gets.chomp
		group_name = find_member_group(@name)
		puts group_name ? "#{@name} found in #{group_name}." : "#{@name} not found."
		if group_name != nil
			puts "Move #{@name} from #{group_name}?"
			puts "[1]Yes [2]No"
			input = gets.chomp
			if input == "1"
				@old_group = group_name
				move_member
			else
				main_menu
			end
		end
	end
=end

member = MembershipManager.new