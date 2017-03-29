# Rails Note

Simple note app built with Rails 5 and Mongoid.

## Requirements

* Ruby on Rails >= 5.0
* MongoDB

### Environment Variables

#### Optional

* `ADMIN_EMAIL` Administrator email address (default: `admin@domain.com`)
* `DB_NAME` MongoDB database name (default: `rails_note_#{Rails.env}`)
* `DB_ADDRESS` MongoDB host address (default: `localhost`)
* `DB_PORT` MongoDB host port (default: `27017`)
* `DB_MAX_POOL_SIZE` MongoDB maximum number of connections in the connection pool. (default: 5)
* `DB_MIN_POOL_SIZE` MongoDB minimum number of connections in the connection pool. (default: 1)
* `DB_USER` MongoDB user name for authentication.
* `DB_PASSWORD` MongoDB password for authentication.

#### Production

* `SECRET_KEY_BASE` You can generete one with `rake secret` command from app' root folder
* `SPARKPOST_API_KEY` You can grab one from [https://sparkpost.com/](https://sparkpost.com/)
* `DEFAULT_FROM_EMAIL` Dafault email from

## License

The app is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).