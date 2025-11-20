# 모델 성능 차이 디버깅 가이드

## 문제 상황
- 같은 영상을 넣었을 때 86% → 30%로 성능이 떨어짐
- 모델 로드는 정상적으로 됨

## 확인해야 할 사항

### 1. 모델 파일 확인
```bash
# 모델 파일 크기 확인
ls -lh backend/weights/best_model_tuned.pt

# 모델 파일 해시 확인 (두 컴퓨터에서 비교)
md5sum backend/weights/best_model_tuned.pt
# 또는 Windows에서:
certutil -hashfile backend\weights\best_model_tuned.pt MD5
```

**확인 사항:**
- 파일 크기가 동일한가?
- 파일 해시가 동일한가?
- 파일이 손상되지 않았는가?

### 2. 서버 시작 시 로그 확인

**정상적인 로그:**
```
✓ MesoNet (튜닝된 모델) 로딩 완료
```

**문제가 있는 로그:**
```
⚠ 랜덤 초기화된 모델을 사용합니다
```

### 3. 분석 시 로그 확인

서버 로그에서 다음을 확인:
```
[프레임별 분석 결과]
  프레임 1 (0.0초) [✓]: FAKE (0.85)
  프레임 2 (1.0초) [✓]: FAKE (0.82)
  ...

[최종 결과]
  모델: MesoNet-4 (튜닝된 PyTorch 모델)
  판정: FAKE
  FAKE 확률: 86.0%
  FAKE 프레임 비율: 80% (8/10)
```

**확인 사항:**
- 프레임별 확률이 비슷한가?
- 얼굴 감지가 제대로 되는가? (✓ 표시)
- FAKE 프레임 비율이 비슷한가?

### 4. 설정 파일 확인

`backend/app/core/config.py` 확인:
```python
FRAME_SAMPLES = 10  # 추출할 프레임 수
USE_FACE_CROP = True  # 얼굴 crop 사용 여부
IMAGE_SIZE = 256  # 이미지 리사이즈 크기
```

### 5. 패키지 버전 확인

```bash
pip list | findstr "torch opencv numpy pillow"
```

**확인해야 할 패키지:**
- torch >= 2.0.0
- opencv-python >= 4.8.0
- numpy >= 1.24.0
- Pillow >= 10.0.0

### 6. 모델 예측 결과 직접 확인

테스트 스크립트 실행:
```python
# test_model.py
from app.services.model_mesonet import MesoNetBackend
import sys

backend = MesoNetBackend()
if not backend.load_model():
    print("모델 로딩 실패!")
    sys.exit(1)

# 테스트 이미지로 예측
result = backend.predict("test_image.jpg", face_crop=True)
print(f"Label: {result['label']}")
print(f"Fake Prob: {result['fake_prob']:.4f}")
print(f"Real Prob: {result['real_prob']:.4f}")
print(f"Face Detected: {result['face_detected']}")
```

### 7. 가능한 원인

1. **모델 파일이 다름**
   - 해결: 모델 파일을 다시 복사하고 해시 확인

2. **전처리 방식 차이**
   - OpenCV 버전 차이
   - 이미지 리사이즈 방식 차이
   - 해결: 패키지 버전 통일

3. **프레임 샘플링 차이**
   - 영상 길이에 따른 동적 샘플링 차이
   - 해결: 같은 영상으로 테스트

4. **얼굴 감지 차이**
   - 얼굴 감지 실패로 인한 확률 계산 차이
   - 해결: 로그에서 얼굴 감지 상태 확인

5. **확률 계산 로직 차이**
   - 코드 버전 차이
   - 해결: `git pull`로 최신 코드 확인

## 디버깅 명령어

```bash
# 1. 최신 코드 받기
git pull

# 2. 모델 파일 확인
cd backend
python -c "from app.core.config import MESONET_WEIGHTS; from pathlib import Path; print(f'모델 경로: {MESONET_WEIGHTS}'); print(f'파일 존재: {Path(MESONET_WEIGHTS).exists()}'); print(f'파일 크기: {Path(MESONET_WEIGHTS).stat().st_size if Path(MESONET_WEIGHTS).exists() else 0} bytes')"

# 3. 모델 로딩 테스트
python -c "from app.services.model_mesonet import MesoNetBackend; b = MesoNetBackend(); print('로딩 성공!' if b.load_model() else '로딩 실패!')"
```

