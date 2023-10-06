set +xe

chmod u+x -R ./bin/*

cp .env.example .env

docker compose build

docker compose run --rm web bin/rails db:setup
