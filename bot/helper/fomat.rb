#Geneerated by ChatGpt, and barely adjusted by me
module FormatHelper 
    class << self 
        #time in secs => 12 hours 
        def format_time(timestamp)
            # Calculate the number of seconds in the timestamp
            seconds = timestamp.to_i
        
            # Calculate the number of days in the timestamp
            days = seconds / (60 * 60 * 24)
            seconds -= days * (60 * 60 * 24)
        
            # Calculate the number of hours in the timestamp
            hours = seconds / (60 * 60)
            seconds -= hours * (60 * 60)
        
            # Calculate the number of minutes in the timestamp
            minutes = seconds / 60
            seconds -= minutes * 60
        
            # Build the human-readable string
            result = ""

            result += "#{days} day" if days > 0
            result += "s" if days > 1
            result += " "
            
            result += "#{hours} hour" if hours > 0
            result += "s" if hours > 1
            result += " "

            result += "#{minutes} min" if minutes > 0
            result += "s" if minutes > 1
            result += " " 

            result.strip()
        end
    end

end
