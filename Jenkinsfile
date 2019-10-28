pipeline {
  agent {
    label 'jenkins-slave'
  }
  options {
    timeout(time: 1, unit: "HOURS")
    buildDiscarder(logRotator(numToKeepStr: "5"))
  }

  stages {
    stage("Formatting") {
      steps {
        sh "terraform fmt -list=true -check=true"
      }
    }
    stage("Terraform Init") {
      steps {
        sh "terraform init -input=false"
      }
    }

    stage("Terraform Validate") {
      steps {
        sh "terraform validate"
      }
    }
    stage("Fetch Vault token") {
      steps {
        withAWS(role:'XXXXXXXX', roleAccount:'XXXXXXX', roleSessionName: 'XXXXXXX',region:'eu-west-1') {
          sh """
          ./scripts/fetch-vault-token.sh
          """
        }
      }
    }

    stage("Terraform Plan") {
      steps {
        withCredentials([usernamePassword(credentialsId: 'XXXXXXXX', passwordVariable: 'XXXXXX', usernameVariable: 'XXXXXXX')]) {
          sh """terraform plan \
          -var vault_token=\$(cat vault_token.txt) \
          -input=false -out=plan.out"""
          stash name: 'plan', includes: 'plan.out'
        }
      }
    }

    // Confirmation
    stage("Confirm deploy to Master") {
      when {
        branch "master"
      }
      steps {
        milestone(ordinal: 1, label: "BEFORE_TEST_CONFIRM_MILESTONE")
        input message: 'Deploy this plan to Dev?'
        milestone(ordinal: 2, label: "AFTER_TEST_CONFIRM_MILESTONE")
      }
    }

    stage("Terraform Apply") {
      when {
        branch "master"
      }
      steps {
        unstash 'plan'
        sh "terraform apply plan.out"
      }
    }
  }
  post{
    cleanup{
      deleteDir()
    }
  }
}
