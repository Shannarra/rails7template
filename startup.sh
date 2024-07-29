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
    -r, --run                   => start the container up when the setup has finished.
    -h, --help                  => display this message

    Found a bug? Have any suggestions?
    You can always open a PR at https://github.com/Shannarra/rails7template
";
}

while [ $# -gt 0 ]; do
  case $1 in
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
