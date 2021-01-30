## Use to run mysql db docker image
docker run --name mysqldb -p 3307:3306 -e MYSQL_DATABASE=pageviewservice -e MYSQL_ALLOW_EMPTY_PASSWORD=yes -d mysql:5.7

## Use to run RabbitMQ
docker run --name rabbitmq -p 5671:5671 -p 5672:5672 -d rabbitmq

## does not work
#docker run --name pageviewservice -p 8081:8081  springframeworkguru/pageviewservice

## does not work
#docker run --name pageviewservice -p 8081:8081 -e SPRING_DATASOURCE_URL=jdbc:mysql://127.0.0.1:3306/pageviewservice -e SPRING_PROFILES_ACTIVE=mysql springframeworkguru/pageviewservice

docker run --name pageviewservice -p 8081:8081 -d \
--link rabbitmq:rabbitmq \
--link mysqldb:mysqldb \
-e SPRING_DATASOURCE_URL=jdbc:mysql://mysqldb:3306/pageviewservice \
-e SPRING_PROFILES_ACTIVE=mysql  \
-e SPRING_RABBITMQ_HOST=rabbitmq \
springframeworkguru/pageviewservice

# Using Maven for CI Builds
mvn clean verify docker:push

