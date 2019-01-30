class MtgEventInfo::CLI
  
  def call
    puts "Welcome to Mox Ruby, a tool for displaying and sorting information about upcoming Magic: The Gathering events."
    menu
    puts "Thank you for using Mox Ruby.  Good luck and have fun!"
  end

  def menu
    
    @input = nil
    while @input != "exit"
      list_events_by
      @input = gets.strip.downcase
      
      case @input
      when "1"
        list_events(1)
        sub_input = nil
        list_events_with_details(sub_input)
        
      when "2"
        list_events(2)

      when "3"
        list_events(3)
        sub_input = nil
        list_events_with_details(sub_input)
        
      when "exit"
        
      else
        puts "I did not understand your selection."
      end
      
    end
    
  end

  def list_events_by
    i = 0
    @options = ["Date","Format","Location"]
    puts ""
    @options.each do |option|
      i+=1
      puts "#{i}. #{option}"
    end
    puts ""
    puts "Please enter the number corresponding to the option by which you want to sort and display upcoming events or enter 'exit'."
    @events = MtgEventInfo::Event.all
    @events.delete_if {|event| Date.parse(event[:date]) < Date.today}
  end
  
  def list_events(selection)
    
    if selection === 1
      @events.sort_by!{ |event| event[:date]}
      @events.each.with_index(1) do |event, i|
        puts "#{i}. #{event[:date]} - #{event[:TO]} #{event[:name]} - #{event[:location]}"
      end
      
    elsif selection === 2
      @format_selection = nil
      while @format_selection != "back"
        list_formats
        @format_selection = gets.strip.downcase
        if @format_selection.to_i > 0  && @format_selection.to_i <= @format_array.length
          list_events_by_format(@format_selection)
          sub_input = nil
          list_events_with_details(sub_input)
        elsif @format_selection.to_i > @format_array.length
          puts "Please enter a number from the list."
        elsif @format_selection == "list"
          list_events_by_format
        elsif @format_selection == "back"
    
        else
          puts "I did not understand your selection."
        end

      end

    elsif selection === 3
      @events.uniq{ |event| event[:location]}.sort_by!{ |event| event[:location]}.each.with_index(1) do |event, i|
        puts "#{i}. #{event[:location]}"
      end
    end
    
  end
  
  def list_events_with_details(selection)
    
    while selection != "back"
      puts "Please enter the number corresponding to the event about which you would like more information or enter 'list' to see the list of events again or enter 'back' to return to the main menu."
      selection = gets.strip.downcase
      if selection.to_i > 0  && selection.to_i <= @events.length
        @events.each do |event|
          if event[:location] === @events[selection.to_i-1][:location]
            puts ""
            puts "#{event[:TO]} #{event[:location]} #{event[:mtgFormat]} #{event[:name]}"
            puts "#{event[:date]}"
            puts "#{event[:moreInfoURL]}"
            puts ""
          # else
          #   puts ""
          #   puts "#{@events[selection.to_i-1][:TO]} #{@events[selection.to_i-1][:location]} #{@events[selection.to_i-1][:mtgFormat]} #{@events[selection.to_i-1][:name]}"
          #   puts "#{@events[selection.to_i-1][:date]}"
          #   puts "#{@events[selection.to_i-1][:moreInfoURL]}"
          #   puts ""
          end
        end
      elsif selection.to_i > @events.length
        puts "Please enter a number from the list."
      elsif selection == "list"
        if @input.to_i === 1 || @input.to_i === 3
          list_events(@input.to_i)
        else
          list_events_by_format(@format_selection)
        end
      elsif selection == "back"
        
      else
        puts "I did not understand your selection."
      end
    end
    
  end

  def list_formats
    @format_array = ["Standard","Limited","Modern","Legacy","Team Constructed"]
    i = 0
    puts ""
    @format_array.each do |mtgFormat|
      i+=1
      puts "#{i}. #{mtgFormat}"
    end
    puts ""
    puts "Please enter the number corresponding to the format by which you want to sort and display upcoming events or enter 'back' to return to the main menu."
  end
  
  def list_events_by_format(selection)
    i = 0
    event_array = []
    puts ""
    @events.each.with_index do |event|
      if @format_array[@format_selection.to_i-1] === event[:mtgFormat]
        i+=1
        puts "#{i}. #{event[:date]} - #{event[:TO]} #{event[:name]} - #{event[:location]}"
        event_array.push(event)
      end
    end
    if event_array.length === 0
      puts "No upcoming events for the selected format."
    end
    puts ""
  end

end