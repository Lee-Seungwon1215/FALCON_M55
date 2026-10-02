"""Host-only checks of the local 4x4 boundary mapping, not ISA emulation."""
import random
import unittest


def plain_load(a):
    return [a[4*i:4*i+4] for i in range(4)]


def vld4(a):
    return [a[i::4] for i in range(4)]


def plain_store(q):
    return [value for row in q for value in row]


def vst4(q):
    return [q[i][j] for j in range(4) for i in range(4)]


class BoundaryTests(unittest.TestCase):
    def test_forward_boundary(self):
        rng = random.Random(412)
        for _ in range(1000):
            q = [[rng.randrange(1<<31) for _ in range(4)] for _ in range(4)]
            self.assertEqual(vld4(plain_store(q)), plain_load(vst4(q)))

    def test_inverse_boundary(self):
        rng = random.Random(413)
        for _ in range(1000):
            q = [[rng.randrange(1<<31) for _ in range(4)] for _ in range(4)]
            self.assertEqual(plain_load(vst4(q)), vld4(plain_store(q)))

    def test_forward_final_external_order(self):
        a = list(range(16))
        self.assertEqual(vst4(vld4(a)), a)

    def test_tile_partitions_all_sizes(self):
        for logn in range(4,11):
            starts = list(range(0,1<<logn,16))
            touched = [i for start in starts for i in range(start,start+16)]
            self.assertEqual(touched,list(range(1<<logn)))


if __name__ == "__main__":
    unittest.main()
