class MembershipManager
	
	def initialize
		puts "Membership Manager intialised!"
		main_menu

		@members = {
			approved: [],
			unapproved: ["Daniel"],
			removed: ["John"],
			banned: ["Daniel", "Varcas"]
		}
	end

	def main_menu
		puts "[1]Find"
		puts "[2]List"
		puts
		puts "[3]Add"
		puts "[4]Approve"
		puts "[5]Remove"
		puts "[6]Ban"
		puts
		puts "[7]Change Status"
		puts "[8]Delete Record"
		input = gets.chomp
		case input
		when "1" #Find
			find_member
		when "2" #List
		when "3" #Add
		when "4" #Approve
		when "5" #Remove
		when "6" #Ban
		when "7" #Change Status
			move_member
		when "8" #Delete Record
		end
	end

	def find_member_group(name)
		@members.each { |group, names| return group if names.include?(name) }
		nil
	end

	def find_member
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

	def move_member
		find_member if @old_group == nil
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
		@members[@old_group].delete(@name)
		@members[new_group] << @name
		puts "#{@name} moved from #{@old_group} to #{new_group}"
	end
end

member = MembershipManager.new
