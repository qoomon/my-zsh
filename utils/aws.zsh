function aws-export-credentials {
    eval "$(aws configure export-credentials --format env $@)"
}

compdef _curl curl-aws-sigv4
function curl-aws-sigv4 {
    aws-export-credentials --format env-no-export

    curl \
    --user "$AWS_ACCESS_KEY_ID:$AWS_SECRET_ACCESS_KEY" \
    --header "x-amz-security-token: $AWS_SESSION_TOKEN" \
    --aws-sigv4 "$@"
}

