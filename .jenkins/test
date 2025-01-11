pipeline {
    agent { 
        docker { 
            image 'instrumentisto/flutter'
            args  '-v /tmp:/tmp'
        } 
    }

    stages {
       
        stage('ANALYZE') {
            steps {
                sh 'flutter analyze'
            }
        }
        stage('TEST') {
            steps {
                sh 'flutter test'
            }
        }
        stage('BUILD') {
            steps {
                sh '''
                  #!/bin/sh
                  flutter build apk --debug
                  '''
            }
        }
        
    }
}