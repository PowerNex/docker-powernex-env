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
        	sh 'docker build -t "wild/powernex-env" .'
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

		stage('archive') {
			steps {
				node("worker") {
					withDockerContainer("wild/powernex-env") {
						sh """
						cd /opt/cc
						tar -cvfJ powernex-env.tar.xz *
						"""
						stash "powernex-env" "/opt/cc/powernex-env.tar.xz"
					}
				}
				unstash "powernex-env"
				archiveArtifacts artifacts: 'powernex-env.tar.xz', fingerprint: true
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
