pipeline {
    agent any

    environment {
        TF_VERSION = '1.7.5'
        AZURE_SERVICE_CONNECTION = 'azure-service-principal'
        RESOURCE_GROUP = 'AzureclassAssignThu'
        LOCATION = 'eastus'
        SUBSCRIPTION_ID = 'a98d0e19-0c0e-4a5b-91ac-c6923c6331bc'
        APP_SERVICE_PLAN = 'jenkins-app-service-plan'
        APP_SERVICE_WEBAPP_DOTNET = 'jenkins-yd-webapp'
    }

    stages {

        stage('Azure Login') {
            steps {
                withCredentials([azureServicePrincipal(
                    credentialsId: "${env.AZURE_SERVICE_CONNECTION}",
                    subscriptionIdVariable: 'SUB_ID',
                    clientIdVariable: 'CLIENT_ID',
                    clientSecretVariable: 'CLIENT_SECRET',
                    tenantIdVariable: 'TENANT_ID'
                )]) {
                    bat """
                        echo Logging into Azure...
                        az login --service-principal -u %CLIENT_ID% -p %CLIENT_SECRET% --tenant %TENANT_ID%
                        az account set --subscription %SUB_ID%
                    """
                }
            }
        }

        stage('Terraform Init') {
            steps {
                bat 'terraform init'
            }
        }

        stage('Terraform Import Existing Resources') {
            steps {
                bat """
                    terraform import azurerm_resource_group.rg /subscriptions/${env.SUBSCRIPTION_ID}/resourceGroups/${env.RESOURCE_GROUP} || echo Already Managed
                    terraform import azurerm_service_plan.asp /subscriptions/${env.SUBSCRIPTION_ID}/resourceGroups/${env.RESOURCE_GROUP}/providers/Microsoft.Web/serverFarms/${env.APP_SERVICE_PLAN} || echo Already Managed
                    terraform import azurerm_linux_web_app.webapp /subscriptions/${env.SUBSCRIPTION_ID}/resourceGroups/${env.RESOURCE_GROUP}/providers/Microsoft.Web/sites/${env.APP_SERVICE_WEBAPP_DOTNET} || echo Already Managed
                """
            }
        }

        stage('Terraform Plan') {
            steps {
                bat 'terraform plan'
            }
        }

        stage('Terraform Apply - Auto') {
            steps {
                bat 'terraform apply -auto-approve'
            }
        }

        stage('Build .NET 8 Web API') {
            steps {
                bat """
                    echo Building .NET Project...
                    dotnet build
                """
            }
        }

        stage('Publish .NET Project') {
            steps {
                bat """
                    echo Publishing .NET Project...
                    dotnet publish -c Release -o publish_output
                """
            }
        }

        stage('Deploy to Azure App Service') {
            steps {
                bat """
                    echo Deploying to Azure...
                    az webapp deploy --resource-group ${env.RESOURCE_GROUP} --name ${env.APP_SERVICE_WEBAPP_DOTNET} --src-path publish_output
                """
            }
        }
    }

    post {
        always {
            script {
                echo "Killing any running terraform.exe..."
                try {
                    bat 'taskkill /F /IM terraform.exe'
                } catch (err) {
                    echo "terraform.exe was not running."
                }
            }

            bat """
                echo Logging out from Azure...
                az logout
            """

            cleanWs(deleteDirs: true, disableDeferredWipeout: true)
        }
    }
}
