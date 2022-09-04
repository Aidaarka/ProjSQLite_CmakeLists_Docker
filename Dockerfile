
FROM gcc:latest as build


# Скопируем директорию /src в контейнер
ADD ./src /app/src

RUN apt-get update \
   && apt-get install -y cmake 


# Установим рабочую директорию для сборки проекта
WORKDIR /app/src


# Выполним сборку нашего проекта
RUN cmake ../src \
    && cmake --build .
    
# Запуск ---------------------------------------

# В качестве базового образа используем ubuntu:latest
FROM debian:latest


# Установим рабочую директорию нашего приложения
WORKDIR /app

RUN apt-get update \
   && apt-get -y --no-install-recommends install \
   libreadline8 \
   build-essential \
   cmake
   

# Скопируем приложение со сборочного контейнера в рабочую директорию
COPY --from=build /app/src/sqlite .

# Установим точку входа
ENTRYPOINT ["./sqlite"]
