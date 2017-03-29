class User
  include Stat
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  has_many :notes

  field :email,               type: String
  field :is_admin,            type: Mongoid::Boolean, default: false
  field :is_email_confirmed,  type: Mongoid::Boolean, default: false
  field :password_digest,     type: String

  has_secure_password
  index({ email: 1 }, { unique: true, name: "user_email_index" })

  validates :email, presence: true, uniqueness: true, format: /\A^.+@.+$\z/
  validates :password, presence: true, length: {minimum: 8}, on: :create

  paginates_per 21

  def avatar
    "https://www.gravatar.com/avatar/" + Digest::MD5.hexdigest(self.email) + ".jpg?s=48&d=mm"
  end

  def self.stat(date = nil)
    date        ||= DateTime.now.utc
    results = initialize_stat(date, {confirmed: 0, unconfirmed: 0})

    project = {
      "$project" => {
        "ymd" => {
          "$dateToString" => {
            "format" => "%Y-%m-%d",
            "date" => "$created_at"
          }
        },
        "email_confirmed" => {
          "$cond" => ["$is_email_confirmed", 1, 0]
        },
        "email_unconfirmed" => {
          "$cond" => ["$is_email_confirmed", 0, 1]
        }
      }
    }

    group = {
      "$group" => {
        "_id" => "$ymd",
        "confirmed" => {
          "$sum" => "$email_confirmed"
        },
        "unconfirmed" => {
          "$sum" => "$email_unconfirmed"
        }
      }
    }

    self.collection.aggregate([match_between_date(date), project, group]).each do |result|
      day = result["_id"].split("-")[-1].to_i - 1
      results[:days][day][:count] = result.slice "confirmed", "unconfirmed"
    end

    results
  end

end
