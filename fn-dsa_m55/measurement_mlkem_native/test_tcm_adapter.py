"""Regression tests for GDB script generation; no debugger/board is started."""
import unittest
from exec_with_tcm_init import build_run_script


class TcmAdapter(unittest.TestCase):
    def setUp(self):
        self.lines = build_run_script(port=3349,
            bootargs_break='*0x10001000', reset_handler_jump='*0x10002001',
            hardfault_break='*0x10003000', done_break='*0x10004000',
            argv_bin='/private/tmp/not-used.bin', arg_block_addr='0x340b0000',
            arg_block_sym='mlk_bootargs_block')

    def test_no_duplicate_fault_breakpoint_on_continue(self):
        lines = self.lines
        early = lines.index('hbreak *0x10003000')
        delete = lines.index('delete $early_fault_bp')
        runtime = lines.index('break *0x10003000')
        self.assertLess(early, lines.index('jump *0x10002001'))
        self.assertLess(lines.index('set $early_fault_bp = $bpnum'), delete)
        self.assertLess(delete, runtime)
        self.assertLess(runtime, lines.index('continue'))

    def test_ecc_reads_bracket_main_and_precede_reset(self):
        lines = self.lines
        start = lines.index('echo TCM_MSCR_START=')
        end = lines.index('echo TCM_MSCR_END=')
        self.assertLess(start, lines.index('continue'))
        self.assertGreater(end, lines.index('continue'))
        self.assertEqual(lines[-2:], ['monitor reset_config none', 'monitor reset run'])
        self.assertEqual(lines.count('output/x *(unsigned int*)0xE001E000'), 2)
        self.assertFalse(any('set {' in line for line in lines))


if __name__ == '__main__':
    unittest.main()
