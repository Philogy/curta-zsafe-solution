from typing import Generator, Optional, Self
import os
from Crypto.Hash import keccak
from attrs import define
from random import randint


# secp256k1 parameters
F_p = 0xFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFE_FFFFFC2F
n = 0xFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFE_BAAEDCE6_AF48A03B_BFD25E8C_D0364141


@define
class Int:
    inner: int

    def __add__(self, other: Self) -> 'Int':
        return Int((self.inner + other.inner) % F_p)

    def __mul__(self, other: Self) -> 'Int':
        return Int((self.inner * other.inner) % F_p)

    def __truediv__(self, other: Self) -> 'Int':
        return self * (other ** -1)

    def __pow__(self, e: int) -> 'Int':
        # Python's `pow` built-in supports modular arithmetic
        return Int(pow(self.inner, e, F_p))

    def __neg__(self) -> 'Int':
        return Int((-self.inner) % F_p)

    def __sub__(self, other: Self) -> 'Int':
        return self + -other

    def sqrt(self) -> Generator['Int', None, None]:
        """
        Compute the square root of the number modulo F_p, if it exists.

        :return: The square root of the number modulo F_p, or None if no square root exists.
        """
        # The square root exists if the number is a quadratic residue modulo F_p.
        # We can check this using Euler's criterion, which states that a number
        # n is a quadratic residue modulo p if and only if n^((p - 1) / 2) ≡ 1 (mod p).
        if pow(self.inner, (F_p - 1) // 2, F_p) != 1:
            return None
        x = Int(pow(self.inner, (F_p + 1) // 4, F_p))
        yield x
        yield -x


@define
class Point:
    x: int
    y: int

    def coords(self) -> tuple[Int, Int]:
        return Int(self.x), Int(self.y)

    def __neg__(self) -> 'Point':
        return Point(self.x, (-self.y) % F_p)._validate()

    def __sub__(self, other: Self) -> 'Point':
        return self + -other

    def __add__(self, other: Self) -> 'Point':
        if self.identity():
            return other
        if other.identity():
            return self
        x1, y1 = self.coords()
        x2, y2 = other.coords()
        if x1 == x2:
            # Negation, return identity early
            if y1 != y2:
                return Point(0, 0)
            l = (Int(3) * (x1*x1) + a) / (Int(2) * y1)
        else:
            l = (y2 - y1) / (x2 - x1)
        x3 = l**2 - x1 - x2
        y3 = l * (x1 - x3) - y1
        return Point(x3.inner, y3.inner)._validate()

    def __mul__(self, x: int) -> 'Point':
        x = x % n
        y: 'Point' = Point(0, 0)  # 0
        acc: 'Point' = self
        for _ in range(x.bit_length()):
            if x & 1:
                y += acc
            x >>= 1
            acc += acc
        return y

    def __rmul__(self, x: int) -> 'Point':
        return self * x

    def _validate(self) -> 'Point':
        x, y = self.coords()
        assert self.identity() or y * y == x**3 + a * x + b
        return self

    def identity(self):
        return self.x == 0 and self.y == 0

    def as_address(self) -> str:
        hash = keccak.new(digest_bits=256)
        hash.update(self.x.to_bytes(32, 'big'))
        hash.update(self.y.to_bytes(32, 'big'))
        return f'0x{hash.digest()[12:32].hex()}'


G = Point(
    0x79BE667E_F9DCBBAC_55A06295_CE870B07_029BFCDB_2DCE28D9_59F2815B_16F81798,
    0x483ADA77_26A3C465_5DA4FBFC_0E1108A8_FD17B448_A6855419_9C47D08F_FB10D4B8
)
a = Int(0)
b = Int(7)


@ define
class Sig:
    v: int
    r: int
    s: int


def sign(sk: int, z: int) -> Sig:
    k = randint(0, n-1)
    big_k = k * G
    v = 27 + big_k.y % 2
    r = big_k.x % n

    s = ((z + r * sk) * pow(k, -1, n)) % n

    return Sig(v, r, s)


def keccak256(preimage: bytes) -> bytes:
    hash = keccak.new(digest_bits=256)
    hash.update(preimage)
    return hash.digest()


def ecrecover(z: int, v: int, r: int, s: int) -> Point:
    r_inv = pow(r, -1, n)
    u1 = (-z * r_inv) % n
    u2 = (s * r_inv) % n

    R = valid_point(v, r)
    assert R.x % n == r
    Q = u1 * G + u2 * R
    assert not Q.identity()
    return Q


def valid_point(v: int, r: int) -> Point:
    points = [
        p
        for p in valid_points(Int(r))
        if p.y % 2 + 27 == v
    ]
    assert len(points) == 1
    return points[0]


def valid_points(x: Int) -> Generator[Point, None, None]:
    """
    Attempt to recover a point given an x-coordinate and whether the y-coordinate is odd.

    :param x: The x-coordinate of the point.
    :return: The recovered Point or None if recovery is not possible.
    """

    # Calculate the right-hand side of the curve equation y^2 = x^3 + ax + b
    rhs = x**3 + a * x + b

    for y in rhs.sqrt():
        assert y**2 == rhs
        p = Point(x.inner, y.inner)._validate()
        assert not p.identity()
        yield p


def recover_verif():
    k = 0x648c8b10cf8a2d7f56409f7260f42154d15e3fd4bf8a9991f2542083f92ac75d

    v = 27
    z = M2
    r = 0x6da360f3ede7e6d327e539b3378888a3425c336a90d5c514a7f866af73ac362f
    s = 0x339cffe6f0ff019c7533306eead8cb55dd33c81142f0f7b7c5052648fb4f691e

    assert r == (k * G).x % n, 'Invalid k <> r'

    da = ((s * k - z) * pow(r, -1, n)) % n
    pub = da * G

    print(f'z: 0x{z:064x}')
    print(f'v: {v}')
    print(f'r: 0x{r:064x}')
    print(f's: 0x{s:064x}')

    print('\nreconstructed:')
    print(f'pub: {pub}')
    print(f'key: 0x{da:064x}')
    print(f'addr: {pub.as_address()}')

    print(f'\necrecover:')
    rec_pub = ecrecover(z, v, r, s)
    print(f'pub: {rec_pub}')
    print(f'addr: {rec_pub.as_address()}')


SEED = 0x448929bc365512b28e88aec7b1fd95df9285e14ea2a142d10b2eca2b56e0b70f
M1 = 0x403d6f14aa77df2952ab4ce74af57ef2df7f7f390856b2bf3c5909904586d1bd
M2 = 0xadbae117f01e0a3579f0fea07c18b5305811c34020ea795071642263fc95041b

V = 27


@define
class Check:
    owner: str
    r1: int
    p1: int
    p2_1: int
    p2_2: int
    s2: int

    @classmethod
    def rand(cls) -> 'Check':
        k = randint(1, n-1)
        p2_2 = randint(0, (1 << 256) - 1)
        s2 = int.from_bytes(keccak256(
            p2_2.to_bytes(32, 'big')
            + SEED.to_bytes(32, 'big')
        ), 'big')
        big_k = k * G
        r2 = big_k.x % n
        pub = ecrecover(M2, V, r2, s2)

        sk1 = ((s2 * k - M2) * pow(r2, -1, n)) % n
        sk2 = ((-s2 * k - M2) * pow(r2, -1, n)) % n

        sk = sk1 if sk1 * G == pub else sk2
        assert sk * G == pub

        while (sig1 := sign(sk, M1)).v != V:
            pass
        assert sig1.v == V

        assert ecrecover(M1, V, sig1.r, sig1.s) == pub

        r1 = sig1.r
        p1 = (r2 - r1) % (1 << 256)
        p2_1 = sig1.s

        c = Check(pub.as_address(), r1, p1, p2_1, p2_2, s2)

        return c


def main():
    checks = [
        Check.rand()
        for _ in range(3)
    ]
    checks.sort(key=lambda c: c.r1)

    for i, c in enumerate(checks):
        print(f'r[{i}] = 0x{c.r1:064x};')
    print('\n\n')
    for i, c in enumerate(checks):
        print(f'owners[{i}] = {c.owner};')
    for i, c in enumerate(checks):
        print(f'p1s[{i}] = 0x{c.p1:064x};')
    for i, c in enumerate(checks):
        print(f'p2s[{i * 2 + 0}] = 0x{c.p2_1:064x};')
        print(f'// s2: 0x{c.s2:064x}')
        print(f'p2s[{i * 2 + 1}] = 0x{c.p2_2:064x};')

    pub = ecrecover(
        0x403d6f14aa77df2952ab4ce74af57ef2df7f7f390856b2bf3c5909904586d1bd,
        27,
        60317533199200632058469699843143091228002793385953047029848327397917469306468,
        93941836537026390100170617101260662542858263601716471755925248683291534533535
    )
    print(f'addr: {pub.as_address()}')


if __name__ == '__main__':
    main()
