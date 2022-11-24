FROM jetbrains/teamcity-agent

ARG user=buildagent

USER root

#launch4j 32bit libs (fix for windres: No such file or directory): lib32z1 lib32ncurses5
RUN apt-get update \
&& curl -sL https://deb.nodesource.com/setup_14.x | bash - \
&& apt-get install -y lib32z1 libncurses5-dev lib32ncurses-dev chromium-browser ca-certificates nodejs yarn zip \
&& rm -rf /var/lib/apt/lists/*
RUN echo "installed nodejs version: `node --version`"

#YARN 
#RUN npm install --global yarn

#restore previous used user
USER ${user}
