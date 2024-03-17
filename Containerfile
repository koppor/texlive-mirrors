FROM rust:alpine as cargo-build

RUN apk update && apk add musl-dev

WORKDIR /src/app

COPY Cargo.toml Cargo.toml
RUN mkdir src && \
  echo "fn main() {panic!()}" > src/main.rs && \
  cargo build --release && \
  rm -f src/main.rs

COPY . .

RUN cargo build --release

FROM scratch

COPY --from=cargo-build /src/app/target/release/get-tl-mirror-status .

USER 1000:1000
CMD ["./get-tl-mirror-status"]
