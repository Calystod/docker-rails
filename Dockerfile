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

COPY --chown=${USER_UID} Gemfile* ./

RUN chgrp -R rails /usr/src/app

USER rails

RUN ls -al
RUN bundle install
COPY --chown=${USER_UID} . .

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]

USER ${USER_UID}