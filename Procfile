web: bundle exec rails server -e $RAILS_ENV -p $PORT -b 0.0.0.0
resque: QUEUE=bookmark_archive_queue bundle exec rake environment resque:work  
