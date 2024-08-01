#!/bin/sh

set +xe

help() {
    echo "
    Startup.SH
    
    Run Rails on docker using a single command by Petar <Shannarra> Angelov (https://github.com/Shannarra/)

    By default this script will own all of the project's files to your user, create an .env file and
    setup the database with basic models' data. 

    This does NOT include authorization with Devise, for that see --device.

    Commands:
    -d, --devise [NAME]         => setup the application using Devise with given NAME 
    -r, --run                   => start the container up when the setup has finished.
    -h, --help                  => display this message

    Found a bug? Have any suggestions?
    You can always open a PR at https://github.com/Shannarra/rails7template
";
}

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
    -r|--run) # Run when everything has been built
      RUN_WHEN_DONE=1
      shift # past argument
      ;;
    -h|--help)
      help
      shift
      exit 0
      ;;
    -*|--*|*)
      echo -e "Invalid option \"$1\". Check -h or --help for more info."
      exit 1
      ;;
  esac
done


setup_device() {
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
        # doing db:setup here doesn't work
        docker compose run --rm web rails db:create
        docker compose run --rm web rails db:migrate
        docker compose run --rm web rails db:seed

        echo "[STARTUP] Devise $DEVISE_NAME successfully created!"
    else
        echo "[STARTUP] Could not create device $DEVISE_NAME :("
        exit 1
    fi
    
    sed -i "42 i \\
            <device-buttons>
" app/views/layouts/application.html.erb
    
    sed -i "/<device-buttons>/ {
    s/<device-buttons>//g
    a\            <form class=''> \\
              <%- if !current_user.present? %> \\
                <%= link_to 'Login', new_user_session_path, class: 'btn btn-outline-primary mr-2' %> \\
                <%= link_to 'Become member', new_user_registration_path, class: 'btn btn-outline-success' %> \\
              <%- else %> \\
                <%= link_to 'Log out', destroy_user_session_path, class: 'btn btn-outline-danger', data: { turbo_method: :delete }%> \\
              <% end %> \\
            </form>
}" app/views/layouts/application.html.erb 

}

setup_application() {
    chmod u+x -R ./bin/*

    cp .env.example .env

    docker compose build

    if [ $USES_DEVISE -eq 1 ]; then
        setup_device
    else
        echo "[STARTUP] Setting up database"
        docker compose run --rm web rails db:setup
    fi

    if [ $RUN_WHEN_DONE -eq 1 ]; then
        docker compose up
    fi
}

setup_application
