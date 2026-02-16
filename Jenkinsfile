pipeline {
    agent any

    tools {
        maven 'Maven'
        jdk 'JDK17'
    }

    stages {
        stage('Checkout Source Code') {
            steps {
                git url: 'https://github.com/moezounis/devops_project.git'
            }
        }

        stage('Run Unit Tests') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Build Package') {
            steps {
                sh 'mvn package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                // Construction de l'image avec le tag latest et le numéro de build
                sh "docker build -t student-management:${env.BUILD_NUMBER} -t student-management:latest ."
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    // 'docker-hub-credentials' est l'ID que tu as créé dans Jenkins
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        
                        // Connexion sécurisée
                        sh "echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin"
                        
                        // On tague l'image pour Docker Hub (Format: utilisateur/nom-image:tag)
                        sh "docker tag student-management:latest ${DOCKER_USERNAME}/student-management:latest"
                        sh "docker tag student-management:latest ${DOCKER_USERNAME}/student-management:${env.BUILD_NUMBER}"
                        
                        // Envoi vers le registre
                        sh "docker push ${DOCKER_USERNAME}/student-management:latest"
                        sh "docker push ${DOCKER_USERNAME}/student-management:${env.BUILD_NUMBER}"
                    }
                }
            }
        }
    }

    post {
        failure {
            emailext(
                subject: "❌ Jenkins Build Failed - ${env.JOB_NAME}",
                body: """
                BUILD FAILED ❌

                Job: ${env.JOB_NAME}
                Build Number: ${env.BUILD_NUMBER}

                Console Output:
                ${env.BUILD_URL}
                """,
                to: "ounis.moez98@gmail.com"
            )
        }
    }
}