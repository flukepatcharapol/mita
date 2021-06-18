FROM alpine:latest AS alpine

#Download curl
RUN apk add curl unzip --update

# Get latest version, download, and unzip chromedriver
RUN curl -sO https://dl-ssl.google.com/linux/linux_signing_key.pub
RUN export CHROMEDRIVER_VERSION=`curl -s https://chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
    curl -sO http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip


FROM python:3.7-slim AS python

#Copy chromedriver from above stage(al) and paste to /bin
COPY --from=alpine /linux_signing_key.pub .
COPY --from=alpine /chromedriver /usr/local/bin/chromedriver

#Install thai and install google chrome stable version
RUN apt-get update && \
    apt-get install --no-install-recommends gnupg fonts-tlwg-loma fonts-tlwg-loma-otf wget -y -q
RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-key add linux_signing_key.pub && \
    apt-get update && \
    apt-get install --no-install-recommends google-chrome-stable -y -q && \
    rm linux_signing_key.pub && \
    chmod +x /usr/local/bin/chromedriver

#Copy source code dir from local to docker at /mita
COPY . /mita
WORKDIR /mita

#Install lib according to requirements list
RUN pip install -r requirements.txt

#Run robot command
ARG _POS_USER
ARG _POS_PASS
ARG _FLUKE_UID
ARG _ACCESS_TOKEN
ARG _PROJECT_ID
ARG _SCRIPT_TAG
ARG _TEST_ENV
ENV TOTOTEST=$_TEST_ENV
RUN robot -v POS_USER:$_POS_USER -v POS_PASS:$_POS_PASS -v LINE_FLUKE_UID:$_FLUKE_UID -v LINE_ACCESS_TOKEN:$_ACCESS_TOKEN -v PROJECT_ID:$_PROJECT_ID -i $_SCRIPT_TAG Script.robot