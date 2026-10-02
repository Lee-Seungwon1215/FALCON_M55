# ST 확인 요청 — 제출 준비, 아직 미접수

후속: 사용자는 외부 문의 전 자체 대조를 선택했다. [새 매뉴얼 대조](../manual_crosscheck.md)에서
RAMCFG 관련 의문 일부를 해소했다. 아래 ZIP/문의문은 그 전의 미발송 초안으로
보존하며, 최신 결론을 반영한 제출본으로 취급하지 않는다.

현재 상태: **문의문 및 첨부 자료 작성 완료용 패키지. ST 발송/접수/공개 게시를
하지 않았으며, ST 답변이나 티켓 번호는 아직 없다.**

## 제출할 내용

- 제목/본문: [영문 문의문](request_en.md).
- 첨부: `STM32N657_ITCM_ECC_20260910.zip`.
- 제품: STM32N657 / NUCLEO-N657X0-Q.
- 문의 요지: 알려진 칩 결함/영향 revision, 추가 설정 필요 여부,
  wait-state 의존 오류의 내부 원인, 0WS 주파수·VOS 제한, 지원되는 우회책.
- 칩 표면 마킹/실리콘 revision 사진은 아직 확보하지 않았다. ST가 요구하면
  보드/칩 사진으로 추가한다. Cortex-M55 r1p1을 칩 revision으로 적지 않는다.

ST는 [공식 지원 안내](https://www.st.com/content/st_com/en/support/support-home.html)에서
비공개 질문을 [Online Support Center](https://ols.st.com/s/)의 case로 접수하고
티켓으로 추적하도록 안내한다. 공개 커뮤니티와 달리 우선 비공개 기술지원
case로 전달하는 것을 권한다. 현재 연결된 도구에는 ST 포털 로그인/접수 기능이
없으므로, 로그인 및 폼 제출은 사용자가 직접 해야 한다. 비밀번호는 공유하지 않는다.
기존 ST 담당자 이메일이 있다면 그 수신자를 확인한 뒤 별도 전달할 수 있다.

## 첨부 범위와 검증

패키지는 `build_support_bundle.py`로 생성한다. 독립 진단 관련 파일만 허용
목록으로 포함하며 FN-DSA/M4 소스, 키, 측정 입력, 이메일, 로그인 정보는 넣지
않는다. 로컬 사용자 경로와 ST-LINK 시리얼을 제거한다. 원본 로그는 변경하지
않고 외부 전달용 복사본에만 표시된 치환을 적용한다.

원본 69개는 `diagnostics/audit_tcm_root.py`로 먼저 다시 감사한다. 패키지
생성기는 원본 감사 해시를 확인하고, 전달 파일의 해시/원본 해시 대응표를
넣는다. 소스/ELF/명령/입력/출력 바이너리는 원본과 동일한 바이트다.
GDB 스크립트는 덤프 출력 경로만 `replay-output/<series>/...`로 바꾼다.
개인 경로/시리얼이 ZIP에 남았는지도 검사한다.

외부 재현 안내는 기존에 실행한 명령을 이식하기 쉽게 정리한 것이다.
**이 패키지 준비 과정에서 보드를 다시 실행하거나 새로운 성능 측정을 하지 않았다.**
외부 환경에서의 재실행은 아직 검증되지 않았고, 테스트는 M55 RAM 초기화 및
리셋을 수행하므로 다른 작업과 동시에 실행하면 안 된다. 특히 800 MHz에서
wait-state 해제 시험을 그대로 실행하지 않는다.

## 참고 문서

- [로컬 원인 조사 보고서](../root_cause_waitstate.md).
- [ST ES0620](https://www.st.com/resource/en/errata_sheet/es0620-stm32n6xxxx-device-errata-stmicroelectronics.pdf).
- [ST DS14791, 표 24](https://www.st.com/resource/en/datasheet/stm32n657x0.pdf).
- [Arm Cortex-M55 r1p1 TRM](https://documentation-service.arm.com/static/6622c173fabc8c11c7b53a92).

ST 답변을 받으면 원문을 보존하고, 추정 원인과 공식 확인 내용을 구분해 기존
원인 보고서를 갱신한다. 답변 없이 칩 결함 또는 800 MHz 0WS 해결을 확정하지 않는다.
