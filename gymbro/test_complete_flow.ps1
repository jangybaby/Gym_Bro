# More robust test that properly handles cookies and redirects
$cookieJar = New-Object System.Net.CookieContainer
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$session.Cookies = $cookieJar

Write-Output "=== STEP 1: SIGNUP ==="
$signupBody = "username=finaltest`&password=finaltest123`&email=finaltest@test.com`&fullName=Final%20Test"
$signupResult = Invoke-WebRequest -Uri "http://localhost:8080/signup" `
  -Method POST `
  -Body $signupBody `
  -UseBasicParsing `
  -TimeoutSec 10 `
  -WebSession $session

Write-Output "Signup Status: $($signupResult.StatusCode)"
if ($signupResult.StatusCode -eq 200) {
  Write-Output "User created successfully"
}

Start-Sleep -Seconds 2

Write-Output ""
Write-Output "=== STEP 2: LOGIN ==="
$loginBody = "username=finaltest`&password=finaltest123"
$loginResult = Invoke-WebRequest -Uri "http://localhost:8080/login" `
  -Method POST `
  -Body $loginBody `
  -UseBasicParsing `
  -TimeoutSec 10 `
  -WebSession $session `
  -MaximumRedirection 0

Write-Output "Login Status: $($loginResult.StatusCode)"
Write-Output "Redirect Location: $($loginResult.Headers.Location)"

if ($loginResult.StatusCode -eq 302) {
  Write-Output "Login successful, redirected to dashboard"
  
  Write-Output ""
  Write-Output "=== STEP 3: VERIFY SESSION & ACCESS DASHBOARD ==="
  Write-Output "Cookies in session:"
  $cookies = $session.Cookies.GetCookies("http://localhost:8080")
  foreach ($cookie in $cookies) { 
    Write-Output "  - $($cookie.Name): [cookie value]" 
  }
  
  Start-Sleep -Seconds 1
  
  $dashboardResult = $null
  try {
    $dashboardResult = Invoke-WebRequest -Uri "http://localhost:8080/dashboard" `
      -Method GET `
      -UseBasicParsing `
      -TimeoutSec 10 `
      -WebSession $session -ErrorAction Stop
    
    Write-Output "Dashboard Status: $($dashboardResult.StatusCode)"
    Write-Output "Dashboard is accessible - FULL LOGIN FLOW SUCCESS!"
  } catch {
    $statusCode = $_.Exception.Response.StatusCode
    Write-Output "Dashboard access failed with status: $statusCode"
    if ($statusCode -eq 403) {
      Write-Output "Session not recognized (403 Forbidden)"
    }
  }
} else {
  Write-Output "Login failed with status $($loginResult.StatusCode)"
}
