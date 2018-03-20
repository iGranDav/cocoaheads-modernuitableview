node {
    stage ('checkout') {
        checkout scm
    }

    stage ('gemfile') {
        wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
            sh 'bundle install'
        }
    }
}