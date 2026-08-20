# Miniflux Cloud Platform

Infrastructure and CI/CD for deploying and operating a personal [Miniflux](https://github.com/miniflux/v2) instance.

I'm starting with GCP and will expand to AWS and Azure as the project develops.

The goal of this project is to explore and demonstrate practical systems engineering practices around infrastructure, automation, security, and reliability using a real open-source application.

In order to be gentle to my wallet, I am using Supabase as a Postgres Host instead of a full on CloudSQL implementation. There are drawbacks like a lack of snapshotting, and lack of Google IAM Authentication, but I am proficient in GCP CloudSQL administration.

## Pre-productionalization notes

- check .gitignore for hidden files required
- gcp/terraform.tfvars will all move to google secrets