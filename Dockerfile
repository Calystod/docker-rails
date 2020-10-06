FROM ruby:2.7

ARG USER_UID=1000

RUN curl https://deb.nodesource.com/setup_12.x | bash
RUN curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client nodejs yarn \
    && rm -rf /var/lib/apt/lists/*

RUN useradd --uid ${USER_UID} --create-home rails

WORKDIR /usr/src/app

RUN chgrp -R rails /usr/src/app
RUN chmod 775 /usr/src/app

COPY entrypoint.sh /entrypoint.sh
RUN chmod 0755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

WORKDIR /usr/src/app2

RUN chgrp -R rails /usr/src/app2
RUN chmod 775 /usr/src/app2

USER rails
RUN if [ ! -f Gemfile ]; then bundle init && bundle add rails && rails new .; fi

RUN bundle install

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]

USER ${USER_UID}