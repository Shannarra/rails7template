#!/bin/sh

set +xe

setup_application() {
    cp .env.example .env

    docker compose build

    echo "[STARTUP] Setting up database"
    docker compose run --rm web rails db:setup

    chmod u+x -R ./bin/*

    docker compose up
}

setup_application
