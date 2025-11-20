# 필수 파일 확인 스크립트
# GitHub에서 프로젝트를 받은 후 필수 파일이 있는지 확인합니다.

Write-Host "=== 필수 파일 확인 ===" -ForegroundColor Green
Write-Host ""

$allFilesExist = $true

# 모델 파일 확인
$modelFile = "backend\weights\best_model_tuned.pt"
if (Test-Path $modelFile) {
    $size = (Get-Item $modelFile).Length / 1MB
    Write-Host "[✓] 모델 파일 존재: $modelFile ($([math]::Round($size, 2)) MB)" -ForegroundColor Green
    
    # MD5 해시 확인 (선택사항)
    try {
        $hash = (Get-FileHash -Path $modelFile -Algorithm MD5).Hash.ToLower()
        Write-Host "    MD5: $hash" -ForegroundColor Gray
        if ($hash -eq "3154e7094cf8ed2e8e93c3ae6128f364") {
            Write-Host "    [✓] 해시 일치" -ForegroundColor Green
        } else {
            Write-Host "    [⚠] 해시 불일치 (다른 버전일 수 있음)" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "    [⚠] 해시 확인 실패" -ForegroundColor Yellow
    }
} else {
    Write-Host "[✗] 모델 파일 없음: $modelFile" -ForegroundColor Red
    Write-Host "   → 반드시 추가해야 합니다!" -ForegroundColor Yellow
    Write-Host "   → 없으면 모델 성능이 거의 0% 수준입니다" -ForegroundColor Yellow
    $allFilesExist = $false
}

Write-Host ""

# Firebase 키 확인
$firebaseKey = "backend\app\core\firebase-key.json"
if (Test-Path $firebaseKey) {
    Write-Host "[✓] Firebase 키 존재: $firebaseKey" -ForegroundColor Green
    
    # JSON 파일 유효성 확인
    try {
        $json = Get-Content $firebaseKey | ConvertFrom-Json
        if ($json.type -eq "service_account") {
            Write-Host "    [✓] 유효한 Firebase 서비스 계정 키" -ForegroundColor Green
        } else {
            Write-Host "    [⚠] Firebase 키 형식이 올바르지 않을 수 있음" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "    [⚠] JSON 파일 파싱 실패" -ForegroundColor Yellow
    }
} else {
    Write-Host "[✗] Firebase 키 없음: $firebaseKey" -ForegroundColor Red
    Write-Host "   → Firebase Storage 기능이 작동하지 않습니다" -ForegroundColor Yellow
    Write-Host "   → Firebase Console에서 다운로드하거나 기존 컴퓨터에서 복사하세요" -ForegroundColor Yellow
    $allFilesExist = $false
}

Write-Host ""

# Android 키스토어 확인 (선택사항)
$keystore = "frontend\android\app\debug.keystore"
if (Test-Path $keystore) {
    Write-Host "[✓] Android 키스토어 존재: $keystore" -ForegroundColor Green
} else {
    Write-Host "[○] Android 키스토어 없음: $keystore (선택사항, 자동 생성됨)" -ForegroundColor Gray
}

Write-Host ""
Write-Host "=== 확인 완료 ===" -ForegroundColor Green

if ($allFilesExist) {
    Write-Host "[✓] 모든 필수 파일이 존재합니다!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "[✗] 일부 필수 파일이 없습니다. 위의 안내를 따라 파일을 추가하세요." -ForegroundColor Red
    Write-Host ""
    Write-Host "자세한 내용은 다음 파일을 참고하세요:" -ForegroundColor Yellow
    Write-Host "  - GITHUB_SETUP_GUIDE.md" -ForegroundColor Cyan
    Write-Host "  - MISSING_FILES_CHECKLIST.md" -ForegroundColor Cyan
    exit 1
}

