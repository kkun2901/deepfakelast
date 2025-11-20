# 딥페이크 탐지 앱 (Deepfake Detector App)

Android 모바일 환경에서 실시간으로 딥페이크 영상을 탐지하고 분석하는 통합 애플리케이션입니다.

## 🚀 빠른 시작

### 새 컴퓨터에서 설정하기

**GitHub에서 프로젝트를 받은 경우:** [GITHUB_SETUP_GUIDE.md](./GITHUB_SETUP_GUIDE.md) 파일을 먼저 읽어보세요.

**다른 컴퓨터에서 처음 설정하는 경우:** [SETUP_NEW_COMPUTER.md](./SETUP_NEW_COMPUTER.md) 파일을 참고하세요.

### 필수 파일 확인

GitHub에서 프로젝트를 받은 후, 다음 스크립트로 필수 파일이 있는지 확인하세요:

```powershell
powershell -ExecutionPolicy Bypass -File check_required_files.ps1
```

**필수 파일**:
- `backend/weights/best_model_tuned.pt` - 모델 가중치 (없으면 성능이 매우 낮음)
- `backend/app/core/firebase-key.json` - Firebase 인증 키 (없으면 Storage 기능 작동 안 함)

자세한 내용은 [MISSING_FILES_CHECKLIST.md](./MISSING_FILES_CHECKLIST.md)를 참고하세요.

### 기존 프로젝트 실행

#### 백엔드 서버 실행

**Windows:**
```bash
cd backend
.\run_server.bat
```

**수동 실행:**
```bash
cd backend
venv\Scripts\activate
python -m uvicorn app.main:app --host 0.0.0.0 --port 8000
```

백엔드는 `http://localhost:8000`에서 실행됩니다.

#### 프론트엔드 실행

```bash
cd frontend
npm install  # 처음 한 번만
npm start
```

**Android Studio에서 실행:**
1. Android Studio 열기
2. `frontend/android` 폴더 열기
3. 기기/에뮬레이터 선택 후 Run

## 📁 프로젝트 구조

```
deepfake-detector-app-main/
├── backend/              # Python FastAPI 백엔드
│   ├── app/
│   │   ├── api/         # API 엔드포인트
│   │   ├── core/        # 설정 및 Firebase
│   │   └── services/    # 딥러닝 모델 서비스
│   ├── weights/         # 모델 가중치 (GitHub에 없음)
│   └── requirements.txt
├── frontend/            # React Native + Expo 프론트엔드
│   ├── android/         # Android 네이티브 모듈
│   ├── src/            # 소스 코드
│   └── package.json
├── GITHUB_SETUP_GUIDE.md      # GitHub에서 받은 후 설정 가이드
├── MISSING_FILES_CHECKLIST.md # 필수 파일 체크리스트
└── README.md
```

## 🔑 주요 기능

- **플로팅 위젯**: 다른 앱 위에서 스크린 레코딩 및 즉시 분석
- **비디오 분석**: 갤러리에서 영상 선택하여 분석
- **딥페이크 탐지**: MesoNet 모델을 활용한 정확한 탐지
- **타임라인 시각화**: 프레임별 분석 결과를 시간 구간별로 표시

## 📋 필수 요구사항

- Python 3.8+ (권장: 3.10)
- Node.js 18+ (권장: 20)
- Android Studio (Android 개발용)
- 모델 가중치 파일 (`best_model_tuned.pt`)
- Firebase 서비스 계정 키 (`firebase-key.json`)

## 📚 문서

- [GITHUB_SETUP_GUIDE.md](./GITHUB_SETUP_GUIDE.md) - GitHub에서 받은 후 설정 가이드
- [MISSING_FILES_CHECKLIST.md](./MISSING_FILES_CHECKLIST.md) - 필수 파일 체크리스트
- [SETUP_NEW_COMPUTER.md](./SETUP_NEW_COMPUTER.md) - 새 컴퓨터 설정 가이드
- [DEBUG_MODEL_PERFORMANCE.md](./DEBUG_MODEL_PERFORMANCE.md) - 모델 성능 문제 해결

## ⚠️ 주의사항

### 보안
- 모델 가중치 파일과 Firebase 키는 GitHub에 올라가지 않습니다
- 반드시 수동으로 추가해야 합니다
- 절대 GitHub에 커밋하지 마세요

### 성능
- 모델 파일 없이 실행하면 탐지 성능이 거의 0% 수준입니다
- 반드시 `backend/weights/best_model_tuned.pt` 파일을 추가하세요

## 🔧 문제 해결

### 모델 로딩 실패
- `backend/weights/best_model_tuned.pt` 파일 존재 확인
- 파일 경로 확인

### Firebase 연결 실패
- `backend/app/core/firebase-key.json` 파일 존재 확인
- Firebase 프로젝트 설정 확인

### 기타 문제
- [GITHUB_SETUP_GUIDE.md](./GITHUB_SETUP_GUIDE.md) 참고
- [SETUP_NEW_COMPUTER.md](./SETUP_NEW_COMPUTER.md) 참고

## 📄 라이선스

이 프로젝트는 개인 프로젝트입니다.

## 👤 작성자

kkun2901

---

**마지막 업데이트**: 2025-01-XX

