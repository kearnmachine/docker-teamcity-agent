FROM jetbrains/teamcity-agent

ARG user=buildagent

USER root

#launch4j 32bit libs (fix for windres: No such file or directory): lib32z1 lib32ncurses5
RUN apt-get update \
&& curl -sL https://deb.nodesource.com/setup_14.x | bash - \
&& apt-get install -y lib32z1 lib32ncurses5 chromium ca-certificates nodejs zip \
&& rm -rf /var/lib/apt/lists/*
RUN echo "installed nodejs version: `node --version`"

#YARN (from _/node dockerfile)
ENV YARN_VERSION 1.22.5
ENV YARN_KEY 6D98490C6F1ACDDD448E45954F77679369475BAA

RUN gpg --recv-keys $YARN_KEY \
  && curl -fSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
  && curl -fSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" \
  && gpg --batch --verify yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  && mkdir -p /opt \
  && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
  && rm -rf /usr/local/bin/yarn /usr/local/bin/yarnpkg \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
  && rm yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz
                                                       
#restore previous used user for jenkins image
USER ${user}
