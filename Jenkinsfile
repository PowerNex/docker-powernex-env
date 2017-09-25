pipeline {
  agent any
  stages {
    stage('build') {
      steps {
				script {
					if (env.JOB_NAME.endsWith("_pull-requests"))
						setGitHubPullRequestStatus state: 'PENDING', context: "${env.JOB_NAME}", message: "Building Docker image"
				}
				ansiColor('xterm') {
					sh 'docker build -t "wild/powernex-env" --no-cache --pull .'
				}
      }
    }

    stage('deploy') {
      steps {
				script {
					if (env.JOB_NAME.endsWith("_pull-requests"))
						setGitHubPullRequestStatus state: 'PENDING', context: "${env.JOB_NAME}", message: "Publishing Docker image"
				}
				ansiColor('xterm') {
					sh 'docker push "wild/powernex-env"'
				}
      }
    }
  }

  post {
    success {
			script {
				if (env.JOB_NAME.endsWith("_pull-requests"))
					setGitHubPullRequestStatus state: 'SUCCESS', context: "${env.JOB_NAME}", message: "Docker image building successed"
			}
    }
		failure {
			script {
				if (env.JOB_NAME.endsWith("_pull-requests"))
					setGitHubPullRequestStatus state: 'FAILURE', context: "${env.JOB_NAME}", message: "Docker image building successed"
			}
		}
  }
}
