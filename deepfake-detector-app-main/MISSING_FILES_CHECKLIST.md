# GitHub에 올라가지 않는 필수 파일 체크리스트

이 문서는 GitHub 저장소에서 프로젝트를 받은 후 **반드시 수동으로 추가해야 하는 파일**을 정리한 것입니다.

## 🔴 필수 파일 (없으면 작동하지 않음)

### 1. 모델 가중치 파일

**파일명**: `best_model_tuned.pt`  
**위치**: `backend/weights/best_model_tuned.pt`  
**크기**: 약 3.32 MB  
**MD5 해시**: `3154e7094cf8ed2e8e93c3ae6128f364`

**설명**:
- MesoNet 딥페이크 탐지 모델의 학습된 가중치
- **없으면 모델이 랜덤 가중치로 초기화되어 탐지 성능이 거의 0% 수준**

**확인 방법**:
```bash
cd backend/weights
dir best_model_tuned.pt
certutil -hashfile best_model_tuned.pt MD5
```

**추가 방법**:
1. 기존 컴퓨터에서 파일 복사
2. USB 또는 클라우드 스토리지로 전송
3. 새 컴퓨터의 `backend/weights/` 폴더에 붙여넣기

---

### 2. Firebase 서비스 계정 키

**파일명**: `firebase-key.json` 또는 `serviceAccountKey.json`  
**위치**: `backend/app/core/firebase-key.json`  
**크기**: 약 2-3 KB

**설명**:
- Firebase Storage에 영상 파일을 업로드하기 위한 인증 키
- **없으면 Firebase Storage 기능이 작동하지 않음**

**확인 방법**:
```bash
cd backend/app/core
dir firebase-key.json
```

**추가 방법**:

**방법 1: Firebase Console에서 다운로드**
1. https://console.firebase.google.com 접속
2. 프로젝트 선택 (deepfake-fc59d)
3. 프로젝트 설정 → 서비스 계정 탭
4. "새 비공개 키 생성" 클릭
5. 다운로드한 JSON 파일을 `backend/app/core/firebase-key.json`으로 저장

**방법 2: 기존 컴퓨터에서 복사**
```bash
# 기존 컴퓨터에서
copy backend\app\core\firebase-key.json [전송 경로]

# 새 컴퓨터에서
copy [전송 경로]\firebase-key.json backend\app\core\firebase-key.json
```

**파일 내용 예시** (일부):
```json
{
  "type": "service_account",
  "project_id": "deepfake-fc59d",
  "private_key_id": "...",
  "private_key": "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n",
  "client_email": "...",
  "client_id": "...",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  ...
}
```

---

## 🟡 선택적 파일 (없어도 작동하지만 권장)

### 3. Android 서명 키

**파일명**: `debug.keystore`  
**위치**: `frontend/android/app/debug.keystore`  
**크기**: 약 1-2 KB

**설명**:
- Android 앱 서명에 사용되는 키스토어
- **없으면 자동으로 생성되지만, 기존 앱과 호환되지 않을 수 있음**

**확인 방법**:
```bash
cd frontend/android/app
dir debug.keystore
```

**추가 방법**:
- 개발 환경에서는 자동 생성 가능
- 프로덕션 빌드 시에는 기존 키를 사용해야 함

---

## 📋 전체 체크리스트

프로젝트를 받은 후 다음을 확인하세요:

### 백엔드 파일
- [ ] `backend/weights/best_model_tuned.pt` 존재
- [ ] `backend/app/core/firebase-key.json` 존재
- [ ] `backend/requirements.txt` 확인
- [ ] Python 가상 환경 생성 완료
- [ ] `pip install -r requirements.txt` 실행 완료

### 프론트엔드 파일
- [ ] `frontend/package.json` 확인
- [ ] `npm install` 실행 완료
- [ ] `frontend/android/app/debug.keystore` (선택사항)

### 설정 확인
- [ ] 백엔드 서버 정상 실행 (`http://localhost:8000`)
- [ ] 모델 로딩 성공 (서버 로그 확인)
- [ ] Firebase 연결 성공 (서버 로그 확인)

---

## 🔍 파일 확인 스크립트

다음 PowerShell 스크립트로 필수 파일 존재 여부를 확인할 수 있습니다:

```powershell
# check_required_files.ps1
Write-Host "=== 필수 파일 확인 ===" -ForegroundColor Green

# 모델 파일 확인
$modelFile = "backend\weights\best_model_tuned.pt"
if (Test-Path $modelFile) {
    $size = (Get-Item $modelFile).Length / 1MB
    Write-Host "[✓] 모델 파일 존재: $modelFile ($([math]::Round($size, 2)) MB)" -ForegroundColor Green
} else {
    Write-Host "[✗] 모델 파일 없음: $modelFile" -ForegroundColor Red
    Write-Host "   → 반드시 추가해야 합니다!" -ForegroundColor Yellow
}

# Firebase 키 확인
$firebaseKey = "backend\app\core\firebase-key.json"
if (Test-Path $firebaseKey) {
    Write-Host "[✓] Firebase 키 존재: $firebaseKey" -ForegroundColor Green
} else {
    Write-Host "[✗] Firebase 키 없음: $firebaseKey" -ForegroundColor Red
    Write-Host "   → Firebase Storage 기능이 작동하지 않습니다" -ForegroundColor Yellow
}

Write-Host "`n=== 확인 완료 ===" -ForegroundColor Green
```

**사용 방법**:
```bash
powershell -ExecutionPolicy Bypass -File check_required_files.ps1
```

---

## ⚠️ 주의사항

### 보안
- **모델 파일과 Firebase 키는 절대 GitHub에 커밋하지 마세요**
- `.gitignore`에 의해 자동으로 제외되지만, 수동으로 추가하지 않도록 주의
- 파일을 공유할 때는 안전한 방법 사용 (암호화, 비밀번호 보호 등)

### 성능
- 모델 파일 없이 실행하면 탐지 성능이 거의 0% 수준
- 반드시 `best_model_tuned.pt` 파일을 추가해야 정상 작동

### 호환성
- 모델 파일은 특정 PyTorch 버전과 호환될 수 있음
- `requirements.txt`에 명시된 버전 사용 권장

---

## 📞 문제 해결

### 모델 파일을 찾을 수 없음
- 파일 경로 확인: `backend/weights/best_model_tuned.pt`
- 파일 이름 확인 (대소문자 구분)
- 파일 권한 확인 (읽기 가능한지)

### Firebase 키 오류
- JSON 파일 형식 확인
- 파일 경로 확인: `backend/app/core/firebase-key.json`
- Firebase 프로젝트 설정 확인

### 기타 문제
- [GITHUB_SETUP_GUIDE.md](./GITHUB_SETUP_GUIDE.md) 참고
- [SETUP_NEW_COMPUTER.md](./SETUP_NEW_COMPUTER.md) 참고

---

**마지막 업데이트**: 2025-01-XX

