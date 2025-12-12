# Test signup and login flow
$signupBody = "username=testuser99&password=pass99&email=test99@test.com&fullName=Test%20User%2099"
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

$loginBody = "username=testuser99&password=pass99"
$loginResult = Invoke-WebRequest -Uri "http://localhost:8080/login" `
  -Method POST `
  -Body $loginBody `
  -UseBasicParsing `
  -TimeoutSec 10 `
  -WebSession $ws `
  -AllowRedirect $false 2>&1

Write-Output "=== LOGIN RESULT ==="
Write-Output "Status: $($loginResult.StatusCode)"
Write-Output "Location Header: $($loginResult.Headers.Location)"
Write-Output ""

if ($loginResult.StatusCode -eq 302 -and $loginResult.Headers.Location -match "dashboard") {
  Write-Output "✓ LOGIN SUCCESS - User was redirected to dashboard"
} else {
  Write-Output "✗ LOGIN FAILED - Unexpected response"
  Write-Output "Response Content (first 500 chars):"
  Write-Output $loginResult.Content.Substring(0, 500)
}
