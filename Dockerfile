# First stage of multi-stage build
# Installs Meteor and builds node.js version
# This stage is named 'builder'
# The data for this intermediary image is not included
# in the final image.
FROM node:9.11.1
RUN apt-get update && apt-get install -y apt-utils && apt-get update
RUN apt-get install -y \
	curl \
	g++ \
	build-essential \
  python \
  git

RUN apt-get install -y --no-install-recommends bsdtar
RUN export tar='bsdtar'
RUN npm install -g pm2

EXPOSE 3000

RUN useradd -ms /bin/bash app
USER app

WORKDIR /home/app
RUN git clone -b features/lesion_tracker_in_dev_mode git@github.com:casaper/Viewers.git

RUN export tar='bsdtar'
RUN tar --version
RUN curl https://install.meteor.com/ | sh

WORKDIR /home/app/Viewers/LesionTracker

ENV ROOT_URL=http://localhost:3000
ENV PORT=3000
ENV METEOR_PACKAGE_DIRS=/home/app/Viewers/Packages

CMD ["/home/app/.meteor/meteor", "run", "--settings=/home/app/Viewers/config/lesionTrackerDockerLocal.json"]
