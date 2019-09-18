FROM swift:5.0.1

ARG SWIFT_LINT_VERSION=0.32.0
ARG DANGER_SWIFT_VERSION=2.0.4

# workaround for broken packages, see https://github.com/apple/swift-docker/issues/139
RUN rm -r /usr/lib/python2.7/site-packages

RUN apt-get update && apt-get install -y curl

RUN curl -sL https://deb.nodesource.com/setup_10.x |  bash - && \
  apt-get install -y nodejs && \
  npm install -g yarn && \
  npm install -g danger

RUN git clone -b $SWIFT_LINT_VERSION --single-branch --depth 1 https://github.com/realm/SwiftLint.git SwiftLint && \
  cd SwiftLint && git submodule update --init --recursive; make install

RUN git clone -b $DANGER_SWIFT_VERSION --single-branch --depth 1 https://github.com/danger/danger-swift.git danger-swift && \
  cd danger-swift && make install

ENTRYPOINT ["swift", "run", "danger-swift", "ci"]
