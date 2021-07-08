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

#Get variable and set env variable
ARG _POS_USER
ARG _POS_PASS
ARG _FLUKE_UID
ARG _ACCESS_TOKEN
ARG _SCRIPT_TAG
ARG _FS_KEY_ID
ARG _FS_CLI_ID
ARG _IS_LOCAL
ARG _BUILD_ID
ARG _PROJECT_ID
ARG _DATE
ENV FS_KEY_ID=$_FS_KEY_ID
ENV FS_CLI_ID=$_FS_CLI_ID

#Run robot command
RUN robot -v POS_USER:$_POS_USER -v POS_PASS:$_POS_PASS -v LINE_FLUKE_UID:$_FLUKE_UID -v LINE_ACCESS_TOKEN:$_ACCESS_TOKEN -v IS_LOCAL:$_IS_LOCAL -v BUILD_ID:$_BUILD_ID -v PROJECT_ID:$_PROJECT_ID -v INPUT_DATE:$_DATE -i $_SCRIPT_TAG Script.robot