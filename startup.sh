#!/bin/sh

set +xe

while [ $# -gt 0 ]; do
  case $1 in
    -d|--devise)
      USES_DEVISE=1
      shift # past argument

      if [ -z $1 ]; then
          echo "ERROR: If you want to create a devise, please provide a name! Use --help for more info."
          exit 1
      fi
      
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

if [ $USES_DEVISE -eq 1 ]; then

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
        echo "[STARTUP] Setting up database"
        docker compose run --rm web bin/rails db:create
        docker compose run --rm web rails db:migrate

        echo "[STARTUP] Devise $DEVISE_NAME successfully created!"
    else
        echo "[STARTUP] Could not create device $DEVISE_NAME :("
        exit 1
    fi
    
    sed -i "42 i \\
            <device-buttons>
" app/views/layouts/application.html.erb

#     sed -i "/<device-buttons>/ {
#     s/<device-buttons>//g
#     a\<form class=''>
#               <a class='btn btn-outline-primary mr-2' href='#'>Login</a>
#               <a class='btn btn-outline-success' href='#'>Become member</a>
#             </form>
# }" app/views/layouts/application.html.erb

    sed -i "/<device-buttons>/ {
    s/<device-buttons>//g
    a\            <form class=''> \\
              <a class='btn btn-outline-primary mr-2' href='#'>Login</a> \\
              <a class='btn btn-outline-success' href='#'>Become member</a> \\
            </form>
}" app/views/layouts/application.html.erb 

else
    echo "[STARTUP] Setting up database"
    docker compose run --rm web bin/rails db:setup
fi
