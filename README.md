# docker-psql8.4
Dockerfile to build a PostgreSQL 8.4 image based on Ubuntu 10.04

# Build and run

Then you have to build an image from this repository:

docker build -t unifield:psql-8.4

Now you have to run the container. But have a look to an example of what could be done:

docker run -d --name uf-psql -p 25432:5432 -e POSTGRESQL_USER=unifield -e POSTGRESQL_PASS=unifield unifield:psql-8.4

We know that:

  * it will be run in daemon (**-d** option)
  * PostgreSQL server is accessible on the port **25432** with the user **unifield** and the password **unifield**.
  * The name of the container will be **uf-psql**
  * on our machine, we use the **unifield:psql8.4** docker base image to create this container (we built it previously)
  
And now you're running postgreSQL for Unifield.

# Manage databases

To create/delete databases, you have to connect to your PostgreSQL server like this:
  
```
createdb --host=localhost --port=25432 --user=unifield <your_database>
dropdb --host=localhost --port=25432 --user=unifield <your_database>
```

# Notes on making and using frozen databases #

Bring up the database in internal data mode, listening on port 15432:

```
docker run -p 127.0.0.1:15432:5432 \
      -e POSTGRESQL_USER=unifield -e POSTGRESQL_TRUST=YES \
      -e POSTGRESQL_DATA=/internal unifield/postgres:8.4
```

Modify .automafield.config.sh to have MY_POSTGRES_USERNAME=unifield
and MYPORT=15432. Open a new bash window. Use pct_all_instances to
confirm that you are talking to the Docker postgres. Use pct_dropall,
pct_restoreall, etc.

Get a named copy of the running image like this:

```
docker ps   # find the container name for the running DB
docker stop fun_goat
docker commit fun_goat unifield/postgres:8.4_3.0rc2
docker rm fun_goat
```

Test it by starting it:

```
docker run -p 127.0.0.1:15432:5432 \
      -e POSTGRESQL_USER=unifield -e POSTGRESQL_TRUST=YES \
      -e POSTGRESQL_DATA=/internal unifield/postgres:8.4_3.0rc2
```

The databases you loaded should still be there. Drop one with pct_drop.
Stop and re-start the unifield/postgres:8.4_3.0rc2 container. The missing
database will be brought back to life, and any updates/inserts into the
databases will be reverted.

When using docker-compose, stop and start does not revert the database.
It only stops and starts an existing container made from the image. To make
new containers from the base image with a clean database, use
docker-compose down/up.
