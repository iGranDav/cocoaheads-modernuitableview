node {
    stage ('checkout') {
        checkout scm
    }

    stage ('bundle install') {
        wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
            sh 'bundle install --path parts/gems'
        }
    }

    stage ('swiftlint') {
        wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
            sh 'bundle exec fastlane lint'
        }
    }

    stage ('prepare simulator') {
        sh 'xcrun simctl shutdown booted || true'
        sh 'xcrun simctl erase all || true'
    }

    stage ('unit testing') {
        timeout(90) {
            wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
                sh 'bundle exec fastlane unit_test'
            }
        }
    }

    stage ('publish test results') {
       step([$class: 'JUnitResultArchiver', testResults: 'fastlane/test_output/report.junit'])
    }
}