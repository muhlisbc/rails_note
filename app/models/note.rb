class Note
  include Mongoid::Document
  include Mongoid::Timestamps
  include Stat

  belongs_to :user

  field :title,       type: String
  field :content,     type: String
  field :tags,        type: Array,           default: []
  field :is_public,   type: Mongoid::Boolean, default: false

  validates_presence_of :content

  paginates_per 20

  # tags setter
  def tag_list=(arg)
    self.tags = arg.to_s.split(",").map { |t| t.strip }.reject { |t| t.blank? }
  end

  # tags getter
  def tag_list
    self.tags.join(", ")
  end

  def self.stat(date = nil)
    date        ||= DateTime.now.utc
    results = initialize_stat(date, 0)

    project = {
      "$project" => {
        "ymd" => {
          "$dateToString" => {
            "format" => "%Y-%m-%d",
            "date" => "$created_at"
          }
        }
      }
    }

    group = {
      "$group" => {
        "_id" => "$ymd",
        "count" => {
          "$sum" => 1
        }
      }
    }

    self.collection.aggregate([match_between_date(date), project, group]).each do |result|
      day = result["_id"].split("-")[-1].to_i - 1
      results[:days][day][:count] = result["count"]
    end

    results
  end

end
