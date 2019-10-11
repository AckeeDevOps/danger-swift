FROM swift:4.2

ARG SWIFT_LINT_VERSION=0.32.0
ARG DANGER_SWIFT_VERSION=2.0.6

RUN apt-get update && apt-get install -y curl

RUN curl -sL https://deb.nodesource.com/setup_10.x |  bash - && \
  apt-get install -y nodejs && \
  npm install -g yarn && \
  npm install -g danger

RUN git clone -b $SWIFT_LINT_VERSION --single-branch --depth 1 https://github.com/realm/SwiftLint.git SwiftLint && \
  cd SwiftLint && git submodule update --init --recursive; make install

RUN git clone -b $DANGER_SWIFT_VERSION --single-branch --depth 1 https://github.com/danger/danger-swift danger-swift && \
  cd danger-swift && make install

ENTRYPOINT ["danger-swift", "ci", "--failOnErrors"]
