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
        		sh label: '', script: '''callip=$(terraform show | grep public_ip | sed 's/"//g' | awk '{print $3}' | head -n2 | tail -n1)
                while ! timeout 0.2 ping -c 1 -n $callip &> /dev/null
        		do
            			printf "Connection Time Out"
        		done
                echo "Success Get Response"
                sed -i "s/AWSIP/$callip/g" host.inv
        		'''
            }
        }
        stage('Installation Service') {
            steps {
                ansiblePlaybook installation: 'Ansible', inventory: '${WORKSPACE}/host.inv', playbook: '${WORKSPACE}/update.yml'
            }
        }
        stage('Remove Workspace') {
            steps {
                sh label: '', script: 'rm -rf *'
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