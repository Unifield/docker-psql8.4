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

