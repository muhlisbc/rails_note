# Rails Note

Simple note app built with Rails 5 and Mongoid.

![Login page](https://github.com/muhlisbc/rails_note/raw/master/login_page.png)

![New note page](https://github.com/muhlisbc/rails_note/raw/master/new_note_page.png)

![Admin page](https://github.com/muhlisbc/rails_note/raw/master/admin_page.png)

Demo: [https://rails-note.arukascloud.io/account](https://rails-note.arukascloud.io/account)

## Requirements

* Ruby on Rails >= 5.0
* MongoDB >= 3.0

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
* `DEFAULT_FROM_EMAIL` Dafault from email
* `RAILS_USE_SSL` (optional) Optionally force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
* `APP_HOSTNAME` Application hostname. Required by `ActionMailer`
## License

The app is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
