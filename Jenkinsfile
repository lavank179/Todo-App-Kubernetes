stage('Checkout') {
  steps {
    sh 'echo Checking out the master branch'
  // checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: 'github_pat', url: 'https://github.com/lavank179/Todo-App-Kubernetes']])
  }
}
stage('Build') {
  environment {
    DOCKER_IMAGE = "lavank179/todo-k8s-ui:${BUILD_NUMBER}"
    REGISTRY_CREDENTIALS = credentials('docker-creds')
  }
  steps {
    script {
      sh "ls -ltr && cd frontend && docker build -t ${DOCKER_IMAGE} ."
      def dockerImage = docker.image("${DOCKER_IMAGE}")
      // docker.withRegistry('https://index.docker.io/v1/', 'docker-creds') {
      //     dockerImage.push()
      // }
      docker push ${ DOCKER_IMAGE }
      sh 'Pushed successfully!'
    }
  }
}
