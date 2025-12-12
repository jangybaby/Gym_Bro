# Test signup and login flow
$signupBody = "username=testuser999&password=pass999&email=test999@test.com&fullName=Test%20User%20999"
$result = Invoke-WebRequest -Uri "http://localhost:8080/signup" `
  -Method POST `
  -Body $signupBody `
  -UseBasicParsing `
  -TimeoutSec 10 `
  -SessionVariable ws 2>&1

Write-Output "=== SIGNUP RESULT ==="
Write-Output "Status: $($result.StatusCode)"
Write-Output ""

Start-Sleep -Seconds 2

$loginBody = "username=testuser999&password=pass999"
$loginResult = Invoke-WebRequest -Uri "http://localhost:8080/login" `
  -Method POST `
  -Body $loginBody `
  -UseBasicParsing `
  -TimeoutSec 10 `
  -WebSession $ws `
  -MaximumRedirection 0 2>&1

Write-Output "=== LOGIN RESULT ==="
Write-Output "Status: $($loginResult.StatusCode)"
Write-Output "Location Header: $($loginResult.Headers.Location)"
Write-Output ""

if ($loginResult.StatusCode -eq 302 -and $loginResult.Headers.Location -match "dashboard") {
  Write-Output "SUCCESS - User was redirected to dashboard"
  Write-Output ""
  Write-Output "=== VERIFYING DASHBOARD ACCESS ==="
  
  # Follow the redirect to dashboard using the same session
  $dashboardResult = Invoke-WebRequest -Uri "http://localhost:8080/dashboard" `
    -Method GET `
    -UseBasicParsing `
    -TimeoutSec 10 `
    -WebSession $ws 2>&1
  
  Write-Output "Dashboard Status: $($dashboardResult.StatusCode)"
  if ($dashboardResult.StatusCode -eq 200) {
    Write-Output "VERIFIED - Dashboard is accessible with authenticated session"
    Write-Output "Dashboard content length: $($dashboardResult.Content.Length) bytes"
  }
} else {
  Write-Output "FAILED - Unexpected response"
  Write-Output "Response Content (first 500 chars):"
  if ($loginResult.Content.Length -gt 500) {
    Write-Output $loginResult.Content.Substring(0, 500)
  } else {
    Write-Output $loginResult.Content
  }
}
