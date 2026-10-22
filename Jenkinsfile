// Jenkinsfile voor cicd-sample-app (stap 1.7 + ⭐ auto-deploy)
// Zelfde pipeline als 1.6 (scripted), plus pollSCM-trigger.

// ⭐ CD: Jenkins checkt elke ~2 min of er nieuwe commits op main zijn.
// Waarom pollen i.p.v. GitHub-webhook? GitHub kan 172.16.0.10 (privé host-only
// netwerk) niet bereiken, dus Jenkins moet zelf gaan kijken.
// LET OP: trigger wordt pas actief na de EERSTE manuele run van deze pipeline.
properties([
    pipelineTriggers([
        pollSCM('H/2 * * * *')
    ])
])

node {
    stage('Checkout') {
        // NODIG voor pollSCM: Jenkins pollt enkel repo's die in de vorige
        // build via een checkout-stap zijn uitgecheckt. Een scripted pipeline
        // doet dat niet automatisch (en "Lightweight checkout" haalt enkel
        // de Jenkinsfile op, dat telt niet mee).
        checkout scm
    }
    stage('Preparation') {
        // catchError: als de container niet bestaat, faalt de build niet
        catchError(buildResult: 'SUCCESS') {
            sh 'docker stop samplerunning'
            sh 'docker rm samplerunning'
        }
    }
    stage('Build') {
        build 'BuildSampleApp'
    }
    stage('Results') {
        build 'TestSampleApp'
    }
}
