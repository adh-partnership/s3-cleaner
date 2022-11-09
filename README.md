# Github Action to Clean S3 Bucket

This action will clean a S3 bucket by deleting objects in it based on their creation date.

## Workflow Configuration

The following environment variables are used to configure the action.

| Key | Description | Required | Default |
| --- | --- | --- | --- |
| AWS_ACCESS_KEY_ID | The AWS access key ID | Yes | |
| AWS_REGION | The AWS region | No | us-east-1 |
| AWS_SECRET_ACCESS_KEY | The AWS secret access key | Yes | |
| AWS_S3_BUCKET | The name of the S3 bucket to clean | Yes | |
| AWS_S3_ENDPOINT | The AWS S3 endpoint, if needed | No | |
| OLDER_THAN | The number of days old an object must be to be deleted | No | 30 |

## Example Workflow

```yaml
name: Clean S3 Bucket

on:
  schedule:
    - cron: "0 0 * * *"

jobs:
  clean:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v1
      - uses: adh-partnership/s3-cleaner@main
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          AWS_S3_BUCKET: my-bucket
          OLDER_THAN: 31
```

## License

This project is distributed under the [MIT license](LICENSE.md).