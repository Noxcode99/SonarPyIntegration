# FROM  tiangolo/uwsgi-nginx-flask:python3.8 
# COPY . /app
# WORKDIR /app
# #RUN git clone https://github.com/kstathou/vector_engine
# RUN pip3 install -r requirements.txt
# EXPOSE 8000
# ENTRYPOINT [ "python3"] 
# CMD [ "-u","app.py" ]

FROM  tiangolo/uwsgi-nginx-flask:python3.8 
ENV SONAR_HOST_URL=https://sonarqube.qritrim.com
ENV SONAR_TOKEN=sqp_9604b8f4c2fb78d93cf5617c5a5efe32340400ea

ENV SONAR_SCANNER_VERSION=4.7.0.2747

WORKDIR /root

RUN apt-get update
RUN apt-get install -y wget unzip
RUN wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-$SONAR_SCANNER_VERSION-linux.zip
RUN unzip sonar-scanner-cli-$SONAR_SCANNER_VERSION-linux.zip
RUN rm sonar-scanner-cli-$SONAR_SCANNER_VERSION-linux.zip
RUN ln -s sonar-scanner-$SONAR_SCANNER_VERSION-linux/ sonar-scanner

RUN apt-get purge -y --auto-remove unzip \
    && rm -rf /var/lib/apt/lists/*

ENV PATH="/root/sonar-scanner/bin:${PATH}"

COPY . /app
WORKDIR /app 
RUN pip3 install -r requirements.txt

RUN sonar-scanner \
    -Dsonar.projectKey=shivam  \
    -Dsonar.sources=. \
    -Dsonar.host.url=https://sonarqube.qritrim.com \
    -Dsonar.login=sqp_201683bce83ad1835308ef80d73e9d3bc3334872



EXPOSE 8000
ENTRYPOINT [ "python3"]   
CMD [ "-u","app.py" ]
