#!/bin/bash
service nginx restart
rake db:seed
rails s
