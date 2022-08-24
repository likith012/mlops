FROM nginx:1.15.8

LABEL maintainer="Likith Reddy"

RUN rm /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/
RUN rm /etc/nginx/conf.d/default.conf
COPY proj.conf /etc/nginx/conf.d/