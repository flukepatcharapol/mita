FROM alpine:latest AS dl

COPY . /app

WORKDIR /app

RUN apk add curl unzip --update

RUN curl -sO https://dl-ssl.google.com/linux/linux_signing_key.pub
RUN export CHROMEDRIVER_VERSION=`curl -s https://chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
    curl -sO http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip

FROM python:3.7-slim

COPY --from=dl /linux_signing_key.pub .
COPY --from=dl /chromedriver /usr/local/bin/chromedriver

RUN apt-get update && \
    apt-get install --no-install-recommends gnupg fonts-tlwg-loma fonts-tlwg-loma-otf -y -q

RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-key add linux_signing_key.pub && \
    apt-get update && \
    apt-get install --no-install-recommends google-chrome-stable -y -q && \
    rm linux_signing_key.pub && \
    chmod +x /usr/local/bin/chromedriver

RUN pip -r install requirements.txt

RUN python3 -m robot -i test-connect Script.robot