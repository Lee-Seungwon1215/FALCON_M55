#!/usr/bin/env python3
"""Create a human-readable report from freshly revalidated paired runs."""
import argparse
import csv
import json
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parent
OPERATIONS = ('키생성', '서명', '검증')


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('primary_label')
    parser.add_argument('--confirmation-label')
    args = parser.parse_args()
    labels = [args.primary_label]
    if args.confirmation_label:
        assert args.confirmation_label != args.primary_label
        labels.append(args.confirmation_label)
    results = []
    for label in labels:
        subprocess.run([sys.executable, '-B', str(ROOT/'summarize.py'),
                        '--label', label], check=True, stdout=subprocess.DEVNULL)
        results.append(json.loads((ROOT/'results'/f'comparison-{label}.json').read_text()))
    primary = results[0]
    lines = [
        '# M55_ref 대 K4C 포함 ntt_opt: 전체 API 재측정', '',
        '2026-09-28 실물 NUCLEO-N657X0-Q 재측정. 아래는 **전체 API** 시간이며,',
        'NTT 단독 커널 배율이 아니다. 예전 K2·SLOTHY·FFT 측정값은 합치지 않았다.', '',
        '## 주 결과', '',
        '원본은 `../M55_ref`, 최적화는 `../ntt_opt`이다. 최적화에는 공통 q-NTT와',
        '**K4C RNS NTT/iNTT**가 들어 있고, FFT 최적화 및 SLOTHY는 없다.',
        '암호 구현 자체는 이번 측정에서 수정하지 않았다.', '',
        '각 칸은 **100회 산술평균 cycles/call**이다. 고정 입력 10개를 각각 10회 측정했다.',
        '감소율 = `(원본 − 최적화) / 원본 × 100`, 배율 = `원본 / 최적화`.', '',
        '| 크기 | 전체 연산 | M55_ref cycles | ntt_opt cycles | 사이클 감소율 | 속도 배율 |',
        '| --- | --- | ---: | ---: | ---: | ---: |',
    ]
    for degree in (512, 1024):
        for op, name in enumerate(OPERATIONS):
            c = primary['comparison'][f'{degree}_{op}']
            lines.append(f"| {degree} | {name} | {c['ref_mean']:,.2f} | {c['final_mean']:,.2f} | {c['cycle_reduction_percent']:.4f}% | {c['speedup']:.6f}배 |")
    lines += ['', '## 동일 조건과 배치 확인', '',
        '- CPU/SYSCLK/HCLK: 800/400/200 MHz. I/D 캐시 OFF, TCM ECC ON.',
        '- ITCM 코드, DTCM 상수·데이터·스택. TCM 각각 256 KiB.',
        '- GCC 15.2.1, `-O3`, 원본 M4 어셈블리 ON. 동일 메시지·seed·측정 프로그램.',
        '- 입력별/연산별 워밍업 10회 후 10회를 한 블록으로 계측한다.',
        '- IRQ 및 SysTick 활성화. 64-bit cycle timer를 DWT와 교차 확인했다.',
        '- 키 후보 재시도·인코딩 등 API 내부 작업을 포함한다. seed 준비·digest·변조 검사는 제외한다.',
        '- 100개 서로 다른 seed의 평균은 아니다. 과거 다른 입력 집합의 절대 사이클과 직접 혼합하면 안 된다.',
        '- 두 ELF의 공통 함수 256개, 공통 데이터 심볼 146개 및 작업 버퍼·스택 주소가 일치한다.',
        '- q-NTT/RNS 코드 및 NTT 상수에는 같은 크기의 영역을 예약했다. 변경된 영역 내부 주소까지 동일하지는 않다.',
        '- 빌드 출력의 FLASH/RAM은 링크 영역 이름이다. 실제 실행 주소는 ITCM `0x10000000`, DTCM `0x30000000`이다.', '',
        '## 정확성 및 반복 확인', '',
        '각 실행 전 같은 ELF의 pilot를 통과했다. 본 측정의 출력 digest 22줄(크기별 10개 입력과',
        '누적 digest)이 host 기준과 일치하고 두 구현끼리도 일치한다. 정상 서명 검증 및 변조',
        '서명 거절을 통과했으며 q-NTT 직접 비교·왕복 오차는 0이다. 최적화 Barrett 표 검사도 통과했다.',
        'ECC는 시작/종료 모두 ON이고 CFSR/HFSR/AFSR는 0이다.', '',
        '이것은 이번 입력 집합의 정확성 검사이며 전체 공식 KAT, 모든 입력의 동등성 또는',
        '상수시간 증명을 새로 수행했다는 뜻은 아니다. RNS 상세 커널 검증은',
        '[독립 커널 결과](../function_compare/ntt_k4c/result.md)를 참조한다.', '',
    ]
    if len(results) == 2:
        repeat = results[1]
        assert primary['order'] == list(reversed(repeat['order'])), 'Confirmation must reverse order'
        for variant in ('ref', 'ntt_opt'):
            for key in ('elf_sha256', 'source_tree_sha256'):
                assert primary['timing'][variant][key] == repeat['timing'][variant][key]
        lines += ['동일 ELF/입력으로 실행 순서를 뒤집어 각 연산 100회를 한 번 더 측정했다.',
            '**주 표는 첫 100회 결과이며**, 확인 반복을 합쳐 다른 모집단처럼 표시하지 않았다.', '',
            '| 크기 | 연산 | 1차 감소율 | 역순 반복 감소율 | 원본 평균 변화(cycles) | 최적화 평균 변화(cycles) |',
            '| --- | --- | ---: | ---: | ---: | ---: |']
        for degree in (512, 1024):
            for op, name in enumerate(OPERATIONS):
                key = f'{degree}_{op}'
                p, r = primary['comparison'][key], repeat['comparison'][key]
                db = r['ref_mean']-p['ref_mean']
                do = r['final_mean']-p['final_mean']
                lines.append(f"| {degree} | {name} | {p['cycle_reduction_percent']:.4f}% | {r['cycle_reduction_percent']:.4f}% | {db:+.2f} | {do:+.2f} |")
    lines += ['', '## 원시 로그와 재현 자료', '']
    for result in results:
        lines += [f"### {result['label']} — {' → '.join(result['order'])}", '']
        for variant in ('ref', 'ntt_opt'):
            run = result['runs'][variant]
            timing = result['timing'][variant]
            lines.append(f"- `{variant}`: {timing['started_utc']} → {timing['ended_utc']} (UTC). [raw.log]({run}/raw.log), [run.json]({run}/run.json), [소스·빌드 해시]({run}/provenance.json)")
        lines += [f"- [기계 판독 결과](results/comparison-{result['label']}.json)", '']
    lines += ['- [메모리 배치 검사](results/layout_audit.json)',
              '- [전체 BATCH 원시 사이클 CSV](results/api-batches.csv)',
              '- [빌드·실행 방법](README.md)', '',
              '각 실행 폴더에는 실제 ELF·map·config·소스 사본도 보존한다.', '',
              'NTT 단독 3~4배와 전체 API 배율이 다른 이유는 나머지 NTRU/FFT/샘플러/SHAKE 등은',
              '이번 최적화 대상이 아니기 때문이다. 이 실행은 연산비중 프로파일링이 아니라 API 성능 비교다.', '']
    (ROOT/'result.md').write_text('\n'.join(lines))
    with (ROOT/'results/api-batches.csv').open('w', newline='') as output:
        writer = csv.writer(output)
        writer.writerow(('label', 'variant', 'degree', 'operation', 'batch', 'calls', 'total_cycles', 'mean_cycles'))
        for result in results:
            for variant, relative in result['runs'].items():
                record = json.loads((ROOT/relative/'run.json').read_text())
                for sample in record['samples']:
                    writer.writerow((result['label'], variant, sample['degree'],
                                     OPERATIONS[sample['operation']], sample['batch'], 10,
                                     sample['total'], sample['total']/10))
    print(ROOT/'result.md')


if __name__ == '__main__':
    main()
