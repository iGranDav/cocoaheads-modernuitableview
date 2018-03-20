node {
    stage ('checkout') {
        checkout scm
    }

    stage ('gemfile') {
        wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
            bundle install
        }
    }
}