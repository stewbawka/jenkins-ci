# jenkins-ci
Docker in docker Jenkins container

includes vagrant file for docker host
includes docker file to build Jenkins container with docker
includes sample script to use for build step
includes script for backing up Jenkins and uploading to S3

publishing test results xml paths (for a rails project using rspec and cucumber):
spec/reports/*.xml,features/reports/*.xml
