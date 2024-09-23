function aws-export-credentials {
    eval "$(aws configure export-credentials --format env $@)"
}