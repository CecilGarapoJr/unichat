FROM ubuntu:22.04

RUN apt-get update && apt-get install -y curl

WORKDIR /app

COPY . .

RUN curl -fsSL https://get.nixpacks.com/install.sh | bash

EXPOSE 3000

CMD ["nixpacks", "start"]
