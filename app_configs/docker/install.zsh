SELF_DIR="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"
cd "$SELF_DIR"
cp -i config.json $HOME/.docker/config.json
