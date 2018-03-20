node {
    stage ('checkout') {
        checkout scm
    }

    stage ('gemfile') {
        wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
            sh '/usr/local/bin/bundle install --path parts/gems --binstubs'
        }
    }
}