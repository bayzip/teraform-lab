pipeline {
    agent any 

    stages {
        stage('Init') { 
            steps {
                sh label: '', script: 'terraform init -input=false'   
            }
        }
        stage('Plan') { 
            steps {
                sh label: '', script: 'terraform plan -out=tfplan -input=false'
            }
        }
        stage('Apply') {
            steps {
                sh label: '', script: 'terraform apply -input=false tfplan'
            }
        }

    }

    post {
        always {
            emailext attachLog: true, attachmentsPattern: 'generatedFile.txt',
            body: "${currentBuild.currentResult}: Job ${env.JOB_NAME} build ${env.BUILD_NUMBER}\n More info at: ${env.BUILD_URL}",
            recipientProviders: [developers(), requestor()],
            subject: "Jenkins Build ${currentBuild.currentResult}: Job ${env.JOB_NAME}"
            
            echo 'Clean Up Data'
            deleteDir()
        }
    }
}