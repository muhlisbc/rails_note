module Stat
  extend ActiveSupport::Concern

  module ClassMethods
    def new_this_month
      self.collection.aggregate([match_between_date]).count
    end
  end

  included do

    def self.match_between_date(date = nil)
      date ||= DateTime.now.utc
      {
        "$match" => {
          "created_at" => {
            "$lt" => date.at_end_of_month,
            "$gt" => date.at_beginning_of_month
          }
        }
      }
    end

    def self.initialize_stat(date, data)
      {
        year: date.year,
        month: date.month,
        days: (1..(date.at_end_of_month.day)).map do |day|
          {
            id: day,
            count: data
          }
        end
      }
    end

  end
end
