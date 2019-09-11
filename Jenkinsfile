pipeline {
    agent {label 'provision'}

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
        		'''
            }
        }
        stage('Installation Service') {
            steps {
                ansiblePlaybook installation: 'Ansible', inventory: '${WORKSPACE}/ansible/host.inv', playbook: '${WORKSPACE}/ansible/update.yml'
            }
        }
        stage('Cleaning Workspace') {
            steps {
                cleanWs()
            }
        }
    }
}