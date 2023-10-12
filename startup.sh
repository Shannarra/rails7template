#!/bin/sh

set +xe

while [ $# -gt 0 ]; do
  case $1 in
    -d|--devise)
      USES_DEVISE=1
      shift # past argument

      DEVISE_NAME=$1
      shift # past value
      ;;
    --default)
      DEFAULT=YES
      shift # past argument
      ;;
    -*|--*|*)
      echo -e "Invalid option \"$1\". Check -h or --help for more info."
      exit 1
      ;;
  esac
done

chmod u+x -R ./bin/*

cp .env.example .env

docker compose build

echo "[STARTUP] Setting up Devise gem..."

sed -i "65 i \\
# Useful to bootstrap authentication. https://stackoverflow.com/a/42190260/11542917 \\
" Gemfile
sed -i "66 i gem 'devise'" Gemfile

# install gem
docker compose run --rm web bundle

# do the setup
docker compose run --rm web rails g devise:install

# enable :turbo_stream
sed -i "266 i \\
  config.navigational_formats = ['*/*', :html, :turbo_stream] \\
" config/initializers/devise.rb

echo "[STARTUP] Creating devise $DEVISE_NAME...."

# https://www.digitalocean.com/community/tutorials/how-to-set-up-user-authentication-with-devise-in-a-rails-7-application
docker compose run --rm web rails g devise $DEVISE_NAME

if [ $? -eq 0 ]; then
  echo "[STARTUP] Devise $DEVISE_NAME successfully created!\nMigrating database..."
  docker compose run --rm web rails db:migrate
else
  echo "[STARTUP] Could not create device $DEVISE_NAME :("
fi

echo "[STARTUP] Setting up database"
docker compose run --rm web bin/rails db:setup
