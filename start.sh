#!/bin/bash
service nginx restart
rake assets:precompile
rake db:seed
rails s
