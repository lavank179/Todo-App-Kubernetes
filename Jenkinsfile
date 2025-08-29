pipeline {
  agent {
    label 'dockeragent'
  }
  stages {
    stage('Checkout') {
      sh 'echo Checking out the master branch'
    // checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: 'github_pat', url: 'https://github.com/lavank179/Todo-App-Kubernetes']])
    }
    stage('Build') {
      sh 'ls -ltr'
      sh 'cd Todo-App-Kubernetes'
      sh 'ls -a'
    }
  }
}
