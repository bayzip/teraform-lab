pipeline {
    agent any 

    stages {
        stage('Provision') { 
            steps {
                sh label: '', script: 'terraform init -input=false'
                sh label: '', script: 'terraform plan -out=tfplan -input=false'   
                sh label: '', script: 'terraform apply -input=false tfplan'
            }
        }
        stage('Giving EIPs') {
            steps {
        		sh label: '', script: '''terraform show | grep public_dns | sed \'s\\"\\\\g\' | awk \'{print $3}\' > ip.tmp
                while ! timeout 0.2 ping -c 1 -n $(cat ip.tmp) &> /dev/null
        		do
            			printf "%c" "*"
        		done
                echo "Success Get Response"
                sed -i "s/AWSIP/$(cat ip.tmp)/g" host.inv'''
            }
        }
        stage('Ansible') {
            sh label: '', script: 'ansible-playbook update.yml -i host.inv'
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