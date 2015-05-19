require 'uri'
require 'json'

module Jekyll
  module Filters

    def date_to_german_month(date)
      month = time(date).strftime("%m")

      case month
        when "01" 
          month = "Januar"
        when "02" 
          month = "Februar"
        when "03" 
          month = "März"
        when "04" 
          month = "April"
        when "05"
          month = "Mai"
        when "06"
          month = "Juni"
        when "07"
          month = "Juli"
        when "08" 
          month = "August"
        when "09" 
          month = "September"
        when "10"
          month = "Oktober"
        when "11"
          month = "November"
        when "12"
          month = "Dezember"
        else
          month = "notSet"
      end

      return month
    end

    # Format a date in short format e.g. "27 Jan 2011".
    #
    # date - the Time to format.
    #
    # Returns the formatting String.
    def date_to_german(date)
      day   = time(date).strftime("%d. ")
      month = time(date).strftime("%m")
      year  = time(date).strftime(" %Y")

      case month
        when "01" 
          month = "Januar"
        when "02" 
          month = "Februar"
        when "03" 
          month = "März"
        when "04" 
          month = "April"
        when "05"
          month = "Mai"
        when "06"
          month = "Juni"
        when "07"
          month = "Juli"
        when "08" 
          month = "August"
        when "09" 
          month = "September"
        when "10"
          month = "Oktober"
        when "11"
          month = "November"
        when "12"
          month = "Dezember"
        else
          month = "notSet"
      end

      return day + month + year
    end

  end
end
