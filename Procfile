web: bundle exec rails server -e $RAILS_ENV -p $PORT -b 0.0.0.0
resque: bundle exec rake environment resque:work QUEUE=bookmark_archive_queue
