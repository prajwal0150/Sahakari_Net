FROM eclipse-temurin:17 AS build

WORKDIR /app

COPY . .

RUN chmod +x mvnw
RUN ./mvnw clean package -DskipTests


FROM eclipse-temurin:17

WORKDIR /app

COPY --from=build /app/target /app/target

EXPOSE 8081

CMD sh -c "java -jar $(find /app/target -name '*.jar' | head -n 1)"