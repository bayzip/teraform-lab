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
        		sh label: '', script: '''chmod 400 ansible/docker.pem 
                callip=$(terraform show | grep public_ip | sed 's/"//g' | awk '{print $3}' | head -n2 | tail -n1)
                sed -i "s/AWSIP/$callip/g" ansible/host.inv
                while ! ssh -i ansible/docker.pem -o StrictHostKeyChecking=no ec2-user@$callip uname &> /dev/null
        		do
            			printf "Connection Time Out"
                        sleep 30s
        		done
                echo "Success Get Response"
        		'''
            }
        }
        stage('Installation Service') {
            steps {
                ansiblePlaybook installation: 'Ansible', inventory: '${WORKSPACE}/ansible/host.inv', playbook: '${WORKSPACE}/ansible/update.yml'
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