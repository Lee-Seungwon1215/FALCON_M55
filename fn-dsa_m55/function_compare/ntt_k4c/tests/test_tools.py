import importlib.util
from pathlib import Path
import sys
import unittest
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT))
import extract
import run
import audit
import report

def synthetic():
    lines=['COMPARE_BEGIN batches=10 calls=100 primes=308 patterns=8',
      'HW cpu=800000000 sysclk=400000000 hclk=200000000 ccr=00000611 itcmcr=00000049 dtcmcr=00000049',
      'TIMER wait_us=1000 cycles=800005',
      'CHECK family=mq cases=72 mismatches=0 range_errors=0 canary_errors=0',
      'CHECK family=mp cases=27104 mismatches=0 range_errors=0 canary_errors=0',
      'AUDIT_DONE cases=27176 independent_dft=1548']
    keys=[('mq',l,0,d) for l in (9,10) for d in (0,1)]
    keys += [('mp',l,p,d) for p in range(308) for l in range(4,11) for d in (0,1)]
    for f,l,p,d in keys:
        lines.append(f'BENCH family={f} logn={l} pi={p} dir={d} calls=100 old='+','.join(['2000']*10)+' opt='+','.join(['1000']*10))
    lines += ['COMPARE_DONE records=4316 correctness=PASS timed_outputs=PASS',
              'CFSR=0x0','HFSR=0x0','AFSR=0x0','TCM_MSCR_START=0x1300a',
              'TCM_MSCR_END=0x1300a','TCM_CONTROL_START=0x99','TCM_CONTROL_END=0x99']
    return '\n'.join(lines)

class Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls): cls.raw=synthetic()
    def test_balanced_function(self):
        s='test(unsigned n)\n{ /* } */ const char *s="{"; if(n){n--;} }\n'
        self.assertEqual(extract.function(s,'test'),s.rstrip())
    def test_extraction_matches_source(self):
        outputs,_=extract.outputs()
        for name,text in outputs.items(): self.assertEqual((ROOT/name).read_text(),text,name)
    def test_k4c_is_direct_copy(self):
        import re
        source=(ROOT.parents[1]/'ntt_opt/kgen_mp31_cm55.s').read_text()
        expected=re.sub(r'^\s*\.text\s*$', '\n\t.section .compare.opt_mp,"ax",%progbits',
                        source.replace('fndsa_', 'opt_'), flags=re.M)
        self.assertEqual((ROOT/'optimized/kgen_mp31_cm55.s').read_text(),expected)
    def test_timing_harness_unchanged(self):
        self.assertEqual((ROOT/'bench/main.c').read_bytes(),
                         (ROOT.with_name('ntt')/'bench/main.c').read_bytes())
    def test_valid_parser(self): self.assertEqual(len(run.parse(self.raw)),4316)
    def test_missing_bench(self):
        raw='\n'.join(x for x in self.raw.splitlines() if not x.startswith('BENCH family=mq logn=9 pi=0 dir=0'))
        with self.assertRaises(AssertionError): run.parse(raw)
    def test_duplicate_bench(self):
        line=next(x for x in self.raw.splitlines() if x.startswith('BENCH'))
        with self.assertRaises(AssertionError): run.parse(self.raw+'\n'+line)
    def test_failure_rejected(self):
        with self.assertRaises(AssertionError): run.parse(self.raw+'\nCOMPARE_FAIL what=test')
    def test_wrong_hw_rejected(self):
        with self.assertRaises(AssertionError): run.parse(self.raw.replace('ccr=00000611','ccr=00030611'))
    def test_bad_ecc_rejected(self):
        with self.assertRaises(AssertionError): run.parse(self.raw.replace('TCM_MSCR_END=0x1300a','TCM_MSCR_END=0x1301a'))
    def test_zero_cycle_rejected(self):
        with self.assertRaises(AssertionError): run.parse(self.raw.replace('opt=1000,','opt=0,',1))
    def test_builds_current(self):
        for layout in ('ab','ba'): audit.check(layout)
    def test_median_uses_middle_pair(self):
        self.assertEqual(report.stats([100,200,300,400,500,600,700,800,900,1000]),
                         {'min':1.0,'median':5.5,'max':10.0})
    def test_exit_handshake(self):
        main=(ROOT/'bench/main.c').read_text()
        self.assertNotIn('exit(0)',main)
        self.assertNotIn('exit(1)',main)
        self.assertIn('nucleo_test_done(1)',main)
    def test_completed_board_sessions(self):
        import json
        for layout in ('ab','ba'):
            pointer=ROOT/'results'/layout/'validated.json'
            if not pointer.exists(): self.skipTest('board sessions not available yet')
            data=json.loads(pointer.read_text()); directory=Path(data['run_dir'])
            meta=json.loads((directory/'run.json').read_text())
            self.assertEqual(meta['build_manifest'],audit.check(layout))
            self.assertEqual(audit.sha(directory/'raw.log'),data['raw_sha256'])
            self.assertEqual(len(run.parse((directory/'raw.log').read_text())),4316)

if __name__=='__main__': unittest.main()
