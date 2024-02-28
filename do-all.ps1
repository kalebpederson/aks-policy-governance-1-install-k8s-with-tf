# make sure that terraform is available in the path
if (-not (test-path terraform))
{
  Write-Error "Terraform is not installed or not in the path."
  exit 1
}

# get the project name from the first argument if .local.tfvars does not exist
if (-not (test-path .local.tfvars))
{
  Write-Error "Create a .local.tfvars file specifying the project name prior to executing."
  exit 2
}

if (-not (test-path .terraform))
{
  Write-Host "Initializing Terraform"
  terraform init
  if ($? -ne $true)
  {
    Write-Error "ERROR: 'terraform init' failed."
    exit 3
  }
}
else
{
  Write-Host "Terraform already initialized"
}

Write-Host "Creating Terraform plan"
terraform plan -var-file=".local.tfvars" -out=".tfplan"
if ($? -ne $true)
{
  Write-Error "ERROR: 'terraform plan -var-file=`".local.tfvars`" -out=`".tfplan`"' failed."
  exit 4
}

Write-Host "Applying Terraform plan"
terraform apply -auto-approve .tfplan
if ($? -ne $true)
{
  Write-Error "ERROR: 'terraform apply -auto-approve -out=.tfplan' failed."
  exit 5
}

Write-Host "Getting project name from .local.tfvars"
$slsResult = sls -Pattern 'project_name\s*=\s*"([^"]+)"' .local.tfvars -Context 0
if ($slsResult.Matches.Count -eq 0)
{
  Write-Error "Unable to find project_name in .local.tfvars"
  exit 6
}
else
{
  $projectName = $slsResult.Matches[0].Groups[1].Value
  Write-Host "Found AKS cluster $($projectName)-aks"
}

Write-Host "Getting aks credentials for project '$projectName'"
az aks get-credentials --name "$($projectName)-aks" --resource-group "$($projectName)-rg"
if ($? -ne $true)
{
  Write-Error "ERROR: 'az aks get-credentials --name `"$($projectName)-aks`" --resource-group `"$($projectName)-rg`"' failed."
  exit 7
}