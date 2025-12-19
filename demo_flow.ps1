$ErrorActionPreference = 'Stop'
$base = 'http://127.0.0.1:8000'

# Verify server health (optional)
try {
    $health = Invoke-RestMethod -Method Get -Uri ($base + '/health')
    Write-Host ("Health: " + $health.status)
} catch {
    Write-Host "Health check failed, continuing with demo..."
}

# Generate a unique demo user
$email = 'demo.user.' + (Get-Random) + '@example.com'
$pwd = 'StrongPass123!'
Write-Host ("Using email: " + $email)

# Signup
$signupBody = @{ email = $email; password = $pwd } | ConvertTo-Json
try {
    $signup = Invoke-RestMethod -Method Post -Uri ($base + '/auth/signup') -ContentType 'application/json' -Body $signupBody
    Write-Host "Signup: OK"
} catch {
    Write-Host "Signup encountered a response (possibly already exists). Continuing to login..."
}

# Login
$loginBody = @{ email = $email; password = $pwd } | ConvertTo-Json
$login = Invoke-RestMethod -Method Post -Uri ($base + '/auth/login') -ContentType 'application/json' -Body $loginBody
$token = $login.access_token
Write-Host ("Token received. Length: " + $token.Length)

# Create a task (AI-assisted priority)
$taskBody = @{ title = 'Finish quarterly report'; description = 'Compile metrics, draft summary, deliver by Friday' } | ConvertTo-Json
$create = Invoke-RestMethod -Method Post -Uri ($base + '/tasks/') -Headers @{ Authorization = "Bearer $token" } -ContentType 'application/json' -Body $taskBody
Write-Host ("Created task id: " + $create.id + ", priority: " + $create.priority)

Write-Host "Create second task..."
$taskBody2 = @{ title = 'Plan team meeting'; description = 'Schedule agenda and attendees for Monday' } | ConvertTo-Json
$create2 = Invoke-RestMethod -Method Post -Uri ($base + '/tasks/') -Headers @{ Authorization = "Bearer $token" } -ContentType 'application/json' -Body $taskBody2
Write-Host ("Created task id: " + $create2.id + ", priority: " + $create2.priority)

Write-Host "Unauthorized list (should be 401)..."
try {
    $unauth = Invoke-WebRequest -Method Get -Uri ($base + '/tasks/') -UseBasicParsing
    Write-Host ("Unexpected status: " + $unauth.StatusCode)
} catch {
    Write-Host "Unauthorized (expected)"
}

Write-Host "Authorized list of all tasks..."
$listAll = Invoke-RestMethod -Method Get -Uri ($base + '/tasks/') -Headers @{ Authorization = "Bearer $token" }
Write-Host ("Total tasks: " + $listAll.Count)
$listAll | ConvertTo-Json -Depth 5
$list | ConvertTo-Json -Depth 5