pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Frontend') {
            steps {
                echo 'Building frontend application...'
                dir('frontend/ConsoleApp1') {
                    bat 'dotnet build --configuration Release'
                }
            }
        }

        stage('Security Scan') {
            steps {
                echo 'Running security vulnerability scan...'
                dir('frontend/ConsoleApp1') {
                    // Scan for vulnerable NuGet packages
                    bat 'dotnet list package --vulnerable --include-transitive'
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
        success {
            echo 'Build and security scan completed successfully!'
        }
        failure {
            echo 'Build or security scan failed!'
        }
    }
}
