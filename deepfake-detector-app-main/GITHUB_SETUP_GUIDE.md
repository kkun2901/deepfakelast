# GitHub 프로젝트 설정 가이드

이 문서는 GitHub 저장소 `https://github.com/kkun2901/deepfakeend`에서 프로젝트를 받아 설정하는 방법을 설명합니다.

## 📋 목차

1. [프로젝트 클론](#프로젝트-클론)
2. [GitHub에 올라가지 않는 필수 파일](#github에-올라가지-않는-필수-파일)
3. [초기 설정](#초기-설정)
4. [주의사항](#주의사항)

---

## 프로젝트 클론

```bash
git clone https://github.com/kkun2901/deepfakeend.git
cd deepfakeend
```

---

## GitHub에 올라가지 않는 필수 파일

다음 파일들은 보안상의 이유로 GitHub에 올라가지 않습니다. **반드시 수동으로 추가해야 합니다.**

### 1. 모델 가중치 파일 (필수)

**위치**: `backend/weights/`

**필요한 파일**:
- `best_model_tuned.pt` (약 3.32 MB)
  - MesoNet 딥페이크 탐지 모델 가중치
  - **없으면 모델이 랜덤 가중치로 초기화되어 성능이 매우 낮습니다**

**설치 방법**:
1. 기존 컴퓨터에서 `backend/weights/best_model_tuned.pt` 파일 복사
2. 새 컴퓨터의 `backend/weights/` 폴더에 붙여넣기
3. 파일이 제대로 있는지 확인:
   ```bash
   cd backend/weights
   dir best_model_tuned.pt
   ```

**MD5 해시 확인** (선택사항):
```bash
certutil -hashfile backend\weights\best_model_tuned.pt MD5
```
예상 해시: `3154e7094cf8ed2e8e93c3ae6128f364`

---

### 2. Firebase 서비스 계정 키 (필수)

**위치**: `backend/app/core/`

**필요한 파일**:
- `firebase-key.json` 또는 `serviceAccountKey.json`
  - Firebase Storage에 영상 파일을 업로드하기 위한 인증 키
  - **없으면 Firebase Storage 기능이 작동하지 않습니다**

**설치 방법**:
1. Firebase Console (https://console.firebase.google.com) 접속
2. 프로젝트 선택 → 프로젝트 설정 → 서비스 계정
3. "새 비공개 키 생성" 클릭하여 JSON 파일 다운로드
4. 다운로드한 파일을 `backend/app/core/firebase-key.json`으로 저장

**또는** 기존 컴퓨터에서 파일 복사:
```bash
# 기존 컴퓨터에서
copy backend\app\core\firebase-key.json [USB 또는 클라우드]

# 새 컴퓨터에서
copy [복사한 경로]\firebase-key.json backend\app\core\firebase-key.json
```

**파일 내용 확인** (일부만):
```json
{
  "type": "service_account",
  "project_id": "deepfake-fc59d",
  "private_key_id": "...",
  ...
}
```

---

### 3. Android 서명 키 (선택사항)

**위치**: `frontend/android/app/`

**필요한 파일**:
- `debug.keystore` (개발용)
  - Android 앱 서명에 사용
  - **없으면 자동으로 생성되지만, 기존 앱과 호환되지 않을 수 있습니다**

**설치 방법**:
- 개발 환경에서는 자동 생성 가능
- 프로덕션 빌드 시에는 기존 키를 사용해야 함

---

### 4. 환경 변수 파일 (선택사항)

**위치**: 프로젝트 루트

**필요한 파일**:
- `.env` (백엔드 환경 변수)
- `.env.local` (프론트엔드 환경 변수)

**설치 방법**:
- 필요 시 `.env.example` 파일을 참고하여 생성
- 현재는 대부분의 설정이 코드에 하드코딩되어 있음

---

## 초기 설정

### 1. 백엔드 설정

```bash
cd backend

# 가상 환경 생성 및 활성화
python -m venv venv
venv\Scripts\activate  # Windows
# source venv/bin/activate  # Linux/Mac

# 패키지 설치
pip install -r requirements.txt

# 모델 가중치 파일 확인
dir weights\best_model_tuned.pt

# Firebase 키 파일 확인
dir app\core\firebase-key.json
```

### 2. 프론트엔드 설정

```bash
cd frontend

# 패키지 설치
npm install

# Android 빌드 설정 (처음 한 번만)
cd android
.\gradlew.bat clean
cd ..
```

### 3. 서버 실행 테스트

**백엔드**:
```bash
cd backend
.\run_server.bat
# 또는
venv\Scripts\activate
python -m uvicorn app.main:app --host 0.0.0.0 --port 8000
```

**프론트엔드**:
```bash
cd frontend
npm start
```

---

## 주의사항

### ⚠️ 보안 관련

1. **모델 가중치 파일**
   - `.pt`, `.pth`, `.h5` 파일은 `.gitignore`에 의해 제외됨
   - **절대 GitHub에 커밋하지 마세요**
   - 파일 크기가 커서 Git에 적합하지 않음

2. **Firebase 키 파일**
   - `firebase-key.json`, `*-key.json` 파일은 `.gitignore`에 의해 제외됨
   - **절대 GitHub에 커밋하지 마세요**
   - 유출 시 Firebase 프로젝트에 무단 접근 가능

3. **개인 정보**
   - API 키, 비밀번호 등은 코드에 하드코딩하지 마세요
   - 환경 변수나 설정 파일 사용 권장

### ⚠️ 성능 관련

1. **모델 파일 없이 실행 시**
   - 모델이 랜덤 가중치로 초기화됨
   - 탐지 성능이 매우 낮음 (거의 랜덤 수준)
   - 반드시 `best_model_tuned.pt` 파일을 추가해야 함

2. **Firebase 키 없이 실행 시**
   - Firebase Storage 업로드 기능이 작동하지 않음
   - 영상 분석은 가능하지만 저장 기능은 비활성화됨

### ⚠️ 버전 호환성

1. **Python 버전**
   - Python 3.8 이상 필요
   - 권장: Python 3.10

2. **Node.js 버전**
   - Node.js 18 이상 필요
   - 권장: Node.js 20

3. **패키지 버전**
   - `requirements.txt`와 `package.json`에 명시된 버전 사용 권장
   - 특히 PyTorch, OpenCV 버전이 중요함

### ⚠️ 플랫폼별 차이

1. **Windows**
   - 경로 구분자: `\` (백슬래시)
   - 실행 파일: `.bat` 파일 사용

2. **Linux/Mac**
   - 경로 구분자: `/` (슬래시)
   - 실행 파일: `.sh` 파일 사용 (또는 직접 명령어 실행)

---

## 문제 해결

### 모델 로딩 실패

**증상**: `모델 파일을 찾을 수 없습니다` 오류

**해결**:
1. `backend/weights/best_model_tuned.pt` 파일 존재 확인
2. 파일 경로가 올바른지 확인
3. 파일 권한 확인 (읽기 가능한지)

### Firebase 연결 실패

**증상**: `Firebase Storage 업로드 실패` 오류

**해결**:
1. `backend/app/core/firebase-key.json` 파일 존재 확인
2. Firebase 프로젝트 설정 확인
3. 네트워크 연결 확인

### 얼굴 감지 실패

**증상**: 많은 프레임에서 얼굴 미감지

**해결**:
1. OpenCV 버전 확인: `pip show opencv-python`
2. 이미지 품질 확인 (JPEG 압축 품질 95)
3. 얼굴 감지 파라미터 조정 (코드에서 완화 가능)

---

## 추가 리소스

- [SETUP_NEW_COMPUTER.md](./SETUP_NEW_COMPUTER.md) - 상세한 설정 가이드
- [README.md](./README.md) - 프로젝트 개요 및 빠른 시작
- [DEBUG_MODEL_PERFORMANCE.md](./DEBUG_MODEL_PERFORMANCE.md) - 모델 성능 문제 해결

---

## 체크리스트

다른 컴퓨터에서 프로젝트를 받은 후 다음을 확인하세요:

- [ ] `backend/weights/best_model_tuned.pt` 파일 존재
- [ ] `backend/app/core/firebase-key.json` 파일 존재
- [ ] Python 가상 환경 생성 및 패키지 설치 완료
- [ ] Node.js 패키지 설치 완료
- [ ] 백엔드 서버 정상 실행 (`http://localhost:8000`)
- [ ] 프론트엔드 정상 실행
- [ ] 모델 로딩 성공 (서버 로그 확인)
- [ ] 얼굴 감지 정상 작동 (테스트 영상 분석)

---

**마지막 업데이트**: 2025-01-XX

