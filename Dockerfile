# This Dockerfile is merely used to generate binaries for direct use during
# buildpack runtime.

FROM heroku/cedar

RUN curl -sL https://deb.nodesource.com/setup_11.x | bash
RUN apt-get install -y nodejs
ENV PATH /app/bin:$PATH
WORKDIR /tmp


# Install Elm
ENV ELM_VERSION 0.19.0

RUN npm install -g elm@${ELM_VERSION} --unsafe-perm=true --allow-root
RUN mkdir -p /app/.profile.d /app/bin
RUN cp /usr/lib/node_modules/elm/bin/* /app/bin

# Startup scripts for heroku
RUN echo "export PATH=\"/app/bin:\$PATH\"" > /app/.profile.d/appbin.sh
RUN echo "cd /app" >> /app/.profile.d/appbin.sh

# AWS upload script
RUN apt-get -y install python-pip
RUN pip install awscli
ADD upload-to-s3.sh /app/bin/
