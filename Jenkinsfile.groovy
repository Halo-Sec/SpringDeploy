pipeline {
  agent {
      label 'agent1'
    }

  environment {
    AWS_EB_APP_NAME = 'springbootapp-${BUILD_NUMBER}'
    AWS_EB_ENV_NAME = 'springbootapp-env-${BUILD_NUMBER}'
    AWS_REGION = 'us-east-1'
  }
  triggers {
    pollSCM('*/1 * * * *')
  }

  stages {
    stage('checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build and test') {
      steps{
        sh 'mvn clean package'
        sh 'mvn test'
        sh 'zip archive.zip Dockerfile target/react-and-spring-data-rest-0.0.1-SNAPSHOT.jar'
      }
    }


    stage('Deploy') {
      steps {
        script {
          docker.image('chriscamicas/awscli-awsebcli').inside {
            withAWS(credentials: 'aws-credentials') {
              stage('prepare environment') {
                echo "Executing: eb init ${AWS_EB_APP_NAME} --keyname 'Spring' --platform '64bit Amazon Linux 2 v3.6.0 running Docker' --region ${AWS_REGION}"
                sh "eb init ${AWS_EB_APP_NAME} --keyname 'Spring' --platform '64bit Amazon Linux 2 v3.6.0 running Docker' --region ${AWS_REGION}"
                echo "Executing: eb create ${AWS_EB_ENV_NAME} --cname ${AWS_EB_ENV_NAME}-${BUILD_NUMBER} --instance-type t2.micro --platform '64bit Amazon Linux 2 v3.6.0 running Docker'"
                sh "eb create ${AWS_EB_ENV_NAME} --cname ${AWS_EB_ENV_NAME}-${BUILD_NUMBER} --instance_type t2.micro --platform '64bit Amazon Linux 2 v3.6.0 running Docker'"
              }

              stage('deployment') {
                echo "Executing: eb deploy --label 'version ${BUILD_NUMBER}'"
                sh "eb deploy --label 'version ${BUILD_NUMBER}'"
                echo 'Executing: eb status'
                sh 'eb status'
              }
            }
          }
        }
      }
    }
  }
}